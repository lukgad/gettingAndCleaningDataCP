## Creates a new tidy data set from UCI Machine Learning Reposity: Human Activity Recognition Using Smartphones Data Set.
## This new data set contains the average of each variable for each activity and each subject from training and test source data.
runAnalysis <- function(directoryName = "UCI HAR Dataset") {
    
    ### BASIC CONFIGURATION ###
    
    ## load packages
    library(dplyr)
    library(sqldf)    
    
    #### TEST DATA ###
    ## load and convert
    xTest <- read.csv(paste(directoryName, "//test/X_test.txt", sep =""), sep = "", header = FALSE)
    yTest <- read.csv(paste(directoryName, "//test/y_test.txt", sep =""), sep = "", header = FALSE)
    yTest <- rename(yTest, LABELID = V1)
    subjectTest <- read.csv(paste(directoryName,"//test/subject_test.txt", sep=""), sep="", header = FALSE)
    subjectTest <- subjectTest %>% rename(SUBJECT = V1) %>% mutate(SUBJECT = as.integer(as.character(SUBJECT)))
    
    ## add id
    xTest <- mutate(xTest, ID = seq(1, nrow(xTest)))
    yTest <- mutate(yTest, ID = seq(1, nrow(yTest)))
    
    ## merge x and y and subject
    xyTest <- merge(yTest, xTest, by.x="ID", by.y="ID", all=FALSE)
    xyTest <- cbind(subjectTest, xyTest)
    
    ## remove x and y
    xTest <- NULL
    yTest <- NULL
    subjectTest <- NULL
    
    ### TRAIN DATA
    
    ## load and convert
    xTraining <- read.csv(paste(directoryName, "//train/X_train.txt", sep =""), sep = "", header = FALSE);
    yTraining <- read.csv(paste(directoryName, "//train/y_train.txt", sep =""), sep = "", header = FALSE);
    yTraining <- rename(yTraining, LABELID=V1)
    subjectTraining <- read.csv(paste(directoryName,"//train/subject_train.txt", sep=""), sep="", header = FALSE)
    subjectTraining <- subjectTraining %>% rename(SUBJECT = V1) %>% mutate(SUBJECT = as.integer(as.character(SUBJECT)))
    
    ## add id
    xTraining <- mutate(xTraining, ID = seq(1, nrow(xTraining)))
    yTraining <- mutate(yTraining, ID = seq(1, nrow(yTraining)))
    
    ## merge x and y and subject
    xyTraining <- merge(yTraining, xTraining, by.x="ID", by.y="ID", all=FALSE)
    xyTraining <- cbind(subjectTraining, xyTraining)
    
    ## remove x and y
    xTraining <- NULL
    yTraining <- NULL 
    subjectTraining <- NULL
    
    ### COMBINING TRAIN AND TEST DATA
    ## remove unused id columns
    
    xyTraining$ID <- NULL
    xyTest$ID <- NULL
    
    ## bind training and test, remove xy data
    allData <- rbind(xyTraining, xyTest)
    xyTraining <- NULL    
    
    ### FEATURES ###
    
    ## extract features
    features <- read.csv(paste(directoryName, "/features.txt", sep =""), sep="", header = FALSE)
    features <- rename(features, FID = V1)
    features <- mutate(features, FEATURE = as.character(V2))
    features$V2 <- NULL
    
    ## add feature names to data
    names(allData)[3:ncol(allData)] <- make.names(features$FEATURE, unique = TRUE, allow_ = TRUE)
    
    ## select only mean and std features
    allData <- select(allData, which(grepl("SUBJECT|LABELID|mean|std", names(allData))))
    
    ### LABELS
    ## load labels
    labels <- read.csv(paste(directoryName, "/activity_labels.txt", sep =""), sep="", header = FALSE)
    labels <- mutate(labels, LABEL = as.character(V2))
    labels <- rename(labels, LID = V1)
    labels$V2 <- NULL
    
    ## add labels to data    
    allData <- sqldf("SELECT l.LABEl, d.* FROM allData d LEFT JOIN labels l ON d.LABELID = l.LID")
    allData$LABELID <- NULL
    allData <- rename(allData, ACTIVITY = LABEL)
    
    ## remove features and labels dfs
    labels <- NULL
    features <- NULL
    
    ## clean data
    cleaned <- allData %>% filter(complete.cases(allData)) %>% arrange(ACTIVITY, SUBJECT)
    # prepare new data set with average values for activity and subject
    result <- cleaned %>% group_by(ACTIVITY, SUBJECT)
    result <- aggregate(result[3:ncol(result)], by = list(ACTIVITY=result$ACTIVITY, SUBJECT=result$SUBJECT), mean)    
    
}
