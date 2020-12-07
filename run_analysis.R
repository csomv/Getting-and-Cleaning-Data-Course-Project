# Getting and Cleaning Data Course Project 
# Below code was developped under:
# R version 4.0.2 (2020-06-22) -- "Taking Off Again"
# Windows 8

# Load needed R packages. It is assumed they are installed.
library(dplyr)
library(reshape2)

# Download the data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url = fileUrl, destfile = "./data/data.zip")
dateDownloaded <- date()

# Unzip the compressed .zip file
unzip(zipfile = "./data/data.zip", exdir = "./data")

# Read the data into R
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "")
features <- read.table("./data/UCI HAR Dataset/features.txt", header = FALSE, sep = "")

subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "")
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")

subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "")
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")

### REQUIREMENT #4 ###
# Assign descriptive variable names. For further details about composition of labels, please see CodeBook.md
subject_test <- rename(subject_test, subjectID = V1)
y_test <- rename(y_test, activityCode = V1)
names(X_test) <- features$V2

subject_train <- rename(subject_train, subjectID = V1)
y_train <- rename(y_train, activityCode = V1)
names(X_train) <- features$V2

### REQUIREMENT #2 ###
# Select columns with measurements on the mean and standard deviation
X_test_selected <- select(X_test,grep("mean\\(|std",features$V2))
X_train_selected <- select(X_train,grep("mean\\(|std",features$V2))

### START OF REQUIREMENT #1 ###
# Put together test and train data
test_data <- cbind(subject_test, y_test, X_test_selected)
train_data <- cbind(subject_train, y_train, X_train_selected)

# Create a new variable called set to keep the information if a subject belongs to train or test set
test_data <- mutate(test_data, set = "TEST")
train_data <- mutate(train_data, set = "TRAIN")

# Put together test and train data
all_data <- rbind(test_data,train_data)
### END OF REQUIREMENT #1 ###

### START OF REQUIREMENT #3 ###
# Merge activity labels
all_data <- merge(all_data, activity_labels, by.x = "activityCode", by.y = "V1")

# Rename V2 to activity, replace "_" with " " in activity, re-order columns and drop activityCode column
all_data <- all_data %>% rename(activity = V2) %>% mutate(activity = gsub("_", " ", activity)) %>% select(subjectID, set, activity, 3:68)
### END OF REQUIREMENT #3 ###

### START OF REQUIREMENT #5 ###
tidy_data <- all_data %>%
             # Melting the dataset
             melt(id=c("subjectID","set","activity"), measure.vars = 4:69) %>% 
			 # Tidy dataset (wide form) computing the average of each variable for each activity and each subject
			 dcast(subjectID + set + activity ~ variable, mean)
			   
# Renaming the columns to be more precise about the content
names(tidy_data) <- c(names(tidy_data)[1:3], paste("Average of",names(tidy_data)[4:69]))
### END OF REQUIREMENT #5 ###

# Outputting the tidy dataset
write.table(tidy_data, file = "./data/tidy_data.txt", row.name=FALSE)