
#Script for Running Analisys

#Download and unzip the files into a local folder
temp <- tempfile()
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl ,temp)
unzip(temp, exdir = "./samsungDat")
unlink(temp)

#Read data into R
xtest <- read.table("./samsungDat/UCI\ HAR\ Dataset/test/X_test.txt", header = F)
ytest <- read.table("./samsungDat/UCI\ HAR\ Dataset/test/Y_test.txt", header = F)

subject_test <- read.table("./samsungDat/UCI\ HAR\ Dataset/test/subject_test.txt", header = F)

xtrain <- read.table("./samsungDat/UCI\ HAR\ Dataset/train/X_train.txt", header = F)
ytrain <- read.table("./samsungDat/UCI\ HAR\ Dataset/train/Y_train.txt", header = F)

subject_train <- read.table("./samsungDat/UCI\ HAR\ Dataset/train/subject_train.txt", header = F)
features <- read.table("./samsungDat/UCI\ HAR\ Dataset/features.txt", header = F)

#Names of activity sets
activity <- read.table("./samsungDat/UCI\ HAR\ Dataset/activity_labels.txt", header = F, colClasses= c("numeric", "character"))

#Load dplyr package to work with the data
library(dplyr)

xtest_df <- tbl_df(xtest)
ytest_df <- tbl_df(ytest)

xtrain_df <- tbl_df(xtrain)
ytrain_df <- tbl_df(ytrain)

#Merge train and test for data (x), label (y) & subject
xmerge <- bind_rows(xtest_df, xtrain_df)
ymerge <- bind_rows(ytest_df, ytrain_df)
subject <- bind_rows(subject_test, subject_train)

#Names to variables according to "features.txt"
colnames(ymerge) <- c("Activities")
colnames(xmerge) <- features$V2
colnames(subject)<- c("Subject")

#Change the names of the activity for a more descriptive name
activityName <- vector()
for(i in 1:length(ymerge$Activities)){
              if(ymerge[i,1]==activity[1,1]){activityName[i] <- activity[1,2]}
              if(ymerge[i,1]==activity[2,1]){activityName[i] <- activity[2,2]}
              if(ymerge[i,1]==activity[3,1]){activityName[i] <- activity[3,2]}
              if(ymerge[i,1]==activity[4,1]){activityName[i] <- activity[4,2]}
              if(ymerge[i,1]==activity[5,1]){activityName[i] <- activity[5,2]}
              if(ymerge[i,1]==activity[6,1]){activityName[i] <- activity[6,2]}
}

activityName <- as.factor(activityName)
activityName <- as.data.frame(activityName)

#Use function grepl() to search for mean and std strings
textMean <- grepl("mean", features$V2)
textStd <- grepl("std", features$V2)

#With logic vectors subset the data set with Mean and Std columns
meanStd_df <- bind_cols(xmerge[,textMean], xmerge[,textStd])

#Getting the names from the subset meanStd_df
names <- colnames(meanStd_df)

#Changing the names of variables for a more comprehensive label
p1 <- sub("Acc{1}", "Acceleration", names)
p2 <- sub("fBody{1}", "fourierTrans_Body", p1)
p3 <- sub("tBody{1}", "time_Body", p2)
p4 <- sub("tGrav{1}", "time_Grav", p3)
colnames(meanStd_df) <- p4

#Merge to create the final data set to work on.
data <- bind_cols(activityName, subject, meanStd_df)

#We use function melt in package reshape2, to rearrenge the data 
library(reshape2)
dataMelt <- melt(data, id=c("activityName" ,"Subject"))

#Finally we group_by() our variables and get the mean value with summarize(), both from dplyr package
final_df <- dataMelt %>% group_by(activityName, Subject, variable) %>% summarise(mean(value))
colnames(final_df) <- c("Activity", "Subject", "Meassure_Variable", "Mean")

#Write the final data set into a .txt file
write.table(final_df, "tidyData.txt", row.name=FALSE)

#you could change the long data set into a wide format, with the function spread() from the tidyr package
library(tidyr)
final_wide <- spread(final_df, key=Meassure_Variable, value=Mean)
