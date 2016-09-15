##  packages plyr and memisc are required to run this script
##  check if directory exists and make it if it does not

if (!file.exists("data")) {
        dir.create("data")
}

##  download and unzip dataset

dataurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataurl,destfile="data/dataset.zip")
unzip(zipfile="data/dataset.zip",exdir="data")
dataset_path <- file.path("data" , "UCI HAR Dataset")
files<-list.files(dataset_path, recursive=TRUE)


##  read the relevant data

test_activity_data  <- read.table(file.path(dataset_path, "test" , "Y_test.txt" ),header = FALSE)
train_activity_data <- read.table(file.path(dataset_path, "train", "Y_train.txt"),header = FALSE)
test_subject_data  <- read.table(file.path(dataset_path, "test" , "subject_test.txt"),header = FALSE)
train_subject_data <- read.table(file.path(dataset_path, "train", "subject_train.txt"),header = FALSE)
test_features_data  <- read.table(file.path(dataset_path, "test" , "X_test.txt" ),header = FALSE)
train_features_data <- read.table(file.path(dataset_path, "train", "X_train.txt"),header = FALSE)

## merge test and train data
## combine the rows for each of the test/train pairs

activity_data <- rbind(test_activity_data, train_activity_data)
subject_data <- rbind(test_subject_data, train_subject_data)
features_data <- rbind(test_features_data, train_features_data)

## Give names to the variables

names(subject_data)<-c("subject")
names(activity_data)<- c("activity")
features_names <- read.table(file.path(dataset_path, "features.txt"),head=FALSE)
names(features_data)<- features_names$V2

## Merge columns to get the data.frame for all of the data

combined_data <- cbind(subject_data, activity_data)
all_data <- cbind(features_data, combined_data)

##  Extract only the mean and standard deviation measurements

subset_feature_names<-features_names$V2[grep("mean\\(\\)|std\\(\\)", features_names$V2)]
selected_names<-c(as.character(subset_feature_names), "subject", "activity" )
selected_data<-subset(all_data,select=selected_names)

## Read descriptive activity names from "activity_labels.txt"

activity_labels <- read.table(file.path(dataset_path, "activity_labels.txt"),header = FALSE)

## apply lables to activities

selected_data$activity<-factor(selected_data$activity);
selected_data$activity<- factor(selected_data$activity,labels=as.character(activity_labels$V2))

##  Lable features with descriptive variable names
## prefix t  is replaced by  Time
## Acc is replaced by Accelerometer
## Gyro is replaced by Gyroscope
## prefix f is replaced by Frequency
## Mag is replaced by Magnitude
## BodyBody is replaced by Body

names(selected_data)<-gsub("^t", "Time", names(selected_data))
names(selected_data)<-gsub("^f", "Frequency", names(selected_data))
names(selected_data)<-gsub("Acc", "Accelerometer", names(selected_data))
names(selected_data)<-gsub("Gyro", "Gyroscope", names(selected_data))
names(selected_data)<-gsub("Mag", "Magnitude", names(selected_data))
names(selected_data)<-gsub("BodyBody", "Body", names(selected_data))

## Create and output second tidy data set with the average of each variable for each activity and each subject

library(plyr);
Average_data<-aggregate(. ~subject + activity, selected_data, mean)
Average_data<-Average_data[order(Average_data$subject,Average_data$activity),]
write.table(Average_data, file = "tidydata.txt",row.name=FALSE)

## Generate code book

library(memisc)
book <- codebook(Average_data)
capture.output(book, file="codebook.txt")