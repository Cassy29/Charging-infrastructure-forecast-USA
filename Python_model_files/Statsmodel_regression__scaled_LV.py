#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug 22 18:03:24 2019

@author: katrinstricker
"""


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

US = pd.read_csv("Model_LV.csv")
#atransform object variable for later predictions
geography = US['Geography']
US.info()



# Reolace zero values with 1 inplace=True
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
US['US_CS_2019'].hist(bins=10)
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

sns.set(rc={'figure.figsize':(12.7,12.27)}, font_scale=0.8)
sns.heatmap(US.corr(), 
            vmin=-1.0, vmax=1.0,
            cmap="coolwarm", annot=True),  
fig.subplots_adjust(top=0.93)
fig.suptitle('US Charging Attributes Correlation Heatmap', 
              fontsize=14, 
              fontweight='bold')
plt.tight_layout()

#Correlation with output variable
cor = US.corr()
cor_target = abs(cor["US_CS_2019"])
relevant_features = cor_target[cor_target>0.5]
relevant_features

#plot of all variables
sns.pairplot(US)
plt.legend

from sklearn import preprocessing
# Get column names first
names = US.columns
# Create the Scaler object
scaler = preprocessing.StandardScaler()
# Fit your data on the scaler object
US_scaled = scaler.fit_transform(US)
US_scaled = pd.DataFrame(US_scaled, columns=names)

# set X and y variables - based on the VIF test
X = US_scaled[["EV_total_2025", "Weight_Range_low", "Weight_Range_high",
                   "Value_Median_dollars"]]
y = US_scaled['US_CS_2019']
# to align geography with y prediction outcomes
y = pd.DataFrame({'y':y, 'Geography':geography})

from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=1000)
g_train = y_train['Geography']
g_test = y_test['Geography']
y_train = y_train['y']
y_test = y_test['y']



import statsmodels.api as sm


#fit model
model2 = sm.OLS(y_train, X_train).fit()
#run predictions
predictions = model2.predict(X_test) 

# Print out the statistics

model2.summary()

#dateframe for preidcted values
df = pd.DataFrame({'Geography': g_test ,'Actual': y_test, 'Predicted': predictions})
print(df)
df.to_excel(r'Macintosh HD\Users\katrinstricker\Downloads\NY_housing\LRresults.xlsx')

#model fit plot
fig, (ax) = plt.subplots(1, 1, figsize=(12,6))
plt.plot(range(len(y_test)),y_test, 'ro', label = 'actual')
plt.plot(range(len(y_test)), predictions,'bo', label = 'predicted')
fig.suptitle('Model fit Plot OLS model', 
              fontsize=12, 
              fontweight='bold')
plt.legend(loc='best')
plt.suptitle()
plt.tight_layout()

#scatter plot regression/independent variables
fig = plt.figure(figsize=(12,8))
fig = sm.graphics.plot_partregress_grid(model2, fig=fig)

fig = plt.figure(figsize=(12,8))
fig = sm.graphics.plot_regress_exog(model2, 'EV_total_2025', fig=fig)

fig = plt.figure(figsize=(12,8))
fig = sm.graphics.plot_regress_exog(model2, 'Weight_Range_low', fig=fig)

fig = plt.figure(figsize=(12,8))
fig = sm.graphics.plot_regress_exog(model2, 'Weight_Range_high', fig=fig)

fig = plt.figure(figsize=(12,8))
fig = sm.graphics.plot_regress_exog(model2, 'Value_Median_dollars', fig=fig)

fig, ax = plt.subplots(figsize=(12,8))
fig = sm.graphics.plot_partregress("murder", "hs_grad", ["urban", "poverty", "single"],  ax=ax, data=dta)


beginningtex = """\\documentclass{report}
\\usepackage{booktabs}
\\begin{document}"""
endtex = "\end{document}"

f = open('myreg.tex', 'w')
f.write(beginningtex)
f.write(model2.summary().as_latex())
f.write(endtex)
f.close()

DFS = model2.summary()
print(DFS.as_csv()


------------
