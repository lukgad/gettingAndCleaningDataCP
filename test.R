cat("\014") ## clear screen

dirName <- "UCI HAR Dataset"
allData <- NULL
source('./repo/gettingAndCleaningDataCP/run_analysis.R')
times <- system.time(allData <- runAnalysis(dirName))

## allData
nrow(allData)
ncol(allData)

str(allData)
names(allData)
times
