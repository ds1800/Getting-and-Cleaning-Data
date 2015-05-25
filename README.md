# README.md

## Getting-and-Cleaning-Data
Repo for Getting and Cleaning Data Course at Coursera

## This file describes how the script run_analysis.R works

* The Course Project was developed completely within RStudio Version 0.98.1103 for Macintosh, Intel Mac OS X 10_9_5, working over R version 3.1.2.

* According to the specifications of the Course Project, it was assumed that the files "features.txt" and "activity_labels.txt" are located in the working directory, but the "train" and "test" data were left in their respective subdirectories. If this is not what was intended by the instructor, then the paths of the four files for train and test must be changed in the script, by suppressing the corresponding "/train" and "/test" subdirectories, in lines 21, 25, 29, 33, 37 and 41.

* At the beginning of the script, the three required packages "data.table", "dplyr" and "tidyr" are loaded. The user must manually install these files if they are not previously installed in the system.

* Next, some files were able to be read with the instruction "fread", but this caused the crash of the R system when the larger tables "X_train.txt" and "X_test.txt" were read. Therefore, it was necessary to use the instruction "read.table" instead of "fread" for such files.

* The next three lines, 47-49, actually correspond to Step 3 of the instructor's instructions; namely, the assignment of descriptive activity names to the columns of the files "y.train", "y.test" and "activities".

* The instructions between the lines 51 and 73 simply perform the addition of "activity.name" to each observation of the data tables "y.train" and "y.test".

* Next, the lines 83 and 84 perform the merging of activity name, subject.number and measured observation, for both train and test data, respectively, with the use of the instruction "cbind".

* Line 87 performs the instructor's Step 1; namely, the merge of both train and test data, with the use of the instruction "rbind".

* Instructor's Step 2, namely the extraction of the measurements of means and std's, is performed in line 92. It is important to use the condition: "ignore.case=TRUE" since the names of some columns include "mean" in lowercase whereas others are in uppercase: "Mean".

* Finally, the eight instructions between lines 101 and 108, in the script "run_analysis.R", essentially group the observations by activity.name and subject.number, in order to summarize the final "mean"s of those groups, which constitutes the required file to be uploaded.

* The tidy data file uploaded to github was written with the instruction  write.table(summary, "~/summary.txt", row.name=FALSE). Therefore, the command lines for reading such file and looking at it in RStudio would be: 
    data <- read.table("summary.txt", header = TRUE)     
    View(data)

