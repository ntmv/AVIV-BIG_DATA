#Libraries 
library(lubridate)
library(stringr)
library(dplyr)
library(tidyr)
library(tidytext)
library(topicmodels)
library(tidyverse)
library(tm)
library(wordcloud)
library(textmineR)


########################### Reddit Data ############################
# Subset negative sentiments of all four events 

# Astrazeneca
neg_az <- reddit_sentiment  %>%
  filter(compound == "Negative", event == "AZ Clots") %>%
  select(comment)

# Remove unnecessary symbols
neg_az$comment <- sub("&gt;", "", neg_az$comment)
neg_az$comment <- sub("@.* ", "", neg_az$comment)
neg_az$comment <- sub("https", "", neg_az$comment)
neg_az$comment <- sub("html", "", neg_az$comment)

# Add id column
neg_az$id <- seq(1, nrow(neg_az), 1)

# Remove digits
# Remove punctuation 
# Remove white space 
# Tokenize text 
text_cleaning_tokens <- neg_az %>% 
  unnest_tokens(word, comment)
text_cleaning_tokens$word <- gsub('[[:digit:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens$word <- gsub('[[:punct:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens <- text_cleaning_tokens %>% filter(!(nchar(word) == 1))%>% 
  anti_join(stop_words)
tokens <- text_cleaning_tokens %>% filter(!(word==""))
tokens <- tokens %>% mutate(ind = row_number())
tokens <- tokens %>% group_by(id) %>% mutate(ind = row_number()) %>%
  tidyr::spread(key = ind, value = word)
tokens [is.na(tokens)] <- ""
tokens <- tidyr::unite(tokens, comments,-id,sep =" " )
tokens$comments <- trimws(tokens$comments)

#create DTM
dtm <- CreateDtm(tokens$comments, 
                 doc_names = tokens$id, 
                 ngram_window = c(1, 2))


# Fit LDA model
model <- FitLdaModel(dtm = dtm, k = 5, iterations = 500)

# Calculate prevalence of each topic 
model$prevalence <- colSums(model$theta)/sum(model$theta) *100


# Generate mode topics top terms 
model$top_terms <- GetTopTerms(phi = model$phi, M = 40)
top40_wide <- as.data.frame(model$top_terms)

# Model labels 
model$labels <- LabelTopics(assignments = model$theta > 0.05, 
                            dtm = dtm, M = 1)


# Pfizer children 
neg_pc <- reddit_sentiment  %>%
  filter(compound == "Negative", event == "Pfizer Children") %>%
  select(comment)

# Remove unnecessary symbols
neg_pc$comment <- sub("&gt;", "", neg_pc$comment)
neg_pc$comment <- sub("@.* ", "", neg_pc$comment)
neg_pc$comment <- sub("https", "", neg_pc$comment)
neg_pc$comment <- sub("html", "", neg_pc$comment)
neg_pc$comment <- sub("www", "", neg_pc$comment)
neg_pc$comment <- sub("com", "", neg_pc$comment)

# Add id column
neg_pc$id <- seq(1, nrow(neg_pc), 1)


# Remove digits
# Remove punctuation 
# Remove white space 
# Tokenize text 
text_cleaning_tokens <- neg_pc %>% 
  unnest_tokens(word, comment)
text_cleaning_tokens$word <- gsub('[[:digit:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens$word <- gsub('[[:punct:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens <- text_cleaning_tokens %>% filter(!(nchar(word) == 1))%>% 
  anti_join(stop_words)
tokens <- text_cleaning_tokens %>% filter(!(word==""))
tokens <- tokens %>% mutate(ind = row_number())
tokens <- tokens %>% group_by(id) %>% mutate(ind = row_number()) %>%
  tidyr::spread(key = ind, value = word)
tokens [is.na(tokens)] <- ""
tokens <- tidyr::unite(tokens, comments,-id,sep =" " )
tokens$comments <- trimws(tokens$comments)

#create DTM
dtm <- CreateDtm(tokens$comments, 
                 doc_names = tokens$id, 
                 ngram_window = c(1, 2))


# Fit LDA model
model1 <- FitLdaModel(dtm = dtm, k = 5, iterations = 500)

# Calculate prevalence of each topic 
model1$prevalence <- colSums(model1$theta)/sum(model1$theta) *100


# Generate mode topics top terms 
model1$top_terms <- GetTopTerms(phi = model1$phi, M = 40)
top40_wide <- as.data.frame(model1$top_terms)

# Model labels 
model1$labels <- LabelTopics(assignments = model1$theta > 0.05, 
                            dtm = dtm, M = 1)


# Pfizer heart
neg_ph <- reddit_sentiment  %>%
  filter(compound == "Negative", event == "Pfizer Heart") %>%
  select(comment)

# Remove unnecessary symbols
neg_ph$comment <- sub("&gt;", "", neg_ph$comment)
neg_ph$comment <- sub("@.* ", "", neg_pc$comment)
neg_ph$comment <- sub("https", "", neg_ph$comment)
neg_ph$comment <- sub("html", "", neg_ph$comment)
neg_ph$comment <- sub("www", "", neg_ph$comment)
neg_ph$comment <- sub("com", "", neg_ph$comment)

# Add id column
neg_ph$id <- seq(1, nrow(neg_ph), 1)

# Remove digits
# Remove punctuation 
# Remove white space 
# Tokenize text 
text_cleaning_tokens <- neg_ph %>% 
  unnest_tokens(word, comment)
text_cleaning_tokens$word <- gsub('[[:digit:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens$word <- gsub('[[:punct:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens <- text_cleaning_tokens %>% filter(!(nchar(word) == 1))%>% 
  anti_join(stop_words)
tokens <- text_cleaning_tokens %>% filter(!(word==""))
tokens <- tokens %>% mutate(ind = row_number())
tokens <- tokens %>% group_by(id) %>% mutate(ind = row_number()) %>%
  tidyr::spread(key = ind, value = word)
tokens [is.na(tokens)] <- ""
tokens <- tidyr::unite(tokens, comments,-id,sep =" " )
tokens$comments <- trimws(tokens$comments)

#create DTM
dtm <- CreateDtm(tokens$comments, 
                 doc_names = tokens$id, 
                 ngram_window = c(1, 2))

# Fit LDA model
model2 <- FitLdaModel(dtm = dtm, k = 5, iterations = 500)

# Calculate prevalence of each topic 
model2$prevalence <- colSums(model2$theta)/sum(model2$theta) *100


# Generate mode topics top terms 
model2$top_terms <- GetTopTerms(phi = model2$phi, M = 40)
top40_wide <- as.data.frame(model2$top_terms)

# Model labels 
model2$labels <- LabelTopics(assignments = model2$theta > 0.05, 
                             dtm = dtm, M = 1)



# Vaccine variants 
neg_vv <- reddit_sentiment  %>%
  filter(compound == "Negative", event == "Vaccines Variants") %>%
  select(comment)


# Remove unnecessary symbols
neg_vv$comment <- sub("&gt;", "", neg_vv$comment)
neg_vv$comment <- sub("@.* ", "", neg_vv$comment)
neg_vv$comment <- sub("https", "", neg_vv$comment)
neg_vv$comment <- sub("html", "", neg_vv$comment)
neg_vv$comment <- sub("www", "", neg_vv$comment)
neg_vv$comment <- sub("com", "", neg_vv$comment)
neg_vv$comment <- sub("reddit", "", neg_vv$comment)

# Add id column
neg_vv$id <- seq(1, nrow(neg_vv), 1)


# Remove digits
# Remove punctuation 
# Remove white space 
# Tokenize text 
text_cleaning_tokens <- neg_vv %>% 
  unnest_tokens(word, comment)
text_cleaning_tokens$word <- gsub('[[:digit:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens$word <- gsub('[[:punct:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens <- text_cleaning_tokens %>% filter(!(nchar(word) == 1))%>% 
  anti_join(stop_words)
tokens <- text_cleaning_tokens %>% filter(!(word==""))
tokens <- tokens %>% mutate(ind = row_number())
tokens <- tokens %>% group_by(id) %>% mutate(ind = row_number()) %>%
  tidyr::spread(key = ind, value = word)
tokens [is.na(tokens)] <- ""
tokens <- tidyr::unite(tokens, comments,-id,sep =" " )
tokens$comments <- trimws(tokens$comments)

#create DTM
dtm <- CreateDtm(tokens$comments, 
                 doc_names = tokens$id, 
                 ngram_window = c(1, 2))

# Fit LDA model
model3 <- FitLdaModel(dtm = dtm, k = 5, iterations = 500)

# Calculate prevalence of each topic 
model3$prevalence <- colSums(model3$theta)/sum(model3$theta) *100


# Generate mode topics top terms 
model3$top_terms <- GetTopTerms(phi = model3$phi, M = 40)
top40_wide <- as.data.frame(model3$top_terms)

# Model labels 
model3$labels <- LabelTopics(assignments = model3$theta > 0.05, 
                             dtm = dtm, M = 1)

# Clearing environment 
rm(list = ls())
######################### Youtube data ##############################
# Astrazeneca
neg_az <- youtube_sentiment %>%
  filter(compound == "Negative", event == "AZ Clots") %>%
  select(comments)


# Remove unnecessary symbols
neg_az$comments <- sub("&gt;", "", neg_az$comments)
neg_az$comments <- sub("@.* ", "", neg_az$comments)
neg_az$comments <- sub("https", "", neg_az$comments)
neg_az$comments <- sub("html", "", neg_az$comments)

# Add id column
neg_az$id <- seq(1, nrow(neg_az), 1)


# Remove digits
# Remove punctuation 
# Remove white space 
# Tokenize text 
text_cleaning_tokens <- neg_az %>% 
  unnest_tokens(word, comments)
text_cleaning_tokens$word <- gsub('[[:digit:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens$word <- gsub('[[:punct:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens <- text_cleaning_tokens %>% filter(!(nchar(word) == 1))%>% 
  anti_join(stop_words)
tokens <- text_cleaning_tokens %>% filter(!(word==""))
tokens <- tokens %>% mutate(ind = row_number())
tokens <- tokens %>% group_by(id) %>% mutate(ind = row_number()) %>%
  tidyr::spread(key = ind, value = word)
tokens [is.na(tokens)] <- ""
tokens <- tidyr::unite(tokens, comments,-id,sep =" " )
tokens$comments <- trimws(tokens$comments)

#create DTM
dtm <- CreateDtm(tokens$comments, 
                 doc_names = tokens$id, 
                 ngram_window = c(1, 2))

# Fit LDA model
model <- FitLdaModel(dtm = dtm, k = 5, iterations = 500)

# Calculate prevalence of each topic 
model$prevalence <- colSums(model$theta)/sum(model$theta) *100


# Generate mode topics top terms 
model$top_terms <- GetTopTerms(phi = model$phi, M = 40)
top40_wide <- as.data.frame(model$top_terms)

# Model labels 
model$labels <- LabelTopics(assignments = model$theta > 0.05, 
                             dtm = dtm, M = 1)



# Pfizer children 
neg_pc <- youtube_sentiment  %>%
  filter(compound == "Negative", event == "Pfizer Children") %>%
  select(comments)

# Add id column
neg_pc$id <- seq(1, nrow(neg_pc), 1)


# Remove digits
# Remove punctuation 
# Remove white space 
# Tokenize text 
text_cleaning_tokens <- neg_pc %>% 
  unnest_tokens(word, comments)
text_cleaning_tokens$word <- gsub('[[:digit:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens$word <- gsub('[[:punct:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens <- text_cleaning_tokens %>% filter(!(nchar(word) == 1))%>% 
  anti_join(stop_words)
tokens <- text_cleaning_tokens %>% filter(!(word==""))
tokens <- tokens %>% mutate(ind = row_number())
tokens <- tokens %>% group_by(id) %>% mutate(ind = row_number()) %>%
  tidyr::spread(key = ind, value = word)
tokens [is.na(tokens)] <- ""
tokens <- tidyr::unite(tokens, comments,-id,sep =" " )
tokens$comments <- trimws(tokens$comments)

#create DTM
dtm <- CreateDtm(tokens$comments, 
                 doc_names = tokens$id, 
                 ngram_window = c(1, 2))


# Fit LDA model
model2 <- FitLdaModel(dtm = dtm, k = 5, iterations = 500)

# Calculate prevalence of each topic 
model2$prevalence <- colSums(model2$theta)/sum(model2$theta) *100


# Generate mode topics top terms 
model2$top_terms <- GetTopTerms(phi = model2$phi, M = 40)
top40_wide <- as.data.frame(model2$top_terms)

# Model labels 
model2$labels <- LabelTopics(assignments = model2$theta > 0.05, 
                             dtm = dtm, M = 1)


# Pfizer heart
neg_ph <- youtube_sentiment  %>%
  filter(compound == "Negative", event == "Pfizer Heart") %>%
  select(comments)

# Remove unnecessary symbols
neg_ph$comments <- sub("&gt;", "", neg_ph$comments)
neg_ph$comments <- sub("@.* ", "", neg_pc$comments)
neg_ph$comments <- sub("https", "", neg_ph$comments)
neg_ph$comments <- sub("html", "", neg_ph$comments)
neg_ph$comments <- sub("www", "", neg_ph$comments)
neg_ph$comments <- sub("com", "", neg_ph$comments)

# Add id column
neg_ph$id <- seq(1, nrow(neg_ph), 1)


# Remove digits
# Remove punctuation 
# Remove white space 
# Tokenize text 
text_cleaning_tokens <- neg_ph %>% 
  unnest_tokens(word, comments)
text_cleaning_tokens$word <- gsub('[[:digit:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens$word <- gsub('[[:punct:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens <- text_cleaning_tokens %>% filter(!(nchar(word) == 1))%>% 
  anti_join(stop_words)
tokens <- text_cleaning_tokens %>% filter(!(word==""))
tokens <- tokens %>% mutate(ind = row_number())
tokens <- tokens %>% group_by(id) %>% mutate(ind = row_number()) %>%
  tidyr::spread(key = ind, value = word)
tokens [is.na(tokens)] <- ""
tokens <- tidyr::unite(tokens, comments,-id,sep =" " )
tokens$comments <- trimws(tokens$comments)

#create DTM
dtm <- CreateDtm(tokens$comments, 
                 doc_names = tokens$id, 
                 ngram_window = c(1, 2))

# Fit LDA model
model3 <- FitLdaModel(dtm = dtm, k = 5, iterations = 500)

# Calculate prevalence of each topic 
model3$prevalence <- colSums(model3$theta)/sum(model3$theta) *100


# Generate mode topics top terms 
model3$top_terms <- GetTopTerms(phi = model3$phi, M = 40)
top40_wide <- as.data.frame(model3$top_terms)

# Model labels 
model3$labels <- LabelTopics(assignments = model3$theta > 0.05, 
                             dtm = dtm, M = 1)


# Vaccine variants 
neg_vv <- youtube_sentiment  %>%
  filter(compound == "Negative", event == "Vaccines Variants") %>%
  select(comments)


# Remove unnecessary symbols
neg_vv$comments <- sub("&gt;", "", neg_vv$comments)
neg_vv$comments <- sub("@.* ", "", neg_vv$comments)
neg_vv$comments <- sub("https", "", neg_vv$comments)
neg_vv$comments <- sub("html", "", neg_vv$comments)
neg_vv$comments <- sub("www", "", neg_vv$comments)
neg_vv$comments <- sub("com", "", neg_vv$comments)
neg_vv$comments <- sub("reddit", "", neg_vv$comments)

# Add id column
neg_vv$id <- seq(1, nrow(neg_vv), 1)

# Remove digits
# Remove punctuation 
# Remove white space 
# Tokenize text 
text_cleaning_tokens <- neg_vv %>% 
  unnest_tokens(word, comments)
text_cleaning_tokens$word <- gsub('[[:digit:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens$word <- gsub('[[:punct:]]+', '', text_cleaning_tokens$word)
text_cleaning_tokens <- text_cleaning_tokens %>% filter(!(nchar(word) == 1))%>% 
  anti_join(stop_words)
tokens <- text_cleaning_tokens %>% filter(!(word==""))
tokens <- tokens %>% mutate(ind = row_number())
tokens <- tokens %>% group_by(id) %>% mutate(ind = row_number()) %>%
  tidyr::spread(key = ind, value = word)
tokens [is.na(tokens)] <- ""
tokens <- tidyr::unite(tokens, comments,-id,sep =" " )
tokens$comments <- trimws(tokens$comments)

#create DTM
dtm <- CreateDtm(tokens$comments, 
                 doc_names = tokens$id, 
                 ngram_window = c(1, 2))


# Fit LDA model
model4 <- FitLdaModel(dtm = dtm, k = 5, iterations = 500)

# Calculate prevalence of each topic 
model4$prevalence <- colSums(model4$theta)/sum(model4$theta) *100


# Generate mode topics top terms 
model4$top_terms <- GetTopTerms(phi = model4$phi, M = 40)
top40_wide <- as.data.frame(model4$top_terms)

# Model labels 
model4$labels <- LabelTopics(assignments = model4$theta > 0.05, 
                             dtm = dtm, M = 1)


# Plotting bar plots 

p <- ggplot(df_1, aes(x= group , y= value)) + 
  geom_bar(stat = "identity", aes(fill = group)) +
  coord_flip() + scale_color_viridis(discrete = TRUE, option = "D") +
  scale_fill_viridis(discrete = TRUE) + labs(y = "Percent Prevalence", 
                                             x = "Negative Sentiment Topics") +
  theme_classic() 

p + theme(legend.position = "none") 

dev.off()


