# process manually filtered dataset ("..._f.Rda")

load("lm/fields/fields_5_f.Rda")
load("lm/fields/fields_10_f.Rda")
source("lm/rt-base.R")

set.seed(123)
fields_split <- initial_split(fields_5_f, prop = .7)
fields_train <- training(fields_split)
fields_test  <- testing(fields_split)

print("lm/fields/fields_5_f.Rda")
########### Basic RT -----------
basic_rt <- get_basic_rt(fields_train, yield~NDVI)
get_rmse(basic_rt, fields_test)
# 1.180013
get_r2(basic_rt, fields_train)
# 0.7416319
rpart.plot(basic_rt, roundint=FALSE)
plotcp(basic_rt)
# 4 is optimal size, pass into get_tuned_rt()

########### Tuned RT -----------
tuned_rt <- get_tuned_rt(fields_train, yield~NDVI, 4)
get_rmse(tuned_rt, fields_test)
# 1.180013
get_r2(tuned_rt, fields_train)
# 0.7416319
rpart.plot(tuned_rt, roundint=FALSE)
plotcp(tuned_rt)

########### Bagged RT -----------
plot_bagging_rt(fields_train, yield~NDVI)
abline(v = 30, col = "red", lty = "dashed")
bagged_rt <- bagging(
  formula = yield ~ NDVI,
  data    = fields_train,
  coob    = TRUE,
  nbagg   = 30
)
get_rmse(bagged_rt, fields_test)
# 1.159735
get_r2(bagged_rt, fields_train)
# 0.7457444









set.seed(123)
fields_split <- initial_split(fields_10_f, prop = .7)
fields_train <- training(fields_split)
fields_test  <- testing(fields_split)

print("lm/fields/fields_10_f.Rda")
########### Basic RT -----------
basic_rt <- get_basic_rt(fields_train, yield~NDVI)
get_rmse(basic_rt, fields_test)
# 1.011556
get_r2(basic_rt, fields_train)
# 0.7624464
rpart.plot(basic_rt, roundint=FALSE)
plotcp(basic_rt)
# 4 is optimal size, pass into get_tuned_rt()

########### Tuned RT -----------
tuned_rt <- get_tuned_rt(fields_train, yield~NDVI, 4)
get_rmse(tuned_rt, fields_test)
# 1.011556
get_r2(tuned_rt, fields_train)
# 0.7624464
rpart.plot(tuned_rt, roundint=FALSE)
plotcp(tuned_rt)

########### Bagged RT -----------
plot_bagging_rt(fields_train, yield~NDVI)
abline(v = 30, col = "red", lty = "dashed")
bagged_rt <- bagging(
  formula = yield ~ NDVI,
  data    = fields_train,
  coob    = TRUE,
  nbagg   = 30
)
get_rmse(bagged_rt, fields_test)
# 1.002391
get_r2(bagged_rt, fields_train)
# 0.7652436
