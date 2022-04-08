write_lm_assessment <-function(model, test_set, train_set, round) {

  # equation
  eq <- tidy(model)
  writeLines(paste0(round(eq$estimate[1],2), " + ", round(eq$estimate[2],2), "x"))

  # RSE
  rse <- sigma(model)
  writeLines(paste0("RSE = ", round(rse,4)))

  # percentage error
  err <- sigma(model)/mean(train_set$YIELD)
  writeLines(paste0("%err = ", round(err,4)))

  r2 <- rsquare(model, data = train_set)
  writeLines(paste0("R^2 = ", round(r2,4)))

  testMSE <- test_set %>% add_predictions(model) %>% summarise(MSE = mean((YIELD - pred)^2))
  writeLines(paste0("testMSE = ", round(testMSE,4)))

  trainMSE <-train_set %>% add_predictions(model) %>% summarise(MSE = mean((YIELD - pred)^2))
  writeLines(paste0("trainMSE = ", round(trainMSE,4)))

}