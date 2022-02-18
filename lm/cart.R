library(randomForest)
source("lm/read-rasters.R")

ozone.rf <- randomForest(Ozone ~ ., data = airquality, mtry = 3,
                         importance = TRUE, na.action = na.omit)

print(ozone.rf)