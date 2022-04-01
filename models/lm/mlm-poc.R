## Multiple linear regression

library(tidyverse)  # data manipulation and visualization
library(modelr)     # provides easy pipeline modeling functions
library(broom)      # helps to tidy up model outputs
library(rsample)    # data splitting

data <- read.csv("data/p_2.5.csv")
data$x <- NULL
data$y <- NULL
data$X <- NULL

set.seed(123)
split <- initial_split(data, prop = .7)
train <- training(split)
test  <- testing(split)

model1 <- lm(YIELD ~ NDVI, data = train)
model2 <- lm(YIELD ~ ., data = train)

summary(model2)

########### Assessing coeff -----------

tidy(model2)
# confint(model2)

########### Comparison -----------

# list(model1 = broom::glance(model1), model2 = broom::glance(model2))

########### Assessing accuracy -----------


test %>%
  gather_predictions(model1, model2) %>%
  group_by(model) %>%
  summarise(MSE = mean((YIELD-pred)^2))


# ########### Assessing Interactions -----------
#
# # option A
# model3a <- models(YIELD ~ ELEV + MOIST + ELEV * MOIST, data = train)
#
# # option B
# model3b <- models(YIELD ~ ELEV * MOIST, data = train)
# list(model1 = broom::glance(model1),
#      model2 = broom::glance(model2),
#      model3a = broom::glance(model3a),
#      model3b = broom::glance(model3b)
# )