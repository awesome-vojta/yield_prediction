# Regression trees
library(rsample)     # data splitting
library(dplyr)       # data wrangling
library(rpart)       # performing regression trees
library(rpart.plot)  # plotting regression trees
library(ipred)       # bagging
library(caret)       # bagging

# Create training (70%) and test (30%) sets for the AmesHousing::make_ames() data.

data <- read.csv("data/p_2.5.csv")

set.seed(123)
data_split <- initial_split(data, prop = .7)
train <- training(data_split)
test  <- testing(data_split)


########### Basic implementation -----------

m1 <- rpart(
  formula = YIELD ~ NDVI,
  data    = train,
  method  = "anova"
  )
rpart.plot(m1)
# 5 term-nodes -> 4 partition
plotcp(m1)

r2 <- 1 - sum((train$YIELD - predict(m1))^2) / sum((train$YIELD - mean(train$YIELD))^2)


## fully grown
m2 <- rpart(
  formula = YIELD ~ NDVI,
  data    = train,
  method  = "anova",
  control = list(cp = 0, xval = 10)
)
rpart.plot(m1, )


########### Tuning - grid search -----------



hyper_grid <- expand.grid(
  minsplit = seq(1, 20, 1),
  maxdepth = seq(1, 10, 1) # IMPORTANT: originalni model m1 found optimal depth to be 5
)

models <- list()

for (i in 1:nrow(hyper_grid)) {

  # set.seed(123)

  # get minsplit, maxdepth values at row i
  minsplit <- hyper_grid$minsplit[i]
  maxdepth <- hyper_grid$maxdepth[i]

  # train a model and store in the list
  models[[i]] <- rpart(
    formula = YIELD ~ NDVI,
    data    = train,
    method  = "anova",
    control = list(minsplit = minsplit, maxdepth = maxdepth)
    )
}

# get optimal cp
get_cp <- function(model) {
  min    <- which.min(model$cptable[, "xerror"])
  cp <- model$cptable[min, "CP"]
}

# minimum error
get_min_error <- function(model) {
  min    <- which.min(model$cptable[, "xerror"])
  xerror <- model$cptable[min, "xerror"]
}

opt_grid <- hyper_grid %>%
  mutate(
    cp    = purrr::map_dbl(models, get_cp),
    error = purrr::map_dbl(models, get_min_error)
    ) %>%
  arrange(error) %>%
  top_n(-5, wt = error)

#   minsplit maxdepth   cp     error
# 1       13        5 0.01 0.4223547



# hp optimalniho stromu:
#   minsplit maxdepth         cp     error
# 1        6       10 0.01000000 0.2331321

optimal_tree <- rpart(
    formula = YIELD ~ NDVI,
    data    = train,
    method  = "anova",
    control = list(minsplit = 11, maxdepth = 5, cp = 0.01)
    )

# optimal_r2 <- 1 - sum((ames_train$YIELD - predict(optimal_tree))^2) /
#     sum((ames_train$YIELD - mean(ames_train$YIELD))^2)

pred <- predict(m1, newdata = test)
RMSE(pred = pred, obs = test$YIELD)
# [1] 38595.39






########### Bagging - ipred -----------

# make bootstrapping reproducible
set.seed(123)

# train bagged model
bagged_m1 <- bagging(
  formula = YIELD ~ NDVI,
  data    = train,
  coob    = TRUE
)

bagged_m1
# OOB estimate of RMSE:  36543.37
# bagged_r2 <- 1 - sum((ames_train$YIELD - predict(bagged_m1))^2) /
#     sum((ames_train$YIELD - mean(ames_train$YIELD))^2)

########### Bagging - averaging more trees -----------

# assess 10-50 bagged trees
ntree <- 10:60

# create empty vector to store OOB RMSE values
rmse <- vector(mode = "numeric", length = length(ntree))

for (i in seq_along(ntree)) {
  # reproducibility
  set.seed(123)

  # perform bagged model
  model <- bagging(
  formula = YIELD ~ .,
  data    = train,
  coob    = TRUE,
  nbagg   = ntree[i]
)
  # get OOB error
  rmse[i] <- model$err
}

plot(ntree, rmse, type = 'l', lwd = 2)
abline(v = 51, col = "red", lty = "dashed")

########### Bagging - caret -----------
# caret umoznuje lehci X-validation (X-val se pouziva pro indetifikaci optimalni cp = cost complexity)
# lze vyhodnotit dulezitost promennych

# Specify 10-fold cross validation
ctrl <- trainControl(method = "cv",  number = 10)

# CV bagged model
bagged_cv <- train(
  YIELD ~ NDVI,
  data = train,
  method = "treebag",
  trControl = ctrl,
  importance = TRUE
  )

# assess results
bagged_cv


# plot most important variables
plot(varImp(bagged_cv), 20)



# porovnani natrenovaneho modelu s test setem (nove data)
pred <- predict(bagged_cv, test)
RMSE(pred, test$YIELD)
## [1] 35262.59

