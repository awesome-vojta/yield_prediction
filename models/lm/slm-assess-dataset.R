library(tidyverse)  # data manipulation and visualization
library(modelr)     # provides easy pipeline modeling functions
library(broom)      # helps to tidy up model outputs
library(rsample)    # data splitting

source("models/lm/metrics.R")

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
    model <- lm(YIELD ~ NDVI, data = train)
  } else {
    model <- lm(YIELD ~ EVI, data = train)
  }

  write_lm_assessment(model, test, train, 4)
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

