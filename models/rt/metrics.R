write_MSE <- function(model, test_set, train_set, round) {

  trainMSE <- RMSE(pred = predict(model, newdata = train_set), obs = train_set$YIELD)^2
  writeLines(paste0("trainMSE = ", round(trainMSE,round)))

  testMSE <- RMSE(pred = predict(model, newdata = test_set), obs = test_set$YIELD)^2
  writeLines(paste0("testMSE = ", round(testMSE,round)))

}