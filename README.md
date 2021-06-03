#  A Pipeline for identifying vaccine-specific infodemic insights and leveraging NLP deep learning models to predict misinformation
## Code for the 2021 STEM Big Data Challenge (Team 70)

All datasets used can be found in the datasets folder:

dat_reddit.csv - Reddit dataset 

dat_reddit_sentiment.csv - Reddit dataset with the sentiment scores added by VADER 

youtube_dat.csv - Youtube dataset 

youtube_sentiment.csv - Youtube dataset with the sentiment scores added by VADER 

read_fake_trainingForLSTMandXGBoost.csv - Reddit labelled dataset for the misinformation classifier 

RNN LSTM Misinformation Classifier - Contains the training dataset and Python script with the RNN Model Specification 

Reddit Data Extraction - Contains the R script used to extract the Reddit data for the time-series analysis, sentiment analysis and topic modelling using the RedditExtractoR library (Rivera, 2019). Also contains the R script used to extract the Reddit-text data specifically for the misinformation classifier. 

Reddit Image Scrapper - Contains the Python script used to extract images from Reddit for the misinformation classifier. Contains a dataset with some sample images from which text was extracted. 

XGBoost Misinformation Classifier - Contains the training dataset and Python script with the XGBoost Model Specification 

Youtube Scrapper - Contains the Python script used to scrape data via the YouTube API as well as an R file used to clean said YouTube Data

information-sources - Contains R script of descriptive analysis of media source reliability 
