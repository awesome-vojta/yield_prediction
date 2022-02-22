# Regression trees
library(rsample)     # data splitting
library(dplyr)       # data wrangling
library(rpart)       # performing regression trees
library(rpart.plot)  # plotting regression trees
library(ipred)       # bagging
library(caret)       # bagging

load("lm/fields/fields_5_p.Rda")
load("lm/fields/fields_5_f.Rda")

set.seed(42)
fields_split <- initial_split(fields_5_p, prop = .7)
fields_train <- training(fields_split)
fields_test  <- testing(fields_split)

########### Basic implementation -----------

m1 <- rpart(
  formula = yield ~ NDVI,
  data    = fields_train,
  method  = "anova"
  )
rpart.plot(m1)
plotcp(m1)

pred_m1 <- predict(m1, newdata = fields_test)
RMSE(pred = pred_m1, obs = fields_test$yield)

r2 <- 1 - sum((fields_train$yield - predict(m1))^2) /
    sum((fields_train$yield - mean(fields_train$yield))^2)
r2









########### Tuning -----------

hyper_grid <- expand.grid(
  minsplit = seq(5, 20, 1),
  maxdepth = seq(2, 6, 1)
)

models <- list()

for (i in 1:nrow(hyper_grid)) {

  # get minsplit, maxdepth values at row i
  minsplit <- hyper_grid$minsplit[i]
  maxdepth <- hyper_grid$maxdepth[i]

  # train a model and store in the list
  models[[i]] <- rpart(
    formula = yield ~ NDVI,
    data    = fields_5_p,
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

# best hyperparameters are:
#  minsplit maxdepth   cp     error
# 1       17        3 0.01 0.4419978

optimal_tree <- rpart(
    formula = yield ~ NDVI,
    data    = fields_train,
    method  = "anova",
    control = list(minsplit = 17, maxdepth = 3, cp = 0.01)
    )



pred_optimal <- predict(optimal_tree, newdata = fields_test)
RMSE(pred = pred_optimal, obs = fields_test$yield)
optimal_r2 <- 1 - sum((fields_train$yield - predict(optimal_tree))^2) /
    sum((fields_train$yield - mean(fields_train$yield))^2)
optimal_r2








########### Bagging - averaging more trees -----------
ntree <- 10:50

# create empty vector to store OOB RMSE values
rmse <- vector(mode = "numeric", length = length(ntree))

for (i in seq_along(ntree)) {
  # reproducibility
  set.seed(123)

  # perform bagged model
  model <- bagging(
  formula = yield ~ NDVI,
  data    = fields_train,
  coob    = TRUE,
  nbagg   = ntree[i]
)
  # get OOB error
  rmse[i] <- model$err
}

plot(ntree, rmse, type = 'l', lwd = 2)
abline(v = 33, col = "red", lty = "dashed")

optimal_bagged <- bagging(
  formula = yield ~ NDVI,
  data    = fields_train,
  coob    = TRUE,
  nbagg   = 33
)

pred_optimal_bag <- predict(optimal_bagged, newdata = fields_test)
RMSE(pred = pred_optimal_bag, obs = fields_test$yield)
optimal_bag_r2 <- 1 - sum((fields_train$yield - predict(optimal_bagged))^2) /
    sum((fields_train$yield - mean(fields_train$yield))^2)
optimal_bag_r2


# not even bagging shows significant improvement


