#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Aug 18 13:04:41 2019

@author: katrinstricker
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


%matplotlib automatic
%matplotlib inline


US = pd.read_csv("Model_LV.csv")
geography = US['Geography']
US.info()


# Replace zero values with 1 inplace=True
US['US_CS_2019'].replace(0, "1", inplace=True)
newyork.US_CS_2019.head(20)


#convert object in numeric
US.US_CS_2019 = US.US_CS_2019.astype('int64') 
US.US_CS_2019.head(20)
US.info()


#writing used columns in dataframe
US = US[["US_CS_2019", "Pop_Est_2018", "EV_total_2025", "Weight_Range_low", "Weight_Range_high", "Housing_detached",
         "Apartments", "One_car", "Two_cars", "Value_Median_dollars", "Inc_household"]]

US.info()
US.describe()
from pandas import ExcelWriter
statistics = US.describe()
statistics.to_excel(r'Macintosh HD\Users\katrinstricker\Downloads\NY_housing\statistics.xlsx')



#distribution of target variable
newyork['US_CS_2019'].hist(bins=10)
plt.tight_layout()


import scipy.stats as stats

stats.probplot(US['US_CS_2019'], plot=plt)
plt.tight_layout()

stats.shapiro(US['US_CS_2019'])

#log variable
np.log(US['US_CS_2019']).hist(bins=10)
np.log(US['US_CS_2019']).describe()


stats.probplot(np.log(US['US_CS_2019']), plot=plt)
plt.tight_layout()


#correlation matrix
corr_matrix = newyork.iloc[:,1:].corr()
corr_matrix

np.where((corr_matrix >= 0.85) | (corr_matrix <= -0.85))

#heatmap
import seaborn as sns
fig, (ax) = plt.subplots(1, 1, figsize=(10,6))

sns.set(rc={'figure.figsize':(12.7,12.27)}, font_scale=0.7)
sns.heatmap(US.corr(), 
            vmin=-1.0, vmax=1.0,
            cmap="coolwarm", annot=True),  
fig.subplots_adjust(top=0.93)
fig.suptitle('US Charging Correlation Heatmap', 
              fontsize=14, 
              fontweight='bold')
plt.tight_layout()


#Correlation with output variable
cor_target = abs(cor["US_CS_2019"])
relevant_features = cor_target[cor_target>0.5]
relevant_features

#plot of all variables
sns.pairplot(US)
plt.legend

# set X and y variables
X = US[["Pop_Est_2018", "EV_total_2025", "Weight_Range_low", "Weight_Range_high", "Housing_detached", "Apartments",
                   "One_car", "Two_cars", "Value_Median_dollars", "Inc_household"]]
y = US['US_CS_2019']
# to align geography with y prediction outcomes
y = pd.DataFrame({'y':y, 'Geography':geography})

from sklearn.model_selection import train_test_split
#create train/test split and write geography to y col
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=1000)
g_train = y_train['Geography']
g_test = y_test['Geography']
y_train = y_train['y']
y_test = y_test['y']


from sklearn.linear_model import Ridge
from sklearn.model_selection import GridSearchCV

# Define possible values of alpha:
alphas = {'alpha': np.linspace(0, 50, 200)}


# Iterate the grid of alphas with 5-fold cross-validation:
ridge_cv = GridSearchCV(estimator=Ridge(random_state=1000, normalize = True), 
                        param_grid=alphas, scoring="r2", cv=5, 
                        n_jobs=2, return_train_score=True)
#run regression
ridge_cv.fit(X_train, y_train)

# DataFrame of results for each cross validation based on
# the rank of alphas on the testing set:
ridge_cv.cv_results_.keys()
ridge_cv_results = (pd.DataFrame(ridge_cv.cv_results_)[['param_alpha', 
                    'mean_train_score', 'mean_test_score', 'rank_test_score']]
                    .sort_values('rank_test_score', ascending=True))

# the best optimised alphas 
ridge_cv_results.head(10) 
# least optimal alphas
ridge_cv_results.tail(10) 
ridge_cv_results.to_excel(r'Macintosh HD\Users\katrinstricker\Downloads\NY_housing\cvresults.xlsx')

ridge_cv.best_estimator_ 
# Values of coefficients for the best estimator
ridge_cv.best_estimator_.coef_ 


# Obtain the hat values on the training set:
ridge_fitted = ridge_cv.predict(X_train)

from sklearn.metrics import mean_absolute_error
mean_absolute_error(y_train, ridge_fitted) 
from sklearn.metrics import r2_score
r2_score(y_train, ridge_fitted)

# Calculate the predicted y values on the test set:

pred_y_test_ridge_cv = ridge_cv.predict(X_test)


#write dataframe with actual and predicted values
df = pd.DataFrame({'Geography': g_test ,'Actual': y_test, 'Predicted': pred_y_test_ridge_cv})
df
df.to_excel(r'Macintosh HD\Users\katrinstricker\Downloads\NY_housing\CSresults.xlsx')


# Evaluate the predictions on the test set:
from sklearn import metrics
print('Mean Absolute Error:', mean_absolute_error(y_test, pred_y_test_ridge_cv))
print('Mean Squared Error:', metrics.mean_squared_error(y_test, pred_y_test_ridge_cv))
print('Root Mean Squared Error:', np.sqrt(metrics.mean_squared_error(y_test, pred_y_test_ridge_cv)))
print('R2:', r2_score(y_test, pred_y_test_ridge_cv))


fig, (ax) = plt.subplots(1, 1, figsize=(12,6))
plt.plot(range(len(y_test)),y_test, 'ro', label = 'actual')
plt.plot(range(len(y_test)),pred_y_test_ridge_cv,'bo', label = 'predicted')
fig.suptitle('Model fit Plot Ridge model', 
              fontsize=12, 
              fontweight='bold')
plt.legend(loc='best')
plt.suptitle()
plt.tight_layout()









