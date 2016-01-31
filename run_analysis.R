# This R script does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, it creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.
#
# For more on dataset see: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


library(plyr)

#Constants
DATA_DIR = "data.raw"
DATA_UNZIPPED_DIR = "data.raw/UCI HAR Dataset"
ZIP_FILE = "data.raw/UCI HAR Dataset.zip"
FILE_URL = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.data = function() {
  
  # Checks for cached data, if it does not exist, download it!
  if (!file.exists(DATA_DIR)) {
    dir.create(DATA_DIR)
  }
    
  if (!file.exists(DATA_UNZIPPED_DIR)) {
    
    message("Downloading raw data...")
    
    download.file(FILE_URL, destfile=ZIP_FILE, method="curl")
    unzip(ZIP_FILE, exdir=DATA_DIR)
  }
}

sb = function(a,b) {
  # String Buider function to concat two strings
  paste(a,b,sep = "")
  }

merge.datasets = function() {
  
  # Merge training and test datasets
  message("reading X_train.txt")
  training.x <- read.table(sb(DATA_UNZIPPED_DIR,"/train/X_train.txt"))
  
  message("reading y_train.txt")
  training.y <- read.table(sb(DATA_UNZIPPED_DIR,"/train/y_train.txt"))
  
  message("reading subject_train.txt")
  training.subject <- read.table(sb(DATA_UNZIPPED_DIR,"/train/subject_train.txt"))
  
  message("reading X_test.txt")
  test.x <- read.table(sb(DATA_UNZIPPED_DIR,"/test/X_test.txt"))
  
  message("reading y_test.txt")
  test.y <- read.table(sb(DATA_UNZIPPED_DIR,"/test/y_test.txt"))
  
  message("reading subject_test.txt")
  test.subject <- read.table(sb(DATA_UNZIPPED_DIR,"/test/subject_test.txt"))
  
  # Merge
  mergedDataset.x <- rbind(training.x, test.x)
  mergedDataset.y <- rbind(training.y, test.y)
  mergedDataset.subject <- rbind(training.subject, test.subject)
  # merge train and test datasets and return
  list(x=mergedDataset.x, y=mergedDataset.y, subject=mergedDataset.subject)
}

extract.mean.std = function(df) {
  
  # Extract the mean, and standard deviation for each measurement.
  features <- read.table(sb(DATA_UNZIPPED_DIR,"/features.txt"))
  
  # Find the mean and std columns
  mean.col <- sapply(features[,2], function(x) grepl("mean()", x, fixed=T))
  std.col <- sapply(features[,2], function(x) grepl("std()", x, fixed=T))
  
  # Extract mean & std colmns from the data
  extractedCols <- df[, (mean.col | std.col)]
  colnames(extractedCols) <- features[(mean.col | std.col), 2]
  extractedCols
}

name.activities = function(df) {
  # Use descriptive activity names to name the activities in the dataset
  colnames(df) <- "activity"
  df$activity[df$activity == 1] = "Walking"
  df$activity[df$activity == 2] = "Walking_UpStairs"
  df$activity[df$activity == 3] = "Walking_DownStairs"
  df$activity[df$activity == 4] = "Sitting"
  df$activity[df$activity == 5] = "Standing"
  df$activity[df$activity == 6] = "Laying"
  df
}

combine.data <- function(x, y, subjects) {
  # Combine mean-std values (x), activities (y) and subjects.
  cbind(x, y, subjects)
}

create.clean.dataset = function(df) {
  cleanData <- ddply(df, .(subject, activity), function(x) colMeans(x[,1:60]))
  cleanData
}

scrub.data = function() {
  
  # Get new data, unless it's already cached data
  download.data()
  
  # merge training and test datasets. 
  mergedData <- merge.datasets()
 
  # Extract only the measurements of the mean and standard deviation
  cx <- extract.mean.std(mergedData$x)
  
  # Name activities
  cy <- name.activities(mergedData$y)
  
  # Use descriptive column name for subjects
  colnames(mergedData$subject) <- c("subject")
  
  # Combine data frames
  combinedData <- combine.data(cx, cy, mergedData$subject)
  
  # Create tidy dataset
  cleanData <- create.clean.dataset(combinedData)
  
  # Write clean data output to disk
  write.csv(cleanData, "UCI_HAR_CleanData.csv", row.names=FALSE)
  
}

# *** Usage Instructions ***
# scrub.data()