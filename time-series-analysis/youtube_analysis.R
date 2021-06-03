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


# Reading in data
youtube_sentiment <- read.csv("youtube_sentiment.csv")

# Convert date column 
youtube_sentiment$Date <- as.Date(youtube_sentiment$Date)

# Remove years less than 2021
youtube_sentiment <- youtube_sentiment %>%
  filter(Date > "2021-01-01")

# Coding the sentiment score as a hard label
# Popularity column - coding as a binary variable 
youtube_sentiment$compound[which(youtube_sentiment$compound < 0)] <- "Negative"
youtube_sentiment$compound[which(youtube_sentiment$compound == 0)] <- "Neutral"
youtube_sentiment$compound[which(!(youtube_sentiment$compound
                                  %in% c("Negative", "Neutral")))] <- "Positive"



# Interaction term between date and compound sentiment 
youtube_sentiment$interds <- with(youtube_sentiment, interaction(Date, 
                                                               compound, 
                                                               drop = FALSE))

# Find proportions of positive negative and neutral for each date
youtube_ts <- youtube_sentiment %>%
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
youtube_ts$event <- droplevels(factor(youtube_ts$event))


#AZ
youtube_az <- youtube_sentiment %>%
  filter(event == "AZ Clots") %>%
  filter(Date > "2021-03-01") %>%
  group_by(Date) %>%
  mutate(total_posts = n()) %>%
  ungroup() %>%
  group_by(Date, compound) %>%
  mutate(total_compound = n()) %>%
  ungroup %>%
  mutate(total_prop = total_compound/total_posts) %>%
  group_by(interds, event) %>%
  distinct(interds, .keep_all = TRUE) %>%
  ungroup() %>%
  select(Date, event, compound, total_prop)


# Pfizer children
youtube_pc <-  youtube_ts %>%
  filter(event == "Pfizer Children") %>%
  filter(Date > "2021-05-01")


# Pfizer heart
youtube_ph <-  youtube_ts %>%
  filter(event == "Pfizer Heart")  %>%
  filter(Date > "2021-05-20")


# Vaccine variants
youtube_vv <-  youtube_ts  %>%
  filter(event == "Vaccines Variants") %>%
  filter(Date > "2021-01-15")


# Plot time-series

png(filename = "youtube_az.png", width = 20, height = 13, units = "cm", 
    res = 300)

ggplot(youtube_az, aes(x = Date, y = total_prop)) + 
  geom_line(aes(colour = compound)) + scale_x_date(breaks = breaks_pretty(12)) +
  theme_classic() + labs(y = "Proportion of Comments", colour = "Sentiment")

dev.off()


png(filename = "youtube_pc.png", width = 20, height = 13, units = "cm", 
    res = 300)

ggplot(youtube_pc, aes(x = Date, y = total_prop)) + 
  geom_line(aes(colour = compound)) + scale_x_date(breaks = breaks_pretty(12)) +
  theme_classic() + labs(y = "Proportion of Comments", colour = "Sentiment")

dev.off()


png(filename = "youtube_ph.png", width = 20, height = 13, units = "cm", 
    res = 300)

ggplot(youtube_ph, aes(x = Date, y = total_prop)) + 
  geom_line(aes(colour = compound)) + scale_x_date(breaks = breaks_pretty(12)) +
  theme_classic() + labs(y = "Proportion of Comments", colour = "Sentiment")

dev.off()


png(filename = "youtube_vv.png", width = 20, height = 13, units = "cm", 
    res = 300)

ggplot(youtube_vv, aes(x = Date, y = total_prop)) + 
  geom_line(aes(colour = compound)) + scale_x_date(breaks = breaks_pretty(12)) +
  theme_classic() + labs(y = "Proportion of Comments", colour = "Sentiment")

dev.off()

