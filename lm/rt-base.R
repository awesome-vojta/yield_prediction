# Regression trees
library(rsample)     # data splitting
library(dplyr)       # data wrangling
library(rpart)       # performing regression trees
library(rpart.plot)  # plotting regression trees
library(ipred)       # bagging
library(caret)       # bagging


########### Model evaluation -----------
get_rmse <- function(tree_model, test_df) {
  pred_m1 <- predict(tree_model, newdata = test_df)
  RMSE(pred = pred_m1, obs = test_df$yield)
}

get_r2 <- function(tree_model, train_df) {
  r2 <- 1 - sum((train_df$yield - predict(tree_model))^2) /
    sum((train_df$yield - mean(train_df$yield))^2)
  return(r2)
}

########### Tune helpers -----------
get_cp <- function(models) {
  min    <- which.min(models$cptable[, "xerror"])
  cp <- models$cptable[min, "CP"]
}

get_min_error <- function(models) {
  min    <- which.min(models$cptable[, "xerror"])
  xerror <- models$cptable[min, "xerror"]
}


########### Basic implementation -----------
get_basic_rt <- function(train_df, formula) {
  m1 <- rpart(
  formula = formula,
  data    = train_df,
  method  = "anova"
  )
  # rpart.plot(m1)
  # plotcp(m1)
}

########### Tuned out tree -----------
get_tuned_rt <- function(training_df, formula, opt_depth) {

  hyper_grid <- expand.grid(
    minsplit = seq(5, 20, 1),
    maxdepth = seq(opt_depth-(opt_depth/2), opt_depth+(opt_depth/2), 1) # explore values around optimal depth
  )

  models <- list()
  for (i in 1:nrow(hyper_grid)) {
    # reproducibility
    # set.seed(123)

    # get minsplit, maxdepth values at row i
    minsplit <- hyper_grid$minsplit[i]
    maxdepth <- hyper_grid$maxdepth[i]

    # train a model and store in the list
    models[[i]] <- rpart(
      formula = formula,
      data    = training_df,
      method  = "anova",
      control = list(minsplit = minsplit, maxdepth = maxdepth)
    )
  }

  get_cp(models)
  get_min_error(models)

  params <-
  hyper_grid %>%
  mutate(
    cp    = purrr::map_dbl(models, get_cp),
    error = purrr::map_dbl(models, get_min_error)
    ) %>%
  arrange(error) %>%
  top_n(-5, wt = error)

  optimal_tree <- rpart(
    formula = yield ~ NDVI,
    data    = fields_train,
    method  = "anova",
    control = list(minsplit = params$minsplit[1], maxdepth = params$maxdepth[1], cp = 0.01)
  )
  return(optimal_tree)
}

########### Bagging - averaging more trees -----------
plot_bagging_rt <-function(training_df, formula) {

  ntree <- 10:50

  # create empty vector to store OOB RMSE values
  rmse <- vector(mode = "numeric", length = length(ntree))

  for (i in seq_along(ntree)) {
    # reproducibility
    set.seed(123)

    # perform bagged model
    model <- bagging(
    formula = formula,
    data    = training_df,
    coob    = TRUE,
    nbagg   = ntree[i]
  )
    # get OOB error
    rmse[i] <- model$err
  }
  plot(ntree, rmse, type = 'l', lwd = 2)
}

