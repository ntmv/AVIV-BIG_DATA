# Reading in dataset 
reddit_sentiment <- read.csv("sentiment_reddits.csv")

# Coding the sentiment score as a hard label
# Popularity column - coding as a binary variable 
reddit_sentiment$compound[which(reddit_sentiment$compound < 0)] <- "Negative"
reddit_sentiment$compound[which(reddit_sentiment$compound == 0)] <- "Neutral"
reddit_sentiment$compound[which(!(reddit_sentiment$compound
                                  %in% c("Negative", "Neutral")))] <- "Positive"


# Links (filter out images, twitter and sources)
https <- reddit_sentiment[grepl("https", reddit_sentiment$link) & 
                      !grepl("jpg", reddit_sentiment$link) &
                      !grepl("twitter", reddit_sentiment$link),]

# Extract media source
https$source <- substring(https$link, 9, 40)

# Keep distinct sources 
https <- https %>%
  distinct(link, .keep_all = TRUE)

# Labelling according to MediaBias
https$label <- with(https, ifelse(grepl("abc", https$link), 
                                  "Reliable", NA_real_))

https$label <- with(https, ifelse(grepl("cbc", https$link), 
                                  "Reliable", https$label))

https$label <- with(https, ifelse(grepl("guardian", https$link), 
                                  "Mostly Reliable", https$label))

https$label <- with(https, ifelse(grepl("toronto", https$link), 
                                  "Mostly Reliable", https$label))

https$label <- with(https, ifelse(grepl("thelocal", https$link), 
                                  "Reliable", https$label))

https$label <- with(https, ifelse(grepl("thewsj", https$link), 
                                  "Mostly Reliable", https$label))

https$label <- with(https, ifelse(grepl("citynews", https$link), 
                                  "Reliable", https$label))

https$label <- with(https, ifelse(grepl("ema.europa", https$link), 
                                  "Reliable", https$label))

https$label <- with(https, ifelse(grepl("fhi", https$link), 
                                  "Reliable", https$label))

https$label <- with(https, ifelse(grepl("nwemail", https$link), 
                                  "Reliable", https$label))

https$label <- with(https, ifelse(grepl("childrenshealth", https$link), 
                                  "Unreliable", https$label))

https$label <- with(https, ifelse(grepl("nationalfile", https$link), 
                                  "Unreliable", https$label))

https$label <- with(https, ifelse(grepl("dailymail", https$link), 
                                  "Unreliable", https$label))

https$label <- with(https, ifelse(grepl("ctv", https$link), 
                                  "Reliable", https$label))

https$label <- with(https, ifelse(grepl("cbsnews", https$link), 
                                  "Unreliable", https$label))

https$label <- with(https, ifelse(grepl("archive", https$link), 
                                  "Unreliable", https$label))

https$label <- with(https, ifelse(grepl("timesofindia", https$link), 
                                  "Unreliable", https$label))

https$label <- with(https, ifelse(grepl("cnbc", https$link), 
                                  "Mostly Reliable", https$label))

https$label <- with(https, ifelse(is.na(https$label), 
                                  "Reliable", https$label))


# Count number of reliable news articles in each of the subreddits
https_count <- https %>%
  group_by(subreddit, label) %>%
  summarize(n = n())


# Labelling Media sources 
reddit_sentiment$media <- with(reddit_sentiment, 
                               ifelse(grepl("https", reddit_sentiment$link)
                                      & !grepl("jpg", reddit_sentiment$link) &
                                        !grepl("twitter", reddit_sentiment$link) |
                                        grepl("http", reddit_sentiment$link), 
                                      "News Articles", NA_real_))
# Labelling shared image sources
reddit_sentiment$media <- with(reddit_sentiment, 
                               ifelse(grepl("jpg", reddit_sentiment$link), 
                                      "Shared Images", reddit_sentiment$media))

# Labelling Twitter shares 
reddit_sentiment$media <- with(reddit_sentiment, 
                               ifelse(grepl("twitter", reddit_sentiment$link), 
                                      "Twitter shares", reddit_sentiment$media))




# Media sources of each of the subreddits 
reddit_count <- reddit_sentiment %>%
  group_by(subreddit, media) %>%
  summarize(n = n()) %>%
  drop_na(media)



# Overall breadkdown of reddit media sources with subreddits 
png(filename = "reddits_sources.png", width = 20, height = 15, units = "cm", 
    res = 300)


p <- ggplot(reddit_count, aes(x= subreddit , y= n )) + 
  geom_bar(stat = "identity", aes(fill = media)) +
  coord_flip() + scale_color_viridis(discrete = TRUE, option = "D") +
  scale_fill_viridis(discrete = TRUE) + labs(y = "Number of Posts", 
                                             x = "Subreddits") +
  theme_classic() 

p

dev.off()


