---
title: "Code Book for the run_analysis.R script"
author: "Rodrigo Gomez-Fell"
date: "Thursday, March 19, 2015"
output: html_document
keep_md: yes
---

#Codebook for run_analysis.R script
## Project Description

 This codebook describes the variables, data, and transformations or work performed in order to clean up the data set given in the Getting and Cleaning Data Course Project



##Study design and data processing

###Collection of the raw data
The data was obtained from the UCI web site 

The link to the original data 
[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]

The database has the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

The data is distributed among several files and directories, in order to have a tidy data set to work with, we need to merge data from the test group and the train groups and the id the different activitys with the different features meassured and subjects that perform the tests.

A more comprehensive expalantion is on the readme file.


##Creating the tidy datafile

###Steps done to the data in order to have a tidy data set to work with (no code only description, code is found in the Readme file)

1. Download the files from [http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip]
2. Unzip them in youre computer
3. Read the data into the program (we use R)
4.Merge the data sets together, and subset if necesary'
5.Name the variables and activities according to the features.txt file that came with the data, for a more comprehensive reading.
6. Subset the data set with Mean and Std columns
7. Check that your variables are in columns and observations in rows, change if necesary.
7. Group and summarize your data
8. Save your final tidy data set into a file

More detail and code in the readme file on this github repo [https://github.com/RGFell/get_data_project] also the run_analysis.R script is available

##Description of the variables in the tidyData.txt file
The final tidy data set in the tidyData.txt file, containes 4 variables is in a long tidy format:
 - Dimensions: 4 variables  14220 observations
  - Variables:
        + Activity
        + Subject
        + Meassure_Variable
        + Mean
                
 This is an print of the first 6 rows of the Data Set.
 
```R 
   Activity Subject                 Meassure_Variable        Mean
1   LAYING       1    time_BodyAcceleration-mean()-X  0.22159824
2   LAYING       1    time_BodyAcceleration-mean()-Y -0.04051395
3   LAYING       1    time_BodyAcceleration-mean()-Z -0.11320355
4   LAYING       1 time_GravityAcceleration-mean()-X -0.24888180
5   LAYING       1 time_GravityAcceleration-mean()-Y  0.70554977
6   LAYING       1 time_GravityAcceleration-mean()-Z  0.44581772
```
The data set has

4  Variables      14220  Observations


You can get the final tidy data file running this lines of code.

```R
address <- "https://s3.amazonaws.com/coursera-uploads/user-4b3867938524790c458319eb/973499/asst-3/1a71c9c0cd9a11e4b8381b8ddf9f86ee.txt"
address <- sub("^https", "http", address)
data <- read.table(url(address), header = TRUE) 
View(data)
```
library(knitr)
kable(head(final_df), format = "markdown")

The variables are describe below

###Activity 

Different activities performed by the subjects
 
  - Total observartions   14220
  - Missing observarions  0
  - Unique onservations   6
  - Class Factor with 6 levels

LAYING (2370, 17%), SITTING (2370, 17%), STANDING (2370, 17%) 
WALKING (2370, 17%), WALKING_DOWNSTAIRS (2370, 17%) 
WALKING_UPSTAIRS (2370, 17%)

###Subject
 
Group of 30 different people that perdormed the activities
 
  - Total observartions   14220
  - Missing observarions  0
  - Unique onservations   30
  - Class Integer 1:30

###Meassure_Variable
 This group has the mean and standard deviation of the features recorded (body acceleration, gravity aceleration) on the experiment in each of the axis (X, Y, Z), Jerk signals from time derivations, magnitudes using Euclidean form and Fourier transformations applied to some signals.
 
  - Total observartions   14220
  - Missing observarions  0
  - Unique onservations   79
  - Class factor with 79 levels
  
List of the variables groups:

* time_BodyAcceleration-XYZ
* time_GravityAcceleration-XYZ
* time_BodyAccJerk-XYZ
* time_BodyGyro-XYZ
* time_BodyGyroJerk-XYZ
* time_BodyAccMag
* time_GravityAccMag
* time_BodyAccJerkMag
* time_BodyGyroMag
* time_BodyGyroJerkMag
* fourierTrans_BodyAcc-XYZ
* fourierTrans_BodyAccJerk-XYZ
* fourierTrans_BodyGyro-XYZ
* fourierTrans_BodyAccMag
* fourierTrans_BodyAccJerkMag
* fourierTrans_BodyGyroMag
* fourierTrans_BodyGyroJerkMag

###Mean
 
Mean value of each variable for each activity and each subject.
 
  - Total observartions   14220
  - Missing observarions  0
  - Unique onservations   30
  - Class numeric
  
 Min.   :-0.99767  
 1st Qu.:-0.95242  
 Median :-0.34232  
 Mean   :-0.41241  
 3rd Qu.:-0.03654  
 Max.   : 0.97451  


lowest values: -0.9977 -0.9976 -0.9976 -0.9973 -0.9971, 
highest values:  0.9669  0.9686  0.9691  0.9726  0.9745 
  


##Sources

Template, "Codebook template" author: "Joris Schut"
