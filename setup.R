library(tidyverse)
setwd("~/work")

health <- read_csv("source_data/data2015.csv")
names(health) <- gsub('_', '', names(health)) # Remove '_' from column names
colnames(health) <- make.unique(names(health))