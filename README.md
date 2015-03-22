# Getting And Cleaning Data - Cleaning and Tyding Human Activity Recognition Using Smartphones Data Set

This reposity contains tools to extract average of feature variable from training and test data sets in UCI Machine Learning Reposity: Human Activity Recognition Using Smartphones Data Set.

Original data set is present here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones .

This script:

- extracts data from two data sets: training and test data sets.
- combines subject, activity labels and measurments for training and data sets. It results in two complete data sets: one for training data and one for test data.
- combines training and test data into one data sets
- replaces column names with readable ones using source data from ```feature.txt``` file.
- replaces numeric values in ACTIVITY column with activity names taken from ```activity_labels.txt``` file.
- select only mean and std measurments into data frame
- resulting data frame is used to create a tidy data set
 - data is cleaned, only complete cases are taken
 - values are arragned ascending by ACTIVITY and SUBJECT
 - scripts then calculates mean values for every measurment each activty and each subject
 
To run this script you need:

- install R packages: dplyr and sqldf
- clone this repository and checkout master branch
- source script ```run_analysis.R```
- run function ```runAnalysis(directoryName)```
 - argument ```directoryName``` is character string. It expects a directory name of UCI Machine Learning data in your working directory. It should contain this structure:
 ```
    ├── activity_labels.txt
    ├── features_info.txt
    ├── features.txt
    ├── README.txt
    ├── test
    │   ├── Inertial Signals
    │   │   ├── body_acc_x_test.txt
    │   │   ├── body_acc_y_test.txt
    │   │   ├── body_acc_z_test.txt
    │   │   ├── body_gyro_x_test.txt
    │   │   ├── body_gyro_y_test.txt
    │   │   ├── body_gyro_z_test.txt
    │   │   ├── total_acc_x_test.txt
    │   │   ├── total_acc_y_test.txt
    │   │   └── total_acc_z_test.txt
    │   ├── subject_test.txt
    │   ├── X_test.txt
    │   └── y_test.txt
    └── train
        ├── Inertial Signals
        │   ├── body_acc_x_train.txt
        │   ├── body_acc_y_train.txt
        │   ├── body_acc_z_train.txt
        │   ├── body_gyro_x_train.txt
        │   ├── body_gyro_y_train.txt
        │   ├── body_gyro_z_train.txt
        │   ├── total_acc_x_train.txt
        │   ├── total_acc_y_train.txt
        │   └── total_acc_z_train.txt
        ├── subject_train.txt
        ├── X_train.txt
        └── y_train.txt
   ```
   Default value for this argument is ```UCI HAR Dataset```. If your directory name is the same, you don't need to provide it.

