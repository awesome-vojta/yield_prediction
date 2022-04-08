## Multiple variable regression tree - bagged

library(rsample)     # data splitting
library(dplyr)       # data wrangling
library(rpart)       # performing regression trees
library(rpart.plot)  # plotting regression trees
library(ipred)       # bagging
library(caret)       # bagging

source("models/rt/metrics.R")


assess <- function(path) {
  writeLines(paste0(path))
  data <- read.csv(path)
  set.seed(123)
  data_split <- initial_split(data, prop = .7)
  train <- training(data_split)
  test  <- testing(data_split)

  ctrl <- trainControl(method = "cv",  number = 10)

  model <- train(
    YIELD ~ .,
    data = train,
    method = "treebag",
    trControl = ctrl,
    importance = TRUE
  )
  plot(varImp(model), 20)

  r2 <- model$results$Rsquared
  writeLines(paste0("R^2 = ", round(r2,5)))
  write_MSE(model, test_set = test, train_set = train, round = 5)
  writeLines(paste0(" "))
}

assess("data/p_2.5.csv")
assess("data/p_5.csv")
assess("data/p_7.5.csv")
assess("data/p_10.csv")

assess("data/f_2.5.csv")
assess("data/f_5.csv")
assess("data/f_7.5.csv")
assess("data/f_10.csv")