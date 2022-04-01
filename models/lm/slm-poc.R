## Simple liner regression

library(tidyverse)  # data manipulation and visualization
library(modelr)     # provides easy pipeline modeling functions
library(broom)      # helps to tidy up model outputs
library(rsample)    # data splitting

data <- read.csv("data/p_2.5.csv")

set.seed(123)
split <- initial_split(data, prop = .7)
train <- training(split)
test  <- testing(split)


model1 <- lm(YIELD ~ NDVI, data = train)

########### Assessing model -----------
summary(model1)
tidy(model1)
                        # Estimate Std. Error t value Pr(>|t|)
            # (Intercept)  1.99445    0.04303   46.35   <2e-16 ***
            # NDVI        18.02578    0.16699  107.94   <2e-16 ***
# Y = 1.99 + 18.02x + ϵ
# kdyz je NDVI nula(x=0), lze ocekavat 1.99 yield

confint(model1)
                            # 2.5 %   97.5 %
            # (Intercept)  1.95      2.07879
            # NDVI        17.698462 18.35311
# 95% conf interval je [17.69-18.35], nula zde nelezi, parametry jsou dulezitejsi nez 0
# kdyz se NDVI zvedne o jednotku, yield bude vetsi o 17.6 az 18.3 jednotek


########### Assessing model accuracy -----------
# RSE
sigma(model1)
# prumerna odchylka yieldu je 1.64 tun
sigma(model1)/mean(train$YIELD)
# procetni chyba je 0.25
rsquare(model1, data = train)
# 43% je proporce rozptylu kterou model dokaze vysvetlit
# F-statistic: 1.165e+04, p-value: < 2.2e-16


########### Making Predictions -----------
(test <- test %>%
  add_predictions(model1))

# test MSE
test %>%
  add_predictions(model1) %>%
  summarise(MSE = mean((YIELD - pred)^2))


# training MSE
train %>%
  add_predictions(model1) %>%
  summarise(MSE = mean((YIELD - pred)^2))



