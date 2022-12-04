source("setup.R")

names(health)
summary(health)
str(health)


dummy_cols(health %>% na.omit, select_columns = c('general_health'), remove_selected_columns = TRUE)
as.numeric(health$sex)

set.seed(400)
smpl_num <- health %>% select("days_poor_phys_health", 
                              "days_poor_ment_health", 
                              "age", "bmi", "alcohol_freq", 
                              "fruit", "vegetable", "cardio_freq", 
                              "strength_freq", "chd") %>% 
  na.omit %>% sample_n(30000)
r <- prcomp(smpl_num %>% select(-chd), center = T, scale. = T)
r
summary(r)

ggplot(r$x %>% as_tibble() %>% select(PC1, PC2), aes(PC1, PC2)) +
  geom_point(aes(col = smpl_num$chd, alpha = smpl_num$chd)) + 
  scale_alpha_manual(guide='none', values = c(0.1, 0.5)) +
  labs(color = "Heart Disease")


summary(r$x[which(smpl_num$chd == 1),1:2])
summary(r$x[which(smpl_num$chd == 0),1:2])

r$rotation[,1:2]


smpl_cat <- health %>% select_if(~class(.) == 'factor') %>% na.omit %>% sample_n(30000)
res.mca = MCA(smpl_cat)
plot.MCA(res.mca, invisible=c("ind","quali.sup"), cex=0.5)
  
  
  
  
  
