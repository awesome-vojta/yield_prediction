library(rsample)     # data splitting
library(dplyr)       # data wrangling
library(rpart)       # performing regression trees
library(rpart.plot)  # plotting regression trees
library(ipred)       # bagging
library(caret)       # bagging


load("lm/fields/fields_with_others_5_p.Rda")
fields_with_others_5_p$x <- NULL
fields_with_others_5_p$y <- NULL
data <- fields_with_others_5_p

set.seed(123)
split <- initial_split(data, prop = .7)
train <- training(split)
test  <- testing(split)



# Specify 10-fold cross validation
ctrl <- trainControl(method = "cv",  number = 10)

# CV bagged model
bagged_cv <- train(
  yield ~ .,
  data = train,
  method = "treebag",
  trControl = ctrl,
  importance = TRUE
  )

# assess results
bagged_cv
# Bagged CART
#
# 15296 samples
#     6 predictor
#
# No pre-processing
# Resampling: Cross-Validated (10 fold)
# Summary of sample sizes: 13767, 13768, 13766, 13765, 13766, 13768, ...
# Resampling results:
#
#   RMSE      Rsquared   MAE
#   1.309835  0.6383492  0.9176921
plot(varImp(bagged_cv), 6)
