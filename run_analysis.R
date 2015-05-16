
## Coursera Getting and Cleaning Data Course Project

# runAnalysis.r File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

R version 3.1.3 (2015-03-09) -- "Smooth Sidewalk"
Copyright (C) 2015 The R Foundation for Statistical Computing
Platform: x86_64-w64-mingw32/x64 (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

[Workspace loaded from ~/.RData]

#clean the workspace
> rm(list=ls())

# 1. Merge the training and the test sets to create one data set.
#set working directory to the UCI HAR Dataset folder

> setwd('C:/Users/pavitra.balekai/Documents/UCI HAR Dataset/')

# perform read operation from the files in the folder

> features = read.table('./features.txt',header=FALSE); 
> activityType = read.table('./activity_labels.txt',header=FALSE);
> subjectTrain = read.table('./train/subject_train.txt',header=FALSE);
> xTrain       = read.table('./train/x_train.txt',header=FALSE); 
> 
> yTrain       = read.table('./train/y_train.txt',header=FALSE);
> xTrain       = read.table('./train/x_train.txt',header=FALSE); 

#assign column names

> colnames(activityType)  = c('activityId','activityType');
> colnames(subjectTrain)  = "subjectId";
> colnames(xTrain)        = features[,2]; 
> colnames(yTrain)        = "activityId";

#merge YTrain, XTrain and SubjectTrain

> trainingData = cbind(yTrain,subjectTrain,xTrain);

#read the data in the test folder

> subjectTest = read.table('./test/subject_test.txt',header=FALSE);
> xTest       = read.table('./test/x_test.txt',header=FALSE);
> yTest       = read.table('./test/y_test.txt',header=FALSE);
> colnames(subjectTest) = "subjectId";
> colnames(xTest)       = features[,2]; 

# assign column names 

> colnames(yTest)       = "activityId";

#merge xTest, yTest and subjectTest

> testData = cbind(yTest,subjectTest,xTest);

#merge training and test data

> finalData = rbind(trainingData,testData);

#create a vector for the column names from finalData

> colNames  = colnames(finalData); 

#2 Extract only the measurements on the mean and standard deviation for each measurement. 

> logicalVector = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-

mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-

std..",colNames) & !grepl("-std()..-",colNames));
> 
#subset the final data

> finalData = finalData[logicalVector==TRUE];
> 
> colNames = colnames(finalData);

# 3. Use descriptive activity names to name the activities in the data set
# merge finaldata with activitytable

> finalData = merge(finalData,activityType,by='activityId',all.x=TRUE);

#update column names
> colNames  = colnames(finalData); 

# 4. Appropriately label the data set with descriptive activity names. 

> for (i in 1:length(colNames)) 
+ {
+     colNames[i] = gsub("\\()","",colNames[i])
+     colNames[i] = gsub("-std$","StdDev",colNames[i])
+     colNames[i] = gsub("-mean","Mean",colNames[i])
+     colNames[i] = gsub("^(t)","time",colNames[i])
+     colNames[i] = gsub("^(f)","freq",colNames[i])
+     colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
+     colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
+     colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
+     colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
+     colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
+     colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
+     colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
+ };

# assign new column names

> colnames(finalData) = colNames;

# 5. Create a second, independent tidy data set with the average of each variable for each 

activity and each subject. 


> finalDataNoActivityType  = finalData[,names(finalData) != 'activityType'];
> tidyData    = aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) != c

('activityId','subjectId')],by=list(activityId=finalDataNoActivityType$activityId,subjectId = 

finalDataNoActivityType$subjectId),mean);
> 
> tidyData    = merge(tidyData,activityType,by='activityId',all.x=TRUE);

# Export the tidyData set 

> write.table(tidyData, './tidyData.txt',row.names=TRUE,sep='\t');
