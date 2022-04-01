# process percentile filtered dataset ("..._p.Rda")

load("lm/fields/fields_5_p.Rda")
load("lm/fields/fields_10_p.Rda")
source("rt-base.R")

set.seed(123)
fields_split <- initial_split(fields_5_p, prop = .7)
fields_train <- training(fields_split)
fields_test  <- testing(fields_split)

print("lm/fields/fields_5_p.Rda")
########### Basic RT -----------
basic_rt <- get_basic_rt(fields_train, yield~NDVI)
get_rmse(basic_rt, fields_test)
# 1.472864
get_r2(basic_rt, fields_train)
# 0.5609033
rpart.plot(basic_rt, roundint=FALSE)
plotcp(basic_rt)
# 4 is optimal size, pass into get_tuned_rt()

########### Tuned RT -----------
tuned_rt <- get_tuned_rt(fields_train, yield~NDVI, 4)
get_rmse(tuned_rt, fields_test)
# 1.472864
get_r2(tuned_rt, fields_train)
# 0.5609033
rpart.plot(tuned_rt, roundint=FALSE)
plotcp(tuned_rt)

########### Bagged RT -----------
plot_bagging_rt(fields_train, yield~NDVI)
abline(v = 23, col = "red", lty = "dashed")
bagged_rt <- bagging(
  formula = yield ~ NDVI,
  data    = fields_train,
  coob    = TRUE,
  nbagg   = 23
)
get_rmse(bagged_rt, fields_test)
# 1.464241
get_r2(bagged_rt, fields_train)
# 0.5617484









set.seed(123)
fields_split <- initial_split(fields_10_p, prop = .7)
fields_train <- training(fields_split)
fields_test  <- testing(fields_split)

print("lm/fields/fields_10_p.Rda")
########### Basic RT -----------
basic_rt <- get_basic_rt(fields_train, yield~NDVI)
get_rmse(basic_rt, fields_test)
# 1.349912
get_r2(basic_rt, fields_train)
# 0.6029572
rpart.plot(basic_rt, roundint=FALSE)
plotcp(basic_rt)
# 4 is optimal size, pass into get_tuned_rt()

########### Tuned RT -----------
tuned_rt <- get_tuned_rt(fields_train, yield~NDVI, 4)
get_rmse(tuned_rt, fields_test)
# 1.349912
get_r2(tuned_rt, fields_train)
# 0.6029572
rpart.plot(tuned_rt, roundint=FALSE)
plotcp(tuned_rt)

########### Bagged RT -----------
plot_bagging_rt(fields_train, yield~NDVI)
abline(v = 22, col = "red", lty = "dashed")
bagged_rt <- bagging(
  formula = yield ~ NDVI,
  data    = fields_train,
  coob    = TRUE,
  nbagg   = 22
)
get_rmse(bagged_rt, fields_test)
# 1.343511
get_r2(bagged_rt, fields_train)
# 0.6045619
