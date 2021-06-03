#Libraries 
library(lubridate)
library(stringr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(tidytext)
library(topicmodels)
library(tidyverse)
library(tm)
library(wordcloud)
library(textmineR)



# Importing youtube data

AZ_clot_youtube <- read.csv("AstraZenicaBloodClots_world_wide_english.csv")

AZ_clot_youtube$event <- with(AZ_clot_youtube, rep("AZ Clots", 
                                                   nrow(AZ_clot_youtube)))

pfizerc_youtube <- read.csv("phizer_children_world_wide_english.csv")

pfizerc_youtube$event <- with(pfizerc_youtube, rep("Pfizer Children", 
                                                   nrow(pfizerc_youtube)))


pfizerh_youtube <- read.csv("phizer_heart2_world_wide_english.csv")


pfizerh_youtube$event <- with(pfizerh_youtube, rep("Pfizer Heart", 
                                                   nrow(pfizerh_youtube)))


vaccinev_youtube <- read.csv("vaccine_efficacy_world_wide_english.csv")

vaccinev_youtube$event <- with(vaccinev_youtube, rep("Vaccines Variants", 
                                                     nrow(vaccinev_youtube)))


# Combine columns 
youtube_dat <- rbind(AZ_clot_youtube, pfizerc_youtube, pfizerh_youtube,
                     vaccinev_youtube)


# Separate into columns
youtube_dat <- separate(data = youtube_dat,
                        col = dateStamp, 
                        into = c("Year","Month", "Day"), 
                        sep = "-")
# Fix day column
youtube_dat$Day <- substring(youtube_dat$Day, 1, 2)


# Make new date column
youtube_dat$Date <- paste(youtube_dat$Year, youtube_dat$Month,
                          youtube_dat$Day, sep="-")

# Remove useless columns 
youtube_dat <- youtube_dat[, c(2, 6, 7)]


write.csv(youtube_dat, file = "youtube_dat.csv")

