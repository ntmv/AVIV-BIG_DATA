 

## Create a reddit account!
- Signup for a reddit account.
- Select the "Are you a developer? Create an app button" <a href="https://reddit.com/prefs/apps"  target="_blank">Here</a>.
- Give you program a name and a redirect URL(http://<span></span>localhost).
- On the final screen note your client id and secret.


## Run download script!
- Add any subs you want to download to the sub_list.csv one per line.
- Run SubDownload.py
- The first time you run the script it will ask you for details. Note you don't need to enter a user name or password if you don't plan on posting.
- The script will create a token.pickle file so you don't have to enter them again. If you mess up your credentials just delete the pickle file and it will ask for them again.
- The script will create an images folder and fill it with images it finds. You can change how many posts it checks on each subreddit by changing POST_SEARCH_AMOUNT. Also not note every post is a image post so if you put in 5 it may only find 2 images.



