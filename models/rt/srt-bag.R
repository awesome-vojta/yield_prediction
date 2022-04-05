## Single variable regression tree - bagged

library(rsample)     # data splitting
library(dplyr)       # data wrangling
library(rpart)       # performing regression trees
library(rpart.plot)  # plotting regression trees
library(ipred)       # bagging
library(caret)       # bagging

assess <- function(path, index) {
  stopifnot(index == "NDVI" | index == "EVI")
  if(index == "NDVI") {
    formula <- YIELD ~ NDVI
    writeLines(paste0(path, " YIELD ~ NDVI"))
  } else {
    formula <- YIELD ~ EVI
    writeLines(paste0(path, " YIELD ~ EVI"))
  }

  data <- read.csv(path)
  set.seed(123)
  data_split <- initial_split(data, prop = .7)
  train <- training(data_split)
  test  <- testing(data_split)

  ctrl <- trainControl(method = "cv",  number = 10)

  # cross-validated bagged model
  m1 <- train(
    formula,
    data = train,
    method = "treebag",
    trControl = ctrl,
    importance = TRUE
    )

  r2 <- m1$results$Rsquared
  trainMSE <- sqrt(RMSE(pred = predict(m1, newdata = train), obs = train$YIELD))
  testMSE <- sqrt(RMSE(pred = predict(m1, newdata = test), obs = test$YIELD))

  writeLines(paste0("R^2 = ", round(r2,5)))
  writeLines(paste0("trainMSE = ", round(trainMSE,5)))
  writeLines(paste0("testMSE = ", round(testMSE,5)))
  writeLines(paste0(" "))
}

assess("data/p_2.5.csv", "NDVI")
assess("data/p_2.5.csv", "EVI")
assess("data/p_5.csv", "NDVI")
assess("data/p_5.csv", "EVI")
assess("data/p_7.5.csv", "NDVI")
assess("data/p_7.5.csv", "EVI")
assess("data/p_10.csv", "NDVI")
assess("data/p_10.csv", "EVI")

assess("data/f_2.5.csv", "NDVI")
assess("data/f_2.5.csv", "EVI")
assess("data/f_5.csv", "NDVI")
assess("data/f_5.csv", "EVI")
assess("data/f_7.5.csv", "NDVI")
assess("data/f_7.5.csv", "EVI")
assess("data/f_10.csv", "NDVI")
assess("data/f_10.csv", "EVI")