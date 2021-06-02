#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun May 23 16:34:23 2021

@author: nikhilsaini
"""

# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""


from apiclient.discovery import build
import argparse 
import unidecode 
import time 
import os 
import pandas as pd 
from selenium import webdriver 
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as KC
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.by import By
from textblob import TextBlob
import re
from oauth2client.client import SignedJwtAssertionCredentials
from httplib2 import Http



DEV_KEY="" # insert a YouTube Data API key 


SERVICE_NAME = "youtube"
YOU_API_VERSION = "v3"



titles = []
publishtime= []
videoids= []
channeltitles = []
video_description = []
comments = []
page_token = []

def youtube_url_collect(options):
    youtube = build(SERVICE_NAME, YOU_API_VERSION, developerKey=DEV_KEY)
    #search_responses = youtube.search().list(q=options.q, part="id,snippet", maxResults = options.max_results, regionCode=options.region_code, order='date', pageToken=str("".join(page_token)), publishedAfter ="2020-12-01T09:47:22Z" ).execute()
    search_responses = youtube.search().list(q=options.q, part="id,snippet", maxResults = options.max_results,  order='date', pageToken=str("".join(page_token)), publishedAfter ="2020-12-01T09:47:22Z" ).execute()
    #print(search_responses)
    nn = 0 
    
    for search_result in search_responses.get("items", []):
        print(search_result)
     
        if search_result["id"]["kind"] == "youtube#video":
            nn = nn+1
            videoid = search_result["id"]["videoId"]
            publish_date = search_result["snippet"]["publishedAt"]
            print("Video ID = ", (videoid))
            print("video published on = ", publish_date)
            print("serial number = ", nn)
            print("\n")
            videoids.append(videoid)
            
    page_token.clear()
    for search_result1 in search_responses.get("nextPageToken"):
        
        page_token.append(search_result1)
        
         
          

def comment_extractor(list_of_ids):
    youtube = build(SERVICE_NAME, YOU_API_VERSION, developerKey=DEV_KEY)
    data = []
    for  ids in list_of_ids:
      try:
         print ( "for ", ids) 
         comment = youtube.commentThreads().list(part="id,snippet,replies",  videoId=ids, maxResults=100).execute()
         comment_list = []
         date_pub = []
         like_count = []
         for c in comment.get("items", []):
           
             g = c["snippet"]["topLevelComment"]["snippet"]["textOriginal"]
             pp = c["snippet"]["topLevelComment"]["snippet"]["publishedAt"]
             like = c["snippet"]["topLevelComment"]["snippet"]["likeCount"]
             comment_list.append(g)
             date_pub.append(pp)
             like_count.append(like)
             print((g))
             #print(c)
             print("-------------------------------------------------------------------------INFOR SEPERATOR-------")
         data.append([ids, comment_list, date_pub, like_count])
         print ( "++++++++++++++++++++++VIDEO  SEPERATOR++++++++++++++++++++++++++++++++++++++++ ") 
     
       #print(comment)
      except:
         pass
         print ( "++++++++++++++++++++++VIDEO  SEPERATOR++++++++++++++++++++++++++++++++++++++++ ") 
    return data






if __name__ == "__main__":
       print("Enter the search query:")
       x = str(input())
       parser = argparse.ArgumentParser(description='youtube search')
       parser.add_argument("--q", help="Search term", default = x)
       parser.add_argument("--max-results", help="Max results", default=50)
      # parser.add_argument("--region_code", help="Max results", default="CA")
       args = parser.parse_args()
       youtube_url_collect(args)
       #comment_data =  comment_extractor(videoids)
       n = 2
      
       try:
               while n >= 0:
                   n = n + 1 
                   
                   youtube_url_collect(args)
                  
                       
                   
              
               
       except:
           pass
               
       comment_data =  comment_extractor(videoids)

       import pandas as pd 

       comm = []

       datee = []


        
       for fg in comment_data:
           ccc = fg[1]
           ddd = fg[2]
           for hj in range(len(ccc)):
               newww= [ccc[hj], ddd[hj]]
               comm.append(newww)


       comm_sep=[]

       dat_sep=[]

       for fghj in comm:
          comm_sep.append(fghj[0])
          dat_sep.append(fghj[1])
       covid19_df = {"comments": comm_sep, "dateStamp": dat_sep}

       covid19_df2 = pd.DataFrame(data=covid19_df)
       covid19_df2.to_csv("name_of_csv.csv")
            
       
       
       
       
       
       
       
       
       
       
        