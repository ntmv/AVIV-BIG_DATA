# Extract Reddit information 

# Libraries
library(RedditExtractoR)
library(dplyr)
library(brms)
library(ggplot2)


# Extracting reddit data according to key words


# Astrazeneca blood clots 
az_clots <- get_reddit(search_terms = 
                         "Astrazeneca+blood clot",
                       page_threshold = 1000,
                       cn_threshold = 1)

# Adding column with event information 
az_clots$event <- with(az_clots, rep("AZ Clots", nrow(az_clots)))


# Keep only necessary columns 
az_clots <- az_clots[, c(4, 6, 13, 16, 19)]


# Pfizer vaccine for children 
pfizerchildren <- get_reddit(search_terms = 
                           "pfizer+children",
  page_threshold = 1000,
  cn_threshold = 1
)

# Adding column with event information 
pfizerchildren$event <- with(pfizerchildren,
                             rep("Pfizer Children", nrow(pfizerchildren)))


# Keep only necessary columns 
pfizerchildren <- pfizerchildren[, c(4, 6, 13, 16, 19)]

# Pfizer heart problems 
pfizer_heart <- get_reddit(search_terms = 
                               "pfizer+heart",
                             page_threshold = 1000,
                             cn_threshold = 1
)

# Adding column with event information 
pfizer_heart$event <- with(pfizer_heart,
                             rep("Pfizer Heart", nrow(pfizer_heart)))


# Keep only necessary columns 
pfizer_heart <- pfizer_heart[, c(4, 6, 13, 16,  19)]


# Vaccines variants 
vaccines_variants <- get_reddit(search_terms = "covid+vaccines+variants", 
                                page_threshold = 1000,
                                cn_threshold = 1
)

# Adding column with event information 
vaccines_variants$event <- with(vaccines_variants,
                           rep("Vaccines Variants", nrow(vaccines_variants)))


# Keep only necessary columns 
vaccines_variants <- vaccines_variants[, c(4, 6, 13, 16, 19)]



# Combine all data-sets
dat_reddit <- rbind(az_clots, pfizer_heart, pfizerchildren, 
                    vaccines_variants)

# Remove reddit links frim the links column
dat_reddit <- dat_reddit[!grepl("reddit", dat_reddit$link),]

# Convert Subreddits into factor
dat_reddit$subreddit <- factor(dat_reddit$subreddit)

levels(dat_reddit$subreddit)

# Remove irrelevant subreddits
dat_reddit <- dat_reddit %>%
  filter(!(subreddit %in% c("investing", "makeupexchange")))


# Removing outliers (less than 5 and greater than 500)
dat_reddit <- dat_reddit[sapply(strsplit
                                (as.character(dat_reddit$comment)," "),length)>5,]

dat_reddit <- dat_reddit[sapply(strsplit
                                (as.character(dat_reddit$comment)," "),length)<500,]

# Write csv
write.csv(dat_reddit, file = "dat_reddit.csv")
