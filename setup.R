library(tidyverse)
library(FactoMineR)
library(factoextra)
library(ggmosaic)

health <- read_csv("source_data/data2015.csv")
names(health) <- gsub('_', '', names(health)) # Remove '_' from column names
colnames(health) <- make.unique(names(health))

health <- health %>% 
  select(DISPCODE, GENHLTH, PHYSHLTH, MENTHLTH, HLTHPLN1, MEDCOST, CHECKUP1,
         RFHYPE5, RFCHOL, CVDINFR4, CVDCRHD4, CVDSTRK3, ASTHMA3, CHCSCNCR, 
         CHCOCNCR, CHCCOPD1, HAVARTH3, ADDEPEV2, CHCKIDNY, DIABETE3, 
         SEX, AGE80, AGEG5YR, BMI5, MARITAL, EDUCA, PRACE1, VETERAN3, INCOME2,
         SMOKER3, DROCDY3,
         FRUTSUM, VEGESUM,
         EXEROFT2, STRENGTH)

names(health) <- c("interview_completed", 
                   "general_health", 
                   "days_poor_phys_health",
                   "days_poor_ment_health", 
                   "has_health_care",
                   "med_cost_prevented_visit",
                   "time_since_last_checkup",
                   "bp_high",
                   "blood_chol_high",
                   "heart_attack",
                   "chd",
                   "stroke",
                   "had_or_has_asthma",
                   "skin_cancer",
                   "cancer_other",
                   "copd_emph_bronc",
                   "arthritis",
                   "depression",
                   "kidney_disease",
                   "diabetes",
                   "sex",
                   "age",
                   "age_cat",
                   "bmi",
                   "marital_status",
                   "education",
                   "race",
                   "is_veteran",
                   "income",
                   "smoking",
                   "alcohol_freq",
                   "fruit",
                   "vegetable",
                   "cardio_freq",
                   "strength_freq")

# Blood pressure
health[which(health$bp_high == 1), "bp_high"] <- 0
health[which(health$bp_high == 2), "bp_high"] <- 1
health[which(health$bp_high == 9), "bp_high"] <- NA
health$bp_high <- factor(health$bp_high)

# Blood cholesterol
health[which(health$blood_chol_high == 1), "blood_chol_high"] <- 0
health[which(health$blood_chol_high == 2), "blood_chol_high"] <- 1
health[which(!(health$blood_chol_high %in% c(0,1))), "blood_chol_high"] <- NA
health$blood_chol_high <- factor(health$blood_chol_high)

# Heart attack
health[which(health$heart_attack == 1), "heart_attack"] <- 1
health[which(health$heart_attack == 2), "heart_attack"] <- 0
health[which(!(health$heart_attack %in% c(0,1))), "heart_attack"] <- NA
health$heart_attack <- factor(health$heart_attack)

# CHD
health[which(health$chd == 1), "chd"] <- 1
health[which(health$chd == 2), "chd"] <- 0
health[which(!(health$chd %in% c(0,1))), "chd"] <- NA
health$chd <- factor(health$chd)
health <- health %>% filter(!(is.na(chd)))

# Stroke
health[which(health$stroke == 1), "stroke"] <- 1
health[which(health$stroke == 2), "stroke"] <- 0
health[which(!(health$stroke %in% c(0,1))), "stroke"] <- NA
health$stroke <- factor(health$stroke)

# Asthma
health[which(health$had_or_has_asthma == 1), "had_or_has_asthma"] <- 1
health[which(health$had_or_has_asthma == 2), "had_or_has_asthma"] <- 0
health[which(!(health$had_or_has_asthma %in% c(0,1))), "had_or_has_asthma"] <- NA
health$had_or_has_asthma <- factor(health$had_or_has_asthma)

# Skin cancer
health[which(health$skin_cancer == 1), "skin_cancer"] <- 1
health[which(health$skin_cancer == 2), "skin_cancer"] <- 0
health[which(!(health$skin_cancer %in% c(0,1))), "skin_cancer"] <- NA
health$skin_cancer <- factor(health$skin_cancer)

# Other cancer
health[which(health$cancer_other == 1), "cancer_other"] <- 1
health[which(health$cancer_other == 2), "cancer_other"] <- 0
health[which(!(health$cancer_other %in% c(0,1))), "cancer_other"] <- NA
health$cancer_other <- factor(health$cancer_other)

# COPD/Emphysema/Bronchitis
health[which(health$copd_emph_bronc == 1), "copd_emph_bronc"] <- 1
health[which(health$copd_emph_bronc == 2), "copd_emph_bronc"] <- 0
health[which(!(health$copd_emph_bronc %in% c(0,1))), "copd_emph_bronc"] <- NA
health$copd_emph_bronc <- factor(health$copd_emph_bronc)

# Arthritis
health[which(health$arthritis == 1), "arthritis"] <- 1
health[which(health$arthritis == 2), "arthritis"] <- 0
health[which(!(health$arthritis %in% c(0,1))), "arthritis"] <- NA
health$arthritis <- factor(health$arthritis)

# Depression
health[which(health$depression == 1), "depression"] <- 1
health[which(health$depression == 2), "depression"] <- 0
health[which(!(health$depression %in% c(0,1))), "depression"] <- NA
health$depression <- factor(health$depression)

# Kidney Disease
health[which(health$kidney_disease == 1), "kidney_disease"] <- 1
health[which(health$kidney_disease == 2), "kidney_disease"] <- 0
health[which(!(health$kidney_disease %in% c(0,1))), "kidney_disease"] <- NA
health$kidney_disease <- factor(health$kidney_disease)

# Diabetes
health[which(health$diabetes == 1), "diabetes"] <- 1
health[which(health$diabetes %in% c(2,3,4)), "diabetes"] <- 0
health[which(!(health$diabetes %in% c(0,1))), "diabetes"] <- NA
health$diabetes <- factor(health$diabetes)

# Sex
health$sex <- ifelse(health$sex == 1, "male", "female")
health$sex <- factor(health$sex)
summary(health$sex)

# Age cat
health[which(health$age_cat == 14), "age_cat"] <- NA
health$age_cat <- factor(health$age_cat)

# BMI
health$bmi <- health$bmi/100

# Marital Status
health$marital_status <- as.character(health$marital_status)
health[which(health$marital_status == "1"), "marital_status"] <- "married"
health[which(health$marital_status == "2"), "marital_status"] <- "divorced"
health[which(health$marital_status == "3"), "marital_status"] <- "widowed"
health[which(health$marital_status == "4"), "marital_status"] <- "separated"
health[which(health$marital_status == "5"), "marital_status"] <- "never_married"
health[which(health$marital_status == "6"), "marital_status"] <- "unmarried_couple"
health[which(health$marital_status == "9"), "marital_status"] <- NA
health$marital_status <- factor(health$marital_status)

# Smoking
health$smoking <- as.character(health$smoking)
health[which(health$smoking == 1), "smoking"] <- "every_day"
health[which(health$smoking == 2), "smoking"] <- "some_days"
health[which(health$smoking == 3), "smoking"] <- "former"
health[which(health$smoking == 4), "smoking"] <- "never"
health[which(health$smoking == 9), "smoking"] <- NA
health$smoking <- factor(health$smoking, levels = c("never", "former", "some_days", "every_day"))

