source("setup.R")

## Code for my own analysis that I want make to ignore
# health$CVDCRHD4
# health %>% filter(CVDCRHD4 == 1) %>% nrow()

# ggplot(health, aes(AGE80)) + geom_histogram(binwidth = 4)
# ggplot(health, aes(AGEG5YR)) + geom_bar()

age_heart <- health %>% 
  filter(CVDCRHD4 == 1 | CVDCRHD4 == 2) %>% 
  select(CVDCRHD4, AGE80) %>% 
  mutate(CVDCRHD4 = ifelse(CVDCRHD4 == 1, 1, 0)) %>% 
  mutate(CVDCRHD4 = factor(CVDCRHD4))

agebox <- ggplot(age_heart, aes(x=factor(CVDCRHD4), y=AGE80)) + 
  geom_boxplot(outlier.shape = 8) +
  labs(x = "Heart Disease Status", y = "Age", title = "Comparative Boxplots") +
  coord_flip()
ggsave("figures/agebox.png", plot = agebox)

age.logit = glm(CVDCRHD4 ~ AGE80, family=binomial, data=age_heart)
summary(age.logit)


smoke_heart <- health %>% 
  filter(CVDCRHD4 == 1 | CVDCRHD4 == 2) %>% 
  mutate(CVDCRHD4 = ifelse(CVDCRHD4 == 1, 1, 0)) %>% 
  mutate(CVDCRHD4 = factor(CVDCRHD4)) %>% 
  select(CVDCRHD4, SMOKER3) %>% 
  filter(!(SMOKER3 == 9)) %>% 
  mutate(SMOKER3 = factor(SMOKER3))
ggplot(smoke_heart, aes(fill=CVDCRHD4, y=mean(as.numeric(CVDCRHD4)-1), x=SMOKER3)) + 
  geom_bar(position="fill", stat="identity")


sex_heart <- health %>% 
  filter(CVDCRHD4 == 1 | CVDCRHD4 == 2) %>% 
  mutate(CVDCRHD4 = ifelse(CVDCRHD4 == 1, 1, 0)) %>% 
  mutate(CVDCRHD4 = factor(CVDCRHD4)) %>%
  mutate(SEX = factor(SEX)) %>%
  select(CVDCRHD4, SEX)
ggplot(sex_heart, aes(fill=CVDCRHD4, y=mean(as.numeric(CVDCRHD4)-1), x=SEX)) + 
  geom_bar(position="fill", stat="identity")

mean(sex_heart %>% filter(SEX == "1") %>% pull(CVDCRHD4) %>% as.numeric() - 1)
mean(sex_heart %>% filter(SEX == "2") %>% pull(CVDCRHD4) %>% as.numeric() - 1)


alc_heart <- health %>% 
  filter(CVDCRHD4 == 1 | CVDCRHD4 == 2) %>% 
  mutate(CVDCRHD4 = ifelse(CVDCRHD4 == 1, 1, 0)) %>% 
  mutate(CVDCRHD4 = factor(CVDCRHD4)) %>%
  mutate(RFDRHV5 = factor(RFDRHV5)) %>%
  select(CVDCRHD4, RFDRHV5) %>% 
  filter(!(RFDRHV5 == 9))
ggplot(alc_heart, aes(fill=CVDCRHD4, y=mean(as.numeric(CVDCRHD4)-1), x=RFDRHV5)) + 
  geom_bar(position="fill", stat="identity")


fruit_heart <- health %>% 
  filter(CVDCRHD4 == 1 | CVDCRHD4 == 2) %>% 
  mutate(CVDCRHD4 = ifelse(CVDCRHD4 == 1, 1, 0)) %>% 
  mutate(CVDCRHD4 = factor(CVDCRHD4)) %>%
  select(CVDCRHD4, FRUTSUM) %>% 
  filter(FRUTSUM < 500)
fruitbox <- ggplot(fruit_heart, aes(x=factor(CVDCRHD4), y=FRUTSUM/100)) + 
  geom_boxplot(outlier.shape = 8) +
  labs(x = "Heart Disease Status", y = "Total Fruit Consumed per Day", title = "Comparative Boxplots") +
  coord_flip()


library(naniar)
sample <- health %>% select(FRUTSUM, AGE80, SMOKER3, RFDRHV5, CVDCRHD4) %>% sample_n(10000)

sample[which(sample$CVDCRHD4 == 7),"CVDCRHD4"] <- NA
sample[which(sample$CVDCRHD4 == 9),"CVDCRHD4"] <- NA
sample[which(sample$SMOKER3 == 9),"CVDCRHD4"] <- NA

vis_miss(sample, warn_large_data = F)



bmi_heart <- health %>% 
  filter(CVDCRHD4 == 1 | CVDCRHD4 == 2) %>% 
  select(CVDCRHD4, BMI5) %>% 
  mutate(CVDCRHD4 = ifelse(CVDCRHD4 == 1, 1, 0)) %>% 
  mutate(CVDCRHD4 = factor(CVDCRHD4)) %>% 
  filter(BMI5 < 5000)

bmibox <- ggplot(bmi_heart, aes(x=factor(CVDCRHD4), y=BMI5/100)) + 
  geom_boxplot(outlier.shape = 8) +
  labs(x = "Heart Disease Status", y = "BMI", title = "Comparative Boxplots") +
  coord_flip()


ggplot(health %>% sample_n(1000) %>% select(PAMIN11, BMI5), 
       aes(x=PAMIN11, y=BMI5/100)) +
  geom_point()
