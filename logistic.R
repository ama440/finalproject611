source("setup.R")
library(MASS)
library(pROC)
library(rpart)
library(rpart.plot)

# Split into training and testing
set.seed(1)
trainset=sample(seq(1:nrow(health)), size=0.7*nrow(health), replace=FALSE)
train=health[trainset,]
test=health[-trainset,]

## Examine several individual predictors
# Age
age.logit = glm(chd ~ age, family=binomial, data=train)
summary(age.logit)

# BMI
bmi.logit = glm(chd ~ bmi, family=binomial, data=train)
summary(bmi.logit)

# Vegetable consumption
veg.logit = glm(chd ~ vegetable, family=binomial, data=train)
summary(veg.logit)

# Fruit consumption
fruit.logit = glm(chd ~ fruit, family=binomial, data=train)
summary(fruit.logit)$coefficients[2,]

# Had heart attack
heartattack.logit = glm(chd ~ heart_attack, family=binomial, data=train)
summary(heartattack.logit)

univariate <- data.frame(matrix(nrow=26, ncol=5))
names(univariate) <- c("Predictor", "Estimate", "Std. Error", "z value", "Pr(>|z|)")
names <- names(train %>% select(-chd, 
                                 -interview_completed,
                                 -general_health,
                                 -age_cat,
                                 -marital_status,
                                 -education,
                                 -race,
                                 -income,
                                 -smoking))
univariate$Predictor <- names

for (predictor in names) {
  model <- glm(train$chd ~ . , family=binomial, data = train %>% select(predictor))
  univariate[which(univariate$Predictor == predictor), 2:5] <- summary(model)$coefficients[2,]
}

univariate[,2:5] <- round(univariate[,2:5], 3)

# Full Model
df <- train %>% dplyr::select(-c(age_cat, 
                                 interview_completed, 
                                 general_health,
                                 days_poor_phys_health, 
                                 days_poor_ment_health, 
                                 med_cost_prevented_visit))
df <- df[complete.cases(df),]
model.full <- glm(chd ~ ., family=binomial, data = df)
summary(model.full)

# Multicollinearity
car::vif(model.full) # low vif's is a good sign
cor(train %>% dplyr::select("days_poor_phys_health", 
                      "days_poor_ment_health", 
                      "age", "bmi", "alcohol_freq", 
                      "fruit", "vegetable", "cardio_freq", 
                      "strength_freq"), use = 'complete.obs')

# Create Formula
xnam <- names(df %>% dplyr::select(-chd))
fmla <- as.formula(paste("chd ~ ", paste(xnam, collapse = "+")))

# Stepwise model selection
# null <- glm(chd~1, family = binomial, data = df)
# model.AIC <- stepAIC(model.full, direction = "backward",
#                      scope=list(lower=null, upper=fmla), trace=2)
# 
# summary(model.AIC)
# model.AIC$formula
# Gives following formula:
# chd ~ bp_high + blood_chol_high + heart_attack + stroke + had_or_has_asthma + 
#   skin_cancer + cancer_other + copd_emph_bronc + arthritis + 
#   depression + kidney_disease + diabetes + sex + age + bmi + 
#   marital_status + education + race + income + smoking + alcohol_freq + 
#   vegetable + cardio_freq

model.final <- glm(chd ~ bp_high + blood_chol_high + heart_attack + stroke + had_or_has_asthma + 
                   skin_cancer + cancer_other + copd_emph_bronc + arthritis + 
                   depression + kidney_disease + diabetes + sex + age + bmi + 
                   smoking + alcohol_freq + vegetable + cardio_freq,
                 family = binomial, data = train)
summary(model.final)

## Assessment
# Find the AUC for the model on the test set and plot the ROC curve
test <- test %>% mutate(pred.logist=predict(model.final, newdata = test, type="response"))

roc.test.logist <- roc(test$chd, test$pred.logist)
roc.test.logist$auc

ggroc(roc.test.logist,legacy.axes = TRUE) +
  geom_segment(aes(x=0, xend=1, y=0, yend=1),linetype="dashed")

# Accuracy metrics
coords <- coords(roc.test.logist)
coords[which(abs(coords$sensitivity-.8)==min(abs(coords$sensitivity-.8))),]

cutoff <- 0.05736810      
TP <- length(which(test$pred.logist > cutoff & test$chd == 1))
TN <- length(which(test$pred.logist < cutoff & test$chd == 0))
FP <- length(which(test$pred.logist > cutoff & test$chd == 0))
FN <- length(which(test$pred.logist < cutoff & test$chd == 1))

sensitivity <- TP/(TP + FN)
specificity <- TN/(TN + FP)
PPV <- TP/(TP + FP)
NPV <- TN/(TN + FN)
sensitivity
specificity
PPV
NPV

precision <- TP/(TP + FP)
recall <- sensitivity
f1 <- 2*(precision*recall)/(precision + recall)
precision
recall
f1




