# Getting-and-Cleaning-Data-Assignment
Repository for the Coursera Getting and Cleaning Data Project

packages plyr and memisc are required to run this script

The script run_analysis.R performs the following functions:
    -Checks if directory exists and creates it if it does not
    -Downloads and unzips the dataset 
      -Data set url (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
      -Full description of the data set available at the sight where the data was obtained (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
    -Reads the data relevant to the analysis being performed
  -Merges data into a sngle data frame by combining test and train data
  -Extracts only the mean and standard deviation measurements
  -Applys descriptive names to activities
  -Lables features with descriptive variable names
  -Creates and outputs second tidy data set with the average of each variable for each activity and each subject
  -Generates and outputs a codebook
