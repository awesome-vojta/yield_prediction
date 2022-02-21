# Regression trees
library(rsample)     # data splitting
library(dplyr)       # data wrangling
library(rpart)       # performing regression trees
library(rpart.plot)  # plotting regression trees
library(ipred)       # bagging
library(caret)       # bagging

# Create training (70%) and test (30%) sets for the AmesHousing::make_ames() data.

set.seed(123)
ames_split <- initial_split(AmesHousing::make_ames(), prop = .7)
ames_train <- training(ames_split)
ames_test  <- testing(ames_split)


########### Basic implementation -----------

m1 <- rpart(
  formula = Sale_Price ~ .,
  data    = ames_train,
  method  = "anova"
  )
rpart.plot(m1)
# 12 term-nodes -> 11 partition variables
plotcp(m1)

########### Set cost complexity to 0 "cp=0" -----------

m2 <- rpart(
    formula = Sale_Price ~ .,
    data    = ames_train,
    method  = "anova",
    control = list(cp = 0, xval = 10)
)

plotcp(m2)
abline(v = 12, lty = "dashed")

############ Tuning -----------

m3 <- rpart(
    formula = Sale_Price ~ .,
    data    = ames_train,
    method  = "anova",
    # seznam hyperparams (params pro kontrolu uceni)
    # ve skutecnosti neni potreba - musel bys mezi sebou porovnat mega moc stromu
    # -> lepsi je udelat grid search napric mnoha stromy pro identifikaci optimalnich hp
    control = list(
      minsplit = 10, # min N of data points before being forced to create teminal node
      maxdepth = 12, # max N of nodes between root and terminals
      xval = 10)
)
m3$cptable

########### Tuning - grid search -----------

hyper_grid <- expand.grid(
  minsplit = seq(5, 20, 1),
  maxdepth = seq(8, 15, 1) # IMPORTANT: originalni model m1 found optimal depth to be 12
  #128 combinations
)

models <- list()

for (i in 1:nrow(hyper_grid)) {

  # get minsplit, maxdepth values at row i
  minsplit <- hyper_grid$minsplit[i]
  maxdepth <- hyper_grid$maxdepth[i]

  # train a model and store in the list
  models[[i]] <- rpart(
    formula = Sale_Price ~ .,
    data    = ames_train,
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

hyper_grid %>%
  mutate(
    cp    = purrr::map_dbl(models, get_cp),
    error = purrr::map_dbl(models, get_min_error)
    ) %>%
  arrange(error) %>%
  top_n(-5, wt = error)

# hp optimalniho stromu:
#   minsplit maxdepth         cp     error
# 1        6       10 0.01000000 0.2331321

optimal_tree <- rpart(
    formula = Sale_Price ~ .,
    data    = ames_train,
    method  = "anova",
    control = list(minsplit = 6, maxdepth = 10, cp = 0.01)
    )

# optimal_r2 <- 1 - sum((ames_train$Sale_Price - predict(optimal_tree))^2) /
#     sum((ames_train$Sale_Price - mean(ames_train$Sale_Price))^2)

pred <- predict(optimal_tree, newdata = ames_test)
RMSE(pred = pred, obs = ames_test$Sale_Price)
# [1] 38595.39

########### Bagging -----------

# make bootstrapping reproducible
set.seed(123)

# train bagged model
bagged_m1 <- bagging(
  formula = Sale_Price ~ .,
  data    = ames_train,
  coob    = TRUE
)

bagged_m1
# OOB estimate of RMSE:  36543.37
# bagged_r2 <- 1 - sum((ames_train$Sale_Price - predict(bagged_m1))^2) /
#     sum((ames_train$Sale_Price - mean(ames_train$Sale_Price))^2)

########### Bagging - averaging more trees -----------

# assess 10-50 bagged trees
ntree <- 10:50

# create empty vector to store OOB RMSE values
rmse <- vector(mode = "numeric", length = length(ntree))

for (i in seq_along(ntree)) {
  # reproducibility
  set.seed(123)

  # perform bagged model
  model <- bagging(
  formula = Sale_Price ~ .,
  data    = ames_train,
  coob    = TRUE,
  nbagg   = ntree[i]
)
  # get OOB error
  rmse[i] <- model$err
}

plot(ntree, rmse, type = 'l', lwd = 2)
abline(v = 25, col = "red", lty = "dashed")

########### Bagging - caret -----------
# caret umoznuje lehci X-validation (X-val se pouziva pro indetifikaci optimalni cp = cost complexity)
# lze vyhodnotit dulezitost promennych

# Specify 10-fold cross validation
ctrl <- trainControl(method = "cv",  number = 10)

# CV bagged model
bagged_cv <- train(
  Sale_Price ~ .,
  data = ames_train,
  method = "treebag",
  trControl = ctrl,
  importance = TRUE
  )

# assess results
bagged_cv


# plot most important variables
plot(varImp(bagged_cv), 20)



# porovnani natrenovaneho modelu s test setem (nove data)
pred <- predict(bagged_cv, ames_test)
RMSE(pred, ames_test$Sale_Price)
## [1] 35262.59

