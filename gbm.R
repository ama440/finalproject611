source("setup.R")

set.seed(1)
trainset=sample(seq(1:nrow(health)), size=0.7*nrow(health), replace=FALSE)
train=health[trainset,]
test=health[-trainset,]
train$chd <- as.character(train$chd)
test$chd <- as.character(test$chd)

gbm.reg <- gbm(chd ~ bp_high + blood_chol_high + stroke + had_or_has_asthma + 
                 skin_cancer + cancer_other + copd_emph_bronc + arthritis + 
                 depression + kidney_disease + diabetes + sex + age + bmi + 
                 smoking + alcohol_freq + vegetable + cardio_freq,
                 data = train)

write_csv(data.frame(head(summary(gbm.reg), 12)), file = "summary_gbm.csv")


test <- test %>% mutate(pred.gbm=predict(gbm.reg, newdata=test, type="response"))
roc.gbm <- roc(test$chd, test$pred.gbm)
roc.gbm$auc

roc_gbm <- ggroc(roc.gbm,legacy.axes = TRUE) +
  geom_segment(aes(x=0, xend=1, y=0, yend=1),linetype="dashed") +
  labs(title = "ROC Curve for GBM") +
  coord_fixed()
ggsave("figures/roc_gbm.png", plot = roc_gbm)

# Accuracy Metrics
coords <- coords(roc.gbm)
coords[which(abs(coords$sensitivity-.75)==min(abs(coords$sensitivity-.75))),]
cutoff <- 0.07034853  
TP <- length(which(test$pred.gbm > cutoff & test$chd == 1))
TN <- length(which(test$pred.gbm < cutoff & test$chd == 0))
FP <- length(which(test$pred.gbm > cutoff & test$chd == 0))
FN <- length(which(test$pred.gbm < cutoff & test$chd == 1))

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
