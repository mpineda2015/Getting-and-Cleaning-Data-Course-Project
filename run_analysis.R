## The following R script is able to merge data from a number of 
## .txt files from a folder called UCI HAR Dataset and produces 
##  a tidy data that can be used for further analysis

library(dplyr)
library(data.table)

## Download and then unzip the dataset:
filename <- "dataset.zip"
if (!file.exists(filename)){fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, filename, method="curl")
}
if (!file.exists("UCI HAR Dataset")) {
    unzip(filename)
}

##Reading the main data
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
feacturesNames <- read.table("UCI HAR Dataset/features.txt")
newfeactureNames <-  feacturesNames[,2] ## Read the dataframe's column names

##Reading treaning data
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
feactureTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)

##Reading test data
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
feactureTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)

##PART 1: Merging the training and the test sets to create one data set. 
totalActivity <- rbind(activityTrain, activityTest)
totalFeacture <- rbind(feactureTrain, feactureTest)
totalSubject <- rbind(subjectTrain, subjectTest)
colnames(totalFeacture) <- newfeactureNames
colnames(totalSubject) <- "Subject"
colnames(totalActivity) <- "Activity"
totalData <- cbind(totalFeacture,totalActivity,totalSubject)

#PART 2: Extracting only the measurements on the mean and standard deviation for each measurement.
col_with_mean <- grep('std|mean\\(\\)',names(totalData),ignore.case=TRUE)
totalColumns <- c(col_with_mean,562,563)
extracted_meanstd <- totalData[,totalColumns]

#PART 3: Using descriptive activity names to name the activities in the data set
extracted_meanstd$Activity <- as.character(extracted_meanstd$Activity)
extracted_meanstd$Activity[extracted_meanstd$Activity == 1] <- "Walking"
extracted_meanstd$Activity[extracted_meanstd$Activity == 2] <- "Walking Upstairs"
extracted_meanstd$Activity[extracted_meanstd$Activity == 3] <- "Walking Downstairs"
extracted_meanstd$Activity[extracted_meanstd$Activity == 4] <- "Sitting"
extracted_meanstd$Activity[extracted_meanstd$Activity == 5] <- "Standing"
extracted_meanstd$Activity[extracted_meanstd$Activity == 6] <- "Laying"
extracted_meanstd$Activity <- as.factor(extracted_meanstd$Activity)

#PART 4: Appropriately labeling the data set with descriptive variable names.
names(extracted_meanstd)<-gsub("gravity", "Gravity", names(extracted_meanstd))
names(extracted_meanstd)<-gsub("Acc", "Accelerometer", names(extracted_meanstd))
names(extracted_meanstd)<-gsub("angle", "Angle", names(extracted_meanstd))
names(extracted_meanstd)<-gsub("BodyBody", "Body", names(extracted_meanstd))
names(extracted_meanstd)<-gsub("-freq()", "Frequency", names(extracted_meanstd))
names(extracted_meanstd)<-gsub("Mag", "Magnitude", names(extracted_meanstd))
names(extracted_meanstd)<-gsub("-std()", "Std", names(extracted_meanstd))
names(extracted_meanstd)<-gsub("^t", "Time", names(extracted_meanstd))
names(extracted_meanstd)<-gsub("-mean()", "Mean", names(extracted_meanstd))
names(extracted_meanstd)<-gsub("^f", "Frequency", names(extracted_meanstd))
names(extracted_meanstd)<-gsub("-X", "X", names(extracted_meanstd))
names(extracted_meanstd)<-gsub("-Y", "Y", names(extracted_meanstd))
names(extracted_meanstd)<-gsub("-Z", "Z", names(extracted_meanstd))
names(extracted_meanstd)<-gsub("[()]", "", names(extracted_meanstd))


#PART 5: Creating an independent tidy data set with the average of each variable
#for each activity and each subject.
extracted_meanstd.dt <- data.table(extracted_meanstd)
tidyData <- extracted_meanstd.dt[, lapply(.SD, mean), by = 'Subject,Activity']
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
write.csv(tidyData, file = "Tidy.csv", row.names = FALSE)
