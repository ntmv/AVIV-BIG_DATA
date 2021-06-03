################ Real and fake data extraction #####################
# Libraries
library(RedditExtractoR)
library(dplyr)
library(brms)
library(ggplot2)

####################### Real Data ########################

# Extracting posts from coronavirus subreddit
real_vaccines <- get_reddit(subreddit = "Coronavirus", search_terms = "vaccine",
                            page_threshold = 1000, cn_threshold = 0)

# Keeping distinct columns
real_vaccines <- real_vaccines %>%
  distinct(title, .keep_all = TRUE)

# Removing daily discussions 
real_vaccines <- real_vaccines[!grepl("Discussion", real_vaccines$title),]

# Adding label column 
real_vaccines$label <- rep("real", nrow(real_vaccines))

# Filter needed columns 
real_vaccines <- real_vaccines[, c(14, 15, 19)]

############### Fake data ##############################
# Fake data

fake_vaccines <- get_reddit(subreddit = "NoNewNormal",
                            page_threshold = 1000, cn_threshold = 0)

# Merge dataset 
real_fake_dat <- rbind(real_vaccines, fake_vaccines)

# Write  csv
write.csv(real_fake_dat , filename = "real_fake_dat.csv")

