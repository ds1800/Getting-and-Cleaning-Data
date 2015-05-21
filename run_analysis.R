# Script for Course Project on Getting and Cleaning Data
# Run in RStudio with R version 3.1.2
#
# Load required packages
library(data.table)
library(dplyr)
library(tidyr)
#
# Load  "features.txt":
features <- fread("~/features.txt", header=FALSE)
# [ 561 observations of 2 variables ] (feature.number and feature.name)
# The feature vector has duplicate names, so let us construct 
# unique names. Put the result in new column V3 of "features"
features <- mutate(features, V3 = paste(V2, as.character(V1), sep = "_"))  
#
# Load  "activity_labels.txt":
activities <- fread("~/activity_labels.txt", header=FALSE)
# [ 6 observations of 2 variables ] (activity.number and activity.name)
#
# Load  "X_train.txt". "fread" crashes R, so use "read.table"
X.train <- read.table("~/train/X_train.txt", header=FALSE)
# [ 7352 obs. of 561 variables ] (means, std's and others)
#
# Load  "X_test.txt":
X.test <- read.table("~/test/X_test.txt", header=FALSE)
# [ 2947 obs. of 561 variables ] (means, std's and others)
#
# Load  "y_train.txt":
y.train <- fread("~/train/y_train.txt", header=FALSE)
# [ 7352 obs. of 1 variable ] (activity.number)
#
# Load  "y_test.txt":
y.test <- fread("~/test/y_test.txt", header=FALSE)
# [ 2947 obs. of 1 variable ] (activity.number)
#
# Step 3) Use descriptive activity names to name the activities 
#  in the data set
#
setattr(y.train, 'names', c("activity.number"))
setattr(y.test, 'names', c("activity.number"))
setattr(activities, 'names', c("activity.number", "activity.name"))
#
y.test <- 
  # Let us work with "y.test". 
  y.test %>%
  # Include a sequential id...
  data.table(id... = seq_len(nrow(y.test))) %>%
  # because merge does not preserve the order of rows
  merge(activities, by = "activity.number")  %>%
  # so, use id... to restore the order:
  arrange(id...) %>%
  # and drop the helping column "id…":
  select( -id...)
#
# Do the same with "y.train". The merge instruction does not
# preserve the order of rows, so use an index to restore order:
y.train <- 
  y.train %>%
  data.table(id... = seq_len(nrow(y.train))) %>%
# Merge does not preserve the order of rows
  merge(activities, by = "activity.number") %>%
# Restore the order:
  arrange(id...) %>%
# Drop the index column "id…":
  select( -id...)
#
# (Step 4) Put descriptive names as headers of all columns:
setattr(X.test, 'names', features$V3)
setattr(X.train, 'names', features$V3)
setattr(dat1, 'names', c("subject.number"))
setattr(dat2, 'names', c("subject.number"))
#
# Merge activity and subject.number for each observation
#                (activity, subject.number, observation)
dat.train <- cbind(y.train,     dat1,        X.train)
dat.test  <- cbind(y.test,      dat2,        X.test)
#
# (Step 1) Merge both train and test data
dat <- rbind(dat.train, dat.test)
#
# (Step 2) Extract only the measurements on the mean and 
#  standard deviation for each measurement. It is important to 
#  include "ignore.case" for including all "mean's" and "Mean's"
dat.reduced <- select(dat, 1:3, contains("mean", ignore.case=TRUE), 
                      contains("std", ignore.case=TRUE))
#
# "dat.reduced" is the expected answer for the first part
#
# (Step 5) Create a second data set with the average of 
#   each variable for each activity and each subject.
# 
# The resulting data.table "summary" has [180 obs. of 88 variables]
summary <-
  dat.reduced %>%
  select(-contains("activity.number")) %>%
  gather(vars, value, -activity.name, -subject.number) %>%
  group_by(subject.number, activity.name, vars) %>%
  summarise(mean(value)) %>% 
  spread(vars, "mean(value)") %>%
  arrange(activity.name, subject.number)
# "summary" can now be visualized within RStudio with:
# View(summary)
# It is written in the working directory (for upload as a result) with
# write.table(summary, "~/summary.txt", row.name=FALSE)
#
# THE END
#