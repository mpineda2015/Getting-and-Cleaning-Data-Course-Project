## Course project: Getting and cleaning data
In order to solve the challenge raised in this project, the run_analysis.R script does the following:

### What the script does
1. Download the folder UCI HAR Dataset with the corresponding data if it does not alredy exists in the working directory

2. Loads the main data with the activity and feacture information

3. Loads and merger the training and test datasets, keeping only the columns reflecting a mean or standard deviation (Std)

4. Uses appropiate descriptive activity names to denote the activities in the data set

5. Labels the data set with descriptive variable names.

6. Creates an independent tidy data set with the average of each variable for each activity and each subject.

### How to run the script
In the same folder where the data files are, go to your R enviroment and load the script  using the following command:

source('run_analysis.R')

The end result will be two files called 'Tidy.text' and 'Tidy.csv'.

### Description of the obtained tidy data
Each row contains Subject, Activity, and Mean and Std measures for all feactures.

### Details of the original UCI HAR Dataset
Details of the original dataset can be found in:

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.
Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support
Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012).  Vitoria-Gasteiz, Spain. Dec 2012



