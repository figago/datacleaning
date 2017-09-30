# Getting and Cleaning Data - Week 4 Assignment


## Content of the repository


* `README.md` : this file.

* `CodeBook.md` : description of the feature.

* `features.txt` : list of features.

* `run_analysis.R` : R script analyzing the original dataset.


# This week's script does the following.

## 1. Merges the training and the test sets to create one data set from the several files in the original dataset.
We use `dplyr` `bind_rows()` and `bind_cols` to merge the various datasets together.

First we start by reading the activities and the features.
Then we load the train/test "inputs" (`X_train.txt` and `X_test.txt`),
as well as the train/test "outputs" (`Y_train.txt` and `Y_test.txt`).

We merge the train data together, and the test data together.
Then we add a `dataset` column to each that specifies whether a row is 
a training row or a test row.

The we use `bind_cols()` to merge the train and test together.

=> dataframe1


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
Here `dplyr`'s `select` function comes in handy, using a regexp inside
a `match()`, we manage to only keep the columns that contain mean or
standard deviation quantities.

=> dataframe2


## 3. Uses descriptive activity names to name the activities in the data set
A join, or more specifically an inner join is necessary here.
Before hand, we loaded the `activities` dataframe with two columns: 

* activityid

* activitylabel

We only need to call `inner_join()` to join dataframe2 and the activities
dataframe, we join by `activityid` column as it is common to both dataframes. 
This will add a column `activitylabel` to dataframe2.

=> dataframe3


## 4. Appropriately labels the data set with descriptive variable names.
This step was done right after reading the data by assigning the descriptive
set of feature names (read from the file `features.txt`) to `name(dataset)`
for each one of the the training and test set.

=> dataframe4


## 5. Create a tidy data set with the average of each variable for each activity and each subject.
Using chaining capabilities of `dplyr` we `group_by` the dataframe4, 
using the variables `subjectid` and `activitylabel` (and `dataset`)
and then `summarize` the grouped structure, by applying the `mean`
function to all the non-grouping variables, which correspond to the 
feature columns. They happen to be all of type `double`, so using
`summarize_if(is.double, ...)` does the trick.

=> dataframe5


## Result
Now we have a dataset where:

* each row represents one observation of one subject in one activity.

* Each column represents exactly one variable.

* The observational units are in one table.

=> The result is a happy tidy dataset.
