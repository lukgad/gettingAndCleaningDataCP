cat("\014") ## clear screen

dirName <- "UCI HAR Dataset"
result <- NULL
source('./repo/gettingAndCleaningDataCP/run_analysis.R')
times <- system.time(result <- runAnalysis(dirName))

## allData
nrow(result)
ncol(result)

str(result)
names(result)
times
