library(tidyverse)
library(FactoMineR)
library(factoextra)
library(ggmosaic)
library(fastDummies)

df <- read_csv("source_data/data2015.csv")
health <- df
names(health) <- gsub('_', '', names(health)) # Remove '_' from column names
colnames(health) <- make.unique(names(health))

health <- health %>% 
  select(DISPCODE, GENHLTH, PHYSHLTH, MENTHLTH, HLTHPLN1, MEDCOST, CHECKUP1,
         RFHYPE5, RFCHOL, CVDINFR4, CVDCRHD4, CVDSTRK3, ASTHMA3, CHCSCNCR, 
         CHCOCNCR, CHCCOPD1, HAVARTH3, ADDEPEV2, CHCKIDNY, DIABETE3, 
         SEX, AGE80, AGEG5YR, BMI5, MARITAL, EDUCA, RACE, VETERAN3, INCOME2,
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

# Interview completed
health$interview_completed <- as.character(health$interview_completed)
health[which(health$interview_completed == "1100"), "interview_completed"] <- "completed"
health[which(health$interview_completed == "1200"), "interview_completed"] <- "partially_complete"
health$interview_completed <- factor(health$interview_completed)

# General health
health[which(!(health$general_health %in% c(1:5))), "general_health"] <- NA
health$general_health <- as.character(health$general_health)
health[which(health$general_health == "1"), "general_health"] <- "excellent"
health[which(health$general_health == "2"), "general_health"] <- "very_good"
health[which(health$general_health == "3"), "general_health"] <- "good"
health[which(health$general_health == "4"), "general_health"] <- "fair"
health[which(health$general_health == "5"), "general_health"] <- "poor"
health$general_health <- factor(health$general_health, 
                                levels = c("excellent", "very_good", 
                                           "good", "fair", "poor"))

# Days of poor physical health
health[which(health$days_poor_phys_health %in% c(77,99)), "days_poor_phys_health"] <- NA
health[which(health$days_poor_phys_health == 88), "days_poor_phys_health"] <- 0

# Days of poor mental health
health[which(health$days_poor_ment_health %in% c(77,99)), "days_poor_ment_health"] <- NA
health[which(health$days_poor_ment_health == 88), "days_poor_ment_health"] <- 0

# Has health care
health[which(health$has_health_care == 1), "has_health_care"] <- 1
health[which(health$has_health_care == 2), "has_health_care"] <- 0
health[which(health$has_health_care %in% c(7,9)), "has_health_care"] <- NA
health$has_health_care <- factor(health$has_health_care)

# Medical cost prevented visit
health[which(health$med_cost_prevented_visit == 1), "med_cost_prevented_visit"] <- 1
health[which(health$med_cost_prevented_visit == 2), "med_cost_prevented_visit"] <- 0
health[which(health$med_cost_prevented_visit %in% c(7,9)), "med_cost_prevented_visit"] <- NA
health$med_cost_prevented_visit <- factor(health$med_cost_prevented_visit)

# Time since last checkup
health[which(health$time_since_last_checkup %in% c(7,9)), "time_since_last_checkup"] <- NA
health$time_since_last_checkup <- as.character(health$time_since_last_checkup)
health[which(health$time_since_last_checkup == "1"), "time_since_last_checkup"] <- "within_year"
health[which(health$time_since_last_checkup == "2"), "time_since_last_checkup"] <- "within2years"
health[which(health$time_since_last_checkup == "3"), "time_since_last_checkup"] <- "within5years"
health[which(health$time_since_last_checkup == "4"), "time_since_last_checkup"] <- "over5years"
health[which(health$time_since_last_checkup == "8"), "time_since_last_checkup"] <- "never_been"
health$time_since_last_checkup <- factor(health$time_since_last_checkup, 
                                levels = c("within_year", "within2years", 
                                           "within5years", "over5years", "never_been"))

# High blood pressure
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

# Education
health$education <- as.character(health$education)
health[which(health$education == 1), "education"] <- "none"
health[which(health$education == 2), "education"] <- "elementary"
health[which(health$education == 3), "education"] <- "some_highschool"
health[which(health$education == 4), "education"] <- "highschool"
health[which(health$education == 5), "education"] <- "some_college"
health[which(health$education == 6), "education"] <- "college"
health[which(health$education == 9), "education"] <- NA
health$education <- factor(health$education, 
                           levels = c("none", "elementary", 
                                      "some_highschool", "highschool",
                                      "some_college", "college"))

# Race
health$race <- as.character(health$race)
health[which(health$race == 1), "race"] <- "white"
health[which(health$race == 2), "race"] <- "black"
health[which(health$race == 3), "race"] <- "american_indian"
health[which(health$race == 4), "race"] <- "asian"
health[which(health$race == 5), "race"] <- "native_hawaiian"
health[which(health$race == 6), "race"] <- "other"
health[which(health$race == 7), "race"] <- "multiracial"
health[which(health$race == 8), "race"] <- "hispanic"
health[which(health$race == 9), "race"] <- NA
health$race <- factor(health$race)

# Is a veteran
health[which(health$is_veteran == 1), "is_veteran"] <- 1
health[which(health$is_veteran == 2), "is_veteran"] <- 0
health[which(health$is_veteran %in% c(7,9)), "is_veteran"] <- NA
health$is_veteran <- factor(health$is_veteran)

# Income
health$income <- as.character(health$income)
health[which(health$income == 1), "income"] <- "0-10k"
health[which(health$income == 2), "income"] <- "10-15k"
health[which(health$income == 3), "income"] <- "15-20k"
health[which(health$income == 4), "income"] <- "20-25k"
health[which(health$income == 5), "income"] <- "25-35k"
health[which(health$income == 6), "income"] <- "35-50k"
health[which(health$income == 7), "income"] <- "50-75k"
health[which(health$income == 8), "income"] <- "over75k"
health[which(health$income %in% c(77,99)), "income"] <- NA
health$income <- factor(health$income)

# Smoking Status
health$smoking <- as.character(health$smoking)
health[which(health$smoking == 1), "smoking"] <- "every_day"
health[which(health$smoking == 2), "smoking"] <- "some_days"
health[which(health$smoking == 3), "smoking"] <- "former"
health[which(health$smoking == 4), "smoking"] <- "never"
health[which(health$smoking == 9), "smoking"] <- NA
health$smoking <- factor(health$smoking, levels = c("never", "former", "some_days", "every_day"))

# Alcohol habits
health[which(health$alcohol_freq == 900), "alcohol_freq"] <- NA

# Fruit consumption
health$fruit <- health$fruit/100

# Vegetable consumption
health$vegetable <- health$vegetable/100

# Cardio frequency
health[which(health$cardio_freq %in% c(101:199)), "cardio_freq"] <- (health[which(health$cardio_freq %in% c(101:199)), "cardio_freq"]-100)*4
health[which(health$cardio_freq %in% c(201:299)), "cardio_freq"] <- (health[which(health$cardio_freq %in% c(201:299)), "cardio_freq"]-200)
health[which(is.na(health$cardio_freq)), "cardio_freq"] <- 0
health[which(health$cardio_freq %in% c(777,999)), "cardio_freq"] <- 0
health[which(health$cardio_freq > 150), "cardio_freq"] <- NA

# Strength frequency
health[which(health$strength_freq %in% c(101:199)), "strength_freq"] <- (health[which(health$strength_freq %in% c(101:199)), "strength_freq"]-100)*4
health[which(health$strength_freq %in% c(201:299)), "strength_freq"] <- (health[which(health$strength_freq %in% c(201:299)), "strength_freq"]-200)
health[which(health$strength_freq == 888), "strength_freq"] <- 0
health[which(health$strength_freq %in% c(777,999)), "strength_freq"] <- 0
health[which(health$strength_freq > 150), "strength_freq"] <- NA

