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
  select(CVDCRHD4, SMOKER3)