source("setup.R")

agehist <- ggplot(health, aes(age)) + 
  geom_histogram(binwidth = 5) + 
  labs(x = "Age", y = "Count", title = "Histogram of Ages")
ggsave("figures/agehist.png", plot = agehist, dpi=300)
# ggplot(health %>% filter(!(is.na(age_cat))), aes(age_cat)) + geom_bar()

agebox <- ggplot(health, aes(x=chd, y=age)) + 
  geom_boxplot(outlier.shape = 8) +
  labs(x = "Heart Disease Status", y = "Age", title = "Comparative Boxplots") +
  coord_flip()
ggsave("figures/agebox.png", plot = agebox)

# age.logit = glm(chd ~ age, family=binomial, data=health)
# summary(age.logit)

# smoke_heart <- health %>% 
#   filter(chd == 1 | chd == 2) %>% 
#   mutate(chd = ifelse(chd == 1, 1, 0)) %>% 
#   mutate(chd = factor(chd)) %>% 
#   dplyr::select(chd, SMOKER3) %>% 
#   filter(!(SMOKER3 == 9)) %>% 
#   mutate(SMOKER3 = factor(SMOKER3))
# ggplot(smoke_heart, aes(fill=chd, y=mean(as.numeric(chd)-1), x=SMOKER3)) + 
#   geom_bar(position="fill", stat="identity")

# sex_heart <- health %>% 
#   filter(chd == 1 | chd == 2) %>% 
#   mutate(chd = ifelse(chd == 1, 1, 0)) %>% 
#   mutate(chd = factor(chd)) %>%
#   mutate(SEX = factor(SEX)) %>%
#   dplyr::select(chd, SEX)
# ggplot(sex_heart, aes(fill=chd, y=mean(as.numeric(chd)-1), x=SEX)) + 
#   geom_bar(position="fill", stat="identity")
# 
# mean(sex_heart %>% filter(SEX == "1") %>% pull(chd) %>% as.numeric() - 1)
# mean(sex_heart %>% filter(SEX == "2") %>% pull(chd) %>% as.numeric() - 1)


# alc_heart <- health %>% 
#   filter(chd == 1 | chd == 2) %>% 
#   mutate(chd = ifelse(chd == 1, 1, 0)) %>% 
#   mutate(chd = factor(chd)) %>%
#   mutate(RFDRHV5 = factor(RFDRHV5)) %>%
#   dplyr::select(chd, RFDRHV5) %>% 
#   filter(!(RFDRHV5 == 9))
# ggplot(alc_heart, aes(fill=chd, y=mean(as.numeric(chd)-1), x=RFDRHV5)) + 
#   geom_bar(position="fill", stat="identity")

fruitbox <- ggplot(health %>% filter(fruit<5), aes(x=chd, y=fruit)) + 
  geom_boxplot(outlier.shape = 8) +
  labs(x = "Heart Disease Status", y = "Total Fruit Consumed per Day", title = "Comparative Boxplots") +
  coord_flip()
ggsave("figures/fruitbox.png", plot = fruitbox)

bmibox <- ggplot(health, aes(x=chd, y=bmi)) + 
  geom_boxplot(outlier.shape = 8) +
  labs(x = "Heart Disease Status", y = "BMI", title = "Comparative Boxplots") +
  coord_flip()
ggsave("figures/bmibox.png", plot = bmibox)


# ggplot(health %>% sample_n(1000) %>% dplyr::select(cardio_freq, bmi) %>% filter(cardio_freq < 600), 
#        aes(x=cardio_freq, y=bmi/100)) +
#   geom_point()
# 
# ggplot(health %>% sample_n(1000), aes(age, bmi/100, color = factor(diabetes))) +
#   geom_point()


ct <- table(health$smoking, health$marital_status)
res.ca <- CA(ct, graph = FALSE)
fviz_ca_biplot(res.ca, repel = TRUE)

smoking_mosaic <- ggplot(data = health %>% filter(!(is.na(smoking)))) +
  geom_mosaic(aes(x = product(chd, smoking), fill=chd)) +
  theme(text = element_text(size=7))
ggsave("figures/smoking_mosaic.png", plot=smoking_mosaic, width = 6, height = 4)

agesmokebox <- ggplot(health %>% filter(!(is.na(smoking)))) + 
  geom_boxplot(aes(x=smoking, y=age)) + 
  labs(x="Smoking category", y="Age", title="Comparative Boxplots") +
  scale_x_discrete(labels=c("Never", "Former", "Some Days", "Every Day"))
ggsave("figures/agesmokebox.png", plot=agesmokebox)

ggplot(health %>% filter(!(is.na(smoking)))) + 
  geom_mosaic(aes(x = product(smoking, age_cat), fill=smoking))

heart_attack_mosaic <- ggplot(data = health %>% filter(!(is.na(heart_attack)))) +
  geom_mosaic(aes(x = product(heart_attack, chd), fill=heart_attack)) +
  coord_fixed(ratio = 0.8) +
  labs(y = "Heart Attack", x = "CHD")
ggsave("figures/heart_attack_mosaic.png", plot=heart_attack_mosaic)

cor(health$cardio_freq, health$strength_freq, use = "complete.obs")
cor(health$cardio_freq, health$bmi, use = "complete.obs")
cor(health$strength_freq, health$bmi, use = "complete.obs")

cor(health$cardio_freq, health$fruit, use = "complete.obs")
cor(health$alcohol_freq, health$bmi, use = "complete.obs")
cor(health$fruit, health$vegetable, use = "complete.obs")

