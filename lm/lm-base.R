library(tidyverse)  # data manipulation and visualization
library(modelr)     # provides easy pipeline modeling functions
library(broom)      # helps to tidy up model outputs


load("lm/fields/fields_with_others_5_p.Rda")
fields_with_others_5_p$x <- NULL
fields_with_others_5_p$y <- NULL
data <- fields_with_others_5_p

res <- summary(
  lm(
    formula = yield ~ .,
    data = data
  )
)
tidy(res)