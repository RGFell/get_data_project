# get_data_project
Repository for the project assignment for the Getting and Cleaning Data Course from the Coursera Data Science Specialization 

The idea of this assignemnt was to create a Tidy Data Set from recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors, from a UCI Human Activity Recognition Data Set.

##The Raw data:

###About the recording of the data
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

You can find the data at this link [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]

##The task at hand
In order to accomplished our goal of creating a tidy data set to work with from the different files provided and complete the tasks of the assignment, we needed first to create a R script called run_analysis.R, which is uploaded in this repo.

The script should do the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

In order to complete the task we created the R script and the different lines of code as follows.

#The code step by step
Download the files from [http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip]
```R
        temp <- tempfile()
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl ,temp)
```
Unzip them on youre computer
```R
unzip(temp, exdir = "./samsungDat")
unlink(temp)
```
Read the data in R
```R
xtest <- read.table("./samsungDat/UCI\ HAR\ Dataset/test/X_test.txt", header = F)
ytest <- read.table("./samsungDat/UCI\ HAR\ Dataset/test/Y_test.txt", header = F)
subject_test <- read.table("./samsungDat/UCI\ HAR\ Dataset/test/subject_test.txt", header = F)

xtrain <- read.table("./samsungDat/UCI\ HAR\ Dataset/train/X_train.txt", header = F)
ytrain <- read.table("./samsungDat/UCI\ HAR\ Dataset/train/Y_train.txt", header = F)
subject_train <- read.table("./samsungDat/UCI\ HAR\ Dataset/train/subject_train.txt", header = F)

features <- read.table("./samsungDat/UCI\ HAR\ Dataset/features.txt", header = F)

activity <- read.table("./samsungDat/UCI\ HAR\ Dataset/activity_labels.txt", header = F, colClasses= c("numeric", "character"))
```
Merge the data sets together, and subset them if necesary, in this case we used the dplyr package.
```R
    library(dplyr)

xtest_df <- tbl_df(xtest)
ytest_df <- tbl_df(ytest)

xtrain_df <- tbl_df(xtrain)
ytrain_df <- tbl_df(ytrain)

xmerge <- bind_rows(xtest_df, xtrain_df)
ymerge <- bind_rows(ytest_df, ytrain_df)

subject <- bind_rows(subject_test, subject_train)
```
Name the variables according to the features.txt file that came with the data
```R
colnames(ymerge) <- c("Activities")
colnames(xmerge) <- features$V2
colnames(subject)<- c("Subject")
```        
Change the names of the activity for a more descriptive name
```R
activityName <- vector()
for(i in 1:length(ymerge$Activities)){
        if(ymerge[i,1]==activity[1,1]){activityName[i] <-  activity[1,2]}
        if(ymerge[i,1]==activity[2,1]){activityName[i] <-  activity[2,2]}
        if(ymerge[i,1]==activity[3,1]){activityName[i] <-  activity[3,2]}
        if(ymerge[i,1]==activity[4,1]){activityName[i] <-  activity[4,2]}
        if(ymerge[i,1]==activity[5,1]){activityName[i] <-  activity[5,2]}
        if(ymerge[i,1]==activity[6,1]){activityName[i] <-  activity[6,2]}
        
}

activityName <- as.factor(activityName)
activityName <- as.data.frame(activityName)
```
Use function grepl() to search for mean and std strings
```R
textMean <- grepl("mean", features$V2)
textStd <- grepl("std", features$V2)
```
With logic vectors subset the data set with Mean and Std columns 
```R
meanStd_df <- bind_cols(xmerge[,textMean], xmerge[,textStd])
```
Getting the names from the subset meanStd_df
```R
names <- colnames(meanStd_df)
```
Changing the names of variables for a more comprehensive label
```R
p1 <- sub("Acc{1}", "Acceleration", names)
p2 <- sub("fBody{1}", "fourierTrans_Body", p1)
p3 <- sub("tBody{1}", "time_Body", p2)
p4 <- sub("tGrav{1}", "time_Grav", p3)

colnames(meanStd_df) <- p4
```
Merge to create the final data set to work on.
```R
data <- bind_cols(activityName, subject, meanStd_df)
```
Now that we have a complete data set, now we can start our analysis, in this case we want  the average of each variable for each activity and each subject. We will usew the melt() function on the reshape2 package, to create an easy data set to work with.
```R
library(reshape2)

dataMelt <- melt(data, id=c("activityName" ,"Subject"))
```
An example table of the Data that you should get
```R
> head(dataMelt)
  activityName Subject                       variable     value
1     STANDING       2 time_BodyAcceleration-mean()-X 0.2571778
2     STANDING       2 time_BodyAcceleration-mean()-X 0.2860267
3     STANDING       2 time_BodyAcceleration-mean()-X 0.2754848
4     STANDING       2 time_BodyAcceleration-mean()-X 0.2702982
5     STANDING       2 time_BodyAcceleration-mean()-X 0.2748330
6     STANDING       2 time_BodyAcceleration-mean()-X 0.2792199
```

We got our melted data set. We build the final tidy data set using the group_by() and the summarise() functions in the dplyr package. What we are doing is grouping by activity, subject and action (variable) being meassure, and summarising tha data obtainig the mean value. Finaly we change the names of the columns for a more descriptive ones.
```R
final_df <- dataMelt %>% group_by(activityName, Subject, variable) %>% summarise(mean(value))

colnames(final_df) <- c("Activity", "Subject", "Meassure_Variable", "Mean")
```
An example of what we get from this last lines of code in the next table, this would be the tidy data set in a long format, with just for variables (Activity, Subject, Meassure_Variable and Mean)
```R
Source: local data frame [6 x 4]

  Activity Subject                 Meassure_Variable        Mean
1   LAYING       1    time_BodyAcceleration-mean()-X  0.22159824
2   LAYING       1    time_BodyAcceleration-mean()-Y -0.04051395
3   LAYING       1    time_BodyAcceleration-mean()-Z -0.11320355
4   LAYING       1 time_GravityAcceleration-mean()-X -0.24888180
5   LAYING       1 time_GravityAcceleration-mean()-Y  0.70554977
6   LAYING       1 time_GravityAcceleration-mean()-Z  0.44581772
```
If you want you could save the data in a .txt file, for data saving
```R
write.table(final_df, "tidyData.txt", row.name=FALSE)
```
You could change the tidy "format" to a wide form, in my case I wouldnt recomended, even do that is easy to 
We use the function spread() from the tidyr package
```R
library(tidyr)

final_wide <- spread(final_df, key=Meassure Variable, value=Mean)
```

If you wish to download the final tidy data set, just copy this lines of script into your R console.
```R
address <- "https://s3.amazonaws.com/coursera-uploads/user-4b3867938524790c458319eb/973499/asst-3/1a71c9c0cd9a11e4b8381b8ddf9f86ee.txt"
address <- sub("^https", "http", address)
data <- read.table(url(address), header = TRUE) 
View(data)
```
-----------------
##Acknowledgment
The experiment asociated with this data was carried out by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
in the Smartlab - Non Linear Complex Systems Laboratory DITEN - Università degli Studi di Genova. Italy

To our CTA's of the course speccially David Hood
