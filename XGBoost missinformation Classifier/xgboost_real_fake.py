#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun May 30 00:15:13 2021

@author: nikhilsaini
"""

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat May 29 23:01:30 2021

@author: nikhilsaini
"""

from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import RepeatedStratifiedKFold
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.feature_extraction.text import CountVectorizer
from xgboost import XGBClassifier
import pandas as pd
import os

data =  pd.read_csv('/Users/nikhilsaini/Downloads/read_fake_dat.csv', engine = 'python')


cv = CountVectorizer(max_features=5000, encoding="utf-8",  
      ngram_range = (1,3),  
      token_pattern = "[A-Za-z_][A-Za-z\d_]*")

X = cv.fit_transform(data.title).toarray()
y = data['label']


X_train, X_test, y_train, y_test = train_test_split(X, y, 
      test_size=0.33, 
      random_state=0)



count_df = pd.DataFrame(X_train, columns=cv.get_feature_names())

count_df['etiket'] = y_train
y_train.replace({"real": 1, "fake": 0})


model = XGBClassifier()

weights = [1, 10, 25, 50, 75, 99, 100, 1000]
param_grid = dict(scale_pos_weight=weights)

cv = RepeatedStratifiedKFold(n_splits=10, n_repeats=3, random_state=1)

grid = GridSearchCV(estimator=model, param_grid=param_grid, n_jobs=-1, cv=cv, scoring='roc_auc')

grid_result = grid.fit(X_train, y_train)

print("Best: %f using %s" % (grid_result.best_score_, grid_result.best_params_))
# report all configurations
means = grid_result.cv_results_['mean_test_score']
stds = grid_result.cv_results_['std_test_score']
params = grid_result.cv_results_['params']
for mean, stdev, param in zip(means, stds, params):
    print("%f (%f) with: %r" % (mean, stdev, param))
    
    
y_pred = grid.predict(X_test)
predictions = [(value) for value in y_pred]


accuracy = accuracy_score(y_test, predictions)
print("Accuracy: %.2f%%" % (accuracy * 100.0))

