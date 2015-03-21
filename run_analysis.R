
runAnalysis <- function(directoryName = "UCI HAR Dataset//") {
    
    ### BASIC CONFIGURATION ###
    
    ## load packages
    library(dplyr)
    library(sqldf)    
    
    ## fix directory name
    if(!substring(directoryName, nchar(directoryName)-1, nchar(directoryName)) == "//") {
        directoryName <- cat(directoryName,"//")
    }
    
    #### TEST DATA ###
    ## load and rename
    xTest <- loadData(directoryName, )
    yTest <- read.csv("UCI HAR Dataset//test/y_test.txt",sep = "", header = FALSE)
    yTest <- rename(yTest, LABELID=V1)
    
    ## add id
    xTest <- mutate(xTest,ID=seq(1,nrow(xTest)))
    yTest <- mutate(yTest,ID=seq(1,nrow(yTest)))
    
    ## merge x and y
    xyTest <- merge(yTest,xTest,by.x="ID",by.y="ID",all=FALSE)
    
    ## remove x and y
    xTest <- NULL
    yTest <- NULL
    
    ### TRAIN DATA
    
    ## load and rename
    xTraining <- read.csv("UCI HAR Dataset//train/X_train.txt", sep = "", header = FALSE);
    yTraining <- read.csv("UCI HAR Dataset//train/y_train.txt", sep = "", header = FALSE);
    yTraining <- rename(yTraining, LABELID=V1)
    
    ## add id
    xTraining <- mutate(xTraining,ID=seq(1,nrow(xTraining)))
    yTraining <- mutate(yTraining,ID=seq(1,nrow(yTraining)))
    
    ## merge x and y
    xyTraining <- merge(yTraining,xTraining,by.x="ID",by.y="ID",all=FALSE)
    
    ## remove x and y
    xTraining <- NULL
    yTraining <- NULL    
    
    ### COMBINING TRAIN AND TEST DATA
    ## remove unused id columns
    
    xyTraining$ID <- NULL
    xyTest$ID <- NULL
    
    ## bind training and test, remove xy data
    allData <- rbind(xyTraining, xyTest)
    xyTraining <- NULL    
    
    ### FEATURES ###
    
    ## extract features
    features <- read.csv("UCI HAR Dataset/features.txt", sep="", header = FALSE)
    features <- rename(features, FID = V1)
    features <- mutate(features, FEATURE = as.character(V2))
    features$V2 <- NULL
    
    ## add feature names to data
    names(allData)[2:ncol(allData)] <- make.names(features$FEATURE, unique = TRUE, allow_ = TRUE)
    
    ## select only mean and std features
    allData <- select(allData, which(grepl("LABELID|mean|std",names(allData))))
    
    ### LABELS
    ## load labels
    labels <- read.csv("UCI HAR Dataset/activity_labels.txt",sep="", header = FALSE)
    labels <- mutate(labels, LABEL=as.character(V2))
    labels <- rename(labels, LID=V1)
    labels$V2 <- NULL
    
    ## add labels to data
    library(sqldf)
    
    allData <- sqldf("SELECT l.LABEl, d.* FROM allData d LEFT JOIN labels l ON d.LABELID = l.LID")
    allData$LABELID <- NULL
    
    
    
    
    
    
    
}
