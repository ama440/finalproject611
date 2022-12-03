source("setup.R")

names(health)
summary(health)
str(health)


dummy_cols(health %>% na.omit, select_columns = c('general_health'), remove_selected_columns = TRUE)
as.numeric(health$sex)

smpl_num <- health %>% select_if(is.numeric) %>% na.omit %>% sample_n(10000)
r <- prcomp(smpl_num, center = T, scale. = T)
r
summary(r)

ggplot(r$x %>% as_tibble() %>% select(PC1, PC2), aes(PC1, PC2)) +
  geom_point()

smpl_cat <- health %>% select_if(~class(.) == 'factor') %>% na.omit %>% sample_n(10000)
res.mca = MCA(smpl_cat)
plot.MCA(res.mca, invisible=c("var","quali.sup"), cex=0.7)
plot.MCA(res.mca, invisible=c("ind","quali.sup"), cex=0.7)
plot.MCA(res.mca, invisible=c("ind"))
plot.MCA(res.mca, invisible=c("ind", "var"))



as.numeric(health %>% select_if(~class(.) == 'factor'))
indx <- sapply(health, is.factor)
lapply(health[indx], function(x) as.numeric(as.character(x)))  
  
  
  
  
  
