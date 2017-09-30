#' This script does the following.

#' 1. Merges the training and the test sets to create one data set.
#' 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#' 3. Uses descriptive activity names to name the activities in the data set
#' 4. Appropriately labels the data set with descriptive variable names.
#' 5. From the data set in step 4, creates a second, independent tidy data set
#'    with the average of each variable for each activity and each subject.

# 0 require the appropriate packages
require(dplyr)
require(readr)
require(tidyr)

# 0.bis First read the data

features <- read.csv("ucihardata/features.txt",
                     sep=" ", header=FALSE, 
                     col.names=c("featureid", "featurename"))

activities <- read.csv("ucihardata/activity_labels.txt",
                       sep=" ", header=FALSE,
                       col.names=c("activityid", "activitylabel"))

# read x train and test data
xtrain <- read.csv("ucihardata/train/X_train.txt", sep="", header=FALSE)
xtest <- read.csv("ucihardata/test/X_test.txt", sep="", header=FALSE)

# assign informative names to the features
names(xtrain) <- features$featurename
names(xtest) <- features$featurename

ytrain <- read.csv("ucihardata/train/Y_train.txt",
                   header=FALSE,
                   col.names=c("activityid"))
ytest <- read.csv("ucihardata/test/Y_test.txt",
                  header=FALSE,
                  col.names=c("activityid"))

subjecttrain <- read.csv("ucihardata/train/subject_train.txt", header=F)
subjecttest <- read.csv("ucihardata/test/subject_test.txt", header=F)
names(subjecttrain) <- c("subjectid")
names(subjecttest) <- c("subjectid")


# Now that we've read the data we will merge the train and test set


# 1. Merge training and test sets
#################################


# we will need a variable that shows where the data come from
# we do this by adding an extra column 'dataset' to both xtrain and xtest.
# its value will be 'train' for xtrain and 'test' for xtest
xtrain$dataset <- "train"
xtest$dataset <- "test"

# Now we can merge the ytrain with xtrain, and ytest with xtest
# note that the "merge" is based on the position
alltrain <- bind_cols(subjecttrain, xtrain, ytrain)
alltest <- bind_cols(subjecttest, xtest, ytest)

# Now that we have merged the input and the output,
# we can merge the training and the test data

alldata <- bind_rows(alltrain, alltest)

# As we can sim dim(alldata) gives 10299, 563.
# Which corresponds to the total number of rows, 
# and 563 is 561 features + dataset (train or test) + activityid

#' 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# in order to do this we select the columns that have "mean" or "std" in their
# names, in addition to the two columns that we added
# namely : "dataset" and "activityid"
subdata <- select(alldata, matches("mean|std"), subjectid, dataset, activityid)


# 3. descriptive activity name
# we use an inner join with the previously loaded "activities" dataframe
descriptivedata <- subdata %>% inner_join(activities, by="activityid")

# 4. Already done as we set correctly the variable names in the beginning
#    in step 0.bis

# => Now we have a tidy dataset

#  5. From the data set in step 4, creates a second, independent tidy data set
#     with the average of each variable for each activity and each subject.

# First we group the data by the subjectid and activitylabel variables.

# This form a grouped data structure with 180 groups corresponding
# to the combinations of the 6 activities and the 30 subjects.

# then we summarize for all the columns that or of type double, and 
# apply the 'mean' function for each column

mean.data.by.subject.and.activity <- descriptivedata %>% 
  group_by(dataset, subjectid, activitylabel) %>%
  summarize_if(is.double, mean)