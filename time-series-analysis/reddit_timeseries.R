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
library(viridis)

# Reading in dataset 
reddit_sentiment <- read.csv("sentiment_reddit.csv")


# Coding the sentiment score as a hard label
# Popularity column - coding as a binary variable 
reddit_sentiment$compound[which(reddit_sentiment$compound < 0)] <- "Negative"
reddit_sentiment$compound[which(reddit_sentiment$compound == 0)] <- "Neutral"
reddit_sentiment$compound[which(!(reddit_sentiment$compound
                                  %in% c("Negative", "Neutral")))] <- "Positive"


# Remove weird non-date columns 
reddit_sentiment <- reddit_sentiment[grep("-", reddit_sentiment$comm_date), ]

# Fix dates

# Separate into columns
reddit_sentiment <- separate(data = reddit_sentiment,
                   col = comm_date, 
                   into = c("Day","Month", "Year"), 
                   sep = "-")

# Remove years less than 2021
reddit_sentiment <- reddit_sentiment %>%
  filter(Year == 21)

# Fix day column
reddit_sentiment$Day <- substring(reddit_sentiment$Day, 3)

# Make new date column
reddit_sentiment$Date <- paste(reddit_sentiment$Year, reddit_sentiment$Month,
      reddit_sentiment$Day, sep="-")

# Convert to date format
reddit_sentiment$Date <- as.Date(reddit_sentiment$Date)


# Interaction term between date and compound sentiment 
reddit_sentiment$interds <- with(reddit_sentiment, interaction(Date, 
                                                               compound, 
                                                               drop = FALSE))

# Find proportions of positive negative and neutral for each date
reddit_ts <- reddit_sentiment %>%
  group_by(Date, event) %>%
  mutate(total_posts = n()) %>%
  ungroup() %>%
  group_by(interds, event) %>%
  mutate(total_compound = n()) %>%
  ungroup %>%
  mutate(total_prop = total_compound/total_posts) %>%
  group_by(interds, event) %>%
  distinct(interds, .keep_all = TRUE) %>%
  ungroup() %>%
  select(Date, event, compound, total_prop)

# Get rid of empty levels
reddit_ts$event <- droplevels(factor(reddit_ts$event))


#AZ
reddit_az <- reddit_ts  %>%
  filter(event == "AZ Clots")

# Pfizer children
reddit_pc <- reddit_ts  %>%
  filter(event == "Pfizer Children") %>%
  filter(Date > "0021-05-01")


# Pfizer heart
reddit_ph <- reddit_ts %>%
  filter(event == "Pfizer Heart")  %>%
  filter(Date > "0021-05-20")


# Vaccine variants
reddit_vv <- reddit_ts  %>%
  filter(event == "Vaccines Variants")


# Plot time-series

png(filename = "redditts_az.png", width = 20, height = 13, units = "cm", 
    res = 300)

ggplot(reddit_az, aes(x = Date, y = total_prop)) + 
  geom_line(aes(colour = compound)) + scale_x_date(breaks = breaks_pretty(12)) +
  theme_classic() + labs(y = "Proportion of Comments", colour = "Sentiment")

dev.off()

png(filename = "redditts_pc.png", width = 20, height = 13, units = "cm", 
    res = 300)

ggplot(reddit_pc, aes(x = Date, y = total_prop)) + 
  geom_line(aes(colour = compound)) + scale_x_date(breaks = breaks_pretty(12)) +
  theme_classic() + labs(y = "Proportion of Comments", colour = "Sentiment")

dev.off()

png(filename = "redditts_ph.png", width = 20, height = 13, units = "cm", 
    res = 300)

ggplot(reddit_ph, aes(x = Date, y = total_prop)) + 
  geom_line(aes(colour = compound)) + scale_x_date(breaks = breaks_pretty(12)) +
  theme_classic() + labs(y = "Proportion of Comments", colour = "Sentiment")

dev.off()

png(filename = "redditts_vv.png", width = 20, height = 13, units = "cm", 
    res = 300)

ggplot(reddit_vv, aes(x = Date, y = total_prop)) + 
  geom_line(aes(colour = compound)) + scale_x_date(breaks = breaks_pretty(12)) +
  theme_classic() + labs(y = "Proportion of Comments", colour = "Sentiment")

dev.off()

