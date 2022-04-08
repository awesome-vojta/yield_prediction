## Multiple variable regression tree

library(rsample)
library(dplyr)
library(rpart)
library(rpart.plot)
library(caret)

source("models/rt/metrics.R")

get_cp <- function(model) {
  min    <- which.min(model$cptable[, "xerror"])
  cp <- model$cptable[min, "CP"]
}

get_min_error <- function(model) {
  min    <- which.min(model$cptable[, "xerror"])
  xerror <- model$cptable[min, "xerror"]
}


assess <- function(path) {
  writeLines(paste0(path, " YIELD ~ ."))


  data <- read.csv(path)
  data$x <- NULL
  data$y <- NULL
  data$X <- NULL
  set.seed(123)
  data_split <- initial_split(data, prop = .7)
  train <- training(data_split)
  test  <- testing(data_split)

  ########### Basic implementation -----------
  model <- rpart(
    formula = YIELD ~ .,
    data    = train,
    method  = "anova"
    )

  cp <- as.data.frame(model$cptable)
  splits <- cp$nsplit[nrow(cp)]
  r2 <- 1 - cp$`rel error`[nrow(cp)]
  xerr <- cp$xerror[nrow(cp)]

  writeLines(paste0("R^2 = ", round(r2,5)))
  writeLines(paste0("xerr = ", round(xerr,5)))
  write_MSE(model, test_set = test, train_set = train, round = 5)
  writeLines(paste0("splits = ", splits))
  writeLines(paste0(""))



  ########### Tuning - grid search -----------
  hyper_grid <- expand.grid(
    minsplit = seq(5, 20, 1),
    maxdepth = seq(2, 10, 1) # IMPORTANT: originalni model m1 found optimal depth to be 5
  )
  models <- list()

  for (i in 1:nrow(hyper_grid)) {
    # get minsplit, maxdepth values at row i
    minsplit <- hyper_grid$minsplit[i]
    maxdepth <- hyper_grid$maxdepth[i]
    # train a model and store in the list
    models[[i]] <- rpart(
      formula = YIELD ~ .,
      data    = train,
      method  = "anova",
      control = list(minsplit = minsplit, maxdepth = maxdepth)
      )
  }

  opt_grid <- hyper_grid %>%
    mutate(
      cp    = purrr::map_dbl(models, get_cp),
      error = purrr::map_dbl(models, get_min_error)
      ) %>%
    arrange(error) %>%
    top_n(-5, wt = error)


  opt_model <- rpart(
      formula = YIELD ~ .,
      data    = train,
      method  = "anova",
      control = list(minsplit = opt_grid$minsplit[1], maxdepth = opt_grid$maxdepth[1], cp = 0.01)
      )
  opt_cp <- as.data.frame(opt_model$cptable)

  r2 <- 1 - opt_cp$`rel error`[nrow(opt_cp)]
  splits <- opt_cp$nsplit[nrow(opt_cp)]
  xerr <- opt_cp$xerror[nrow(opt_cp)]
  writeLines(paste0("opt R^2 = ", round(r2,5)))
  writeLines(paste0("opt xerr = ", round(xerr,5)))
  write_MSE(opt_model, test_set = test, train_set = train, round = 5)
  writeLines(paste0("splits = ", splits))
  writeLines(paste0("------------"))

}


assess("data/p_2.5.csv")
assess("data/p_5.csv")
assess("data/p_7.5.csv")
assess("data/p_10.csv")

assess("data/f_2.5.csv")
assess("data/f_5.csv")
assess("data/f_7.5.csv")
assess("data/f_10.csv")