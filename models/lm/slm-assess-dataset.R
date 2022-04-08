library(tidyverse)  # data manipulation and visualization
library(modelr)     # provides easy pipeline modeling functions
library(broom)      # helps to tidy up model outputs
library(rsample)    # data splitting


assess <- function(path, index) {
  stopifnot(index == "NDVI" || index == "EVI")
  writeLines("")
  writeLines(path)
  writeLines(paste0("YIELD ~ ", index))
  data <- read.csv(path)

  set.seed(123)
  split <- initial_split(data, prop = .7)
  train <- training(split)
  test  <- testing(split)

  if(index == "NDVI") {
    model1 <- lm(YIELD ~ NDVI, data = train)
  } else {
    model1 <- lm(YIELD ~ EVI, data = train)
  }

  ########### Assessing model -----------
  eq <- tidy(model1)
  writeLines(paste0(round(eq$estimate[1],2), " + ", round(eq$estimate[2],2), "x"))

  # RSE
  # prumerna odchylka yieldu je 1.64 tun
  rse <- sigma(model1)
  writeLines(paste0("RSE = ", round(rse,4)))

  # procetni chyba
  err <- sigma(model1)/mean(train$YIELD)
  writeLines(paste0("%err = ", round(err,4)))

  # 43% je proporce rozptylu kterou model dokaze vysvetlit
  r2 <- rsquare(model1, data = train)
  writeLines(paste0("R^2 = ", round(r2,4)))


  test <- test %>%
  add_predictions(model1)

  testMSE <- test %>%
    add_predictions(model1) %>%
    summarise(MSE = mean((YIELD - pred)^2))
  writeLines(paste0("testMSE = ", round(testMSE,4)))

  trainMSE <-train %>%
    add_predictions(model1) %>%
    summarise(MSE = mean((YIELD - pred)^2))
  writeLines(paste0("trainMSE = ", round(trainMSE,4)))
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

