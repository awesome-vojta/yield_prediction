library(tidyverse)  # data manipulation and visualization
library(modelr)     # provides easy pipeline modeling functions
library(broom)      # helps to tidy up model outputs
library(rsample)    # data splitting

load("lm/fields/fields_with_others_5_p.Rda")
fields_with_others_5_p$x <- NULL
fields_with_others_5_p$y <- NULL
data <- fields_with_others_5_p

set.seed(123)
split <- initial_split(data, prop = .7)
train <- training(split)
test  <- testing(split)


model1 <- lm(yield ~ NDVI, data = train)

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
            # (Intercept)  1.910102  2.07879
            # NDVI        17.698462 18.35311
# 95% conf interval je [17.69-18.35], nula zde nelezi, parametry jsou dulezitejsi nez 0
# kdyz se NDVI zvedne o jednotku, yield bude vetsi o 17.6 az 18.3 jednotek


########### Assessing model accuracy -----------
# RSE
sigma(model1)
# prumerna odchylka yieldu je 1.64 tun
sigma(model1)/mean(train$yield)
# procetni chyba je 0.25
rsquare(model1, data = train)
# 43% je proporce rozptylu kterou model dokaze vysvetlit
# F-statistic: 1.165e+04, p-value: < 2.2e-16


########### Assessing model visually -----------

# add model diagnostics to our training data
model1_results <- augment(model1, train)

ggplot(train, aes(NDVI, yield)) +
  geom_point() +
  geom_smooth(method = "lm") +
  geom_smooth(se = FALSE, color = "red")
par(mfrow=c(1,1))
plot(model1)


p1 <- ggplot(model1_results, aes(.fitted, .std.resid)) +
  geom_ref_line(h = 0) +
  geom_point() +
  geom_smooth(se = FALSE) +
  ggtitle("Standardized Residuals vs Fitted")

p2 <- ggplot(model1_results, aes(.fitted, sqrt(.std.resid))) +
  geom_ref_line(h = 0) +
  geom_point() +
  geom_smooth(se = FALSE) +
  ggtitle("Scale-Location")

