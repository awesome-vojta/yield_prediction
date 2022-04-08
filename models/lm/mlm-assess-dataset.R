library(tidyverse)  # data manipulation and visualization
library(modelr)     # provides easy pipeline modeling functions
library(broom)      # helps to tidy up model outputs
library(rsample)    # data splitting

source("models/lm/metrics.R")

assess <- function(path) {
  writeLines("")
  writeLines(path)
  data <- read.csv(path)

  data$x <- NULL
  data$y <- NULL
  data$X <- NULL

  set.seed(123)
  split <- initial_split(data, prop = .7)
  train <- training(split)
  test  <- testing(split)

  model <- lm(YIELD ~ ., data = train)

  write_lm_assessment(model, test, train, 4)
}

assess("data/p_2.5.csv")
assess("data/p_5.csv")
assess("data/p_7.5.csv")
assess("data/p_10.csv")

assess("data/f_2.5.csv")
assess("data/f_5.csv")
assess("data/f_7.5.csv")
assess("data/f_10.csv")
