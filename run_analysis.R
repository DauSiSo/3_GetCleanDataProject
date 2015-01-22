library(reshape2)
library(plyr)

setwd("C:/My_Data/Coursera/DataScience/3_GetCleanData/Project/UCI HAR Dataset")

#Read in training data for subject, activity, and data set, 
#and make one data.frame
setwd("./train")
trainSub <- read.table("./subject_train.txt", header=FALSE)
trainTime <- read.table("./X_train.txt", header=FALSE)
trainActivity <- read.table("./y_train.txt", header=FALSE)
trainData <- cbind(trainSub, trainActivity, trainTime)

#Read in testing data for subject, activity, and data set, 
#and make one data.frame
setwd("../test")
testSub <- read.table("./subject_test.txt", header=FALSE)
testTime <- read.table("./X_test.txt", header=FALSE)
testActivity <- read.table("./y_test.txt", header=FALSE)
testData <- cbind(testSub, testActivity, testTime)

#Requirement 1: Merges training and testing data into one data set
theData <- rbind(trainData, testData)

#Read in feature labels for data set, total 561 columns
setwd("../")
timeLabel <- read.table("./features.txt", header=FALSE, stringsAsFactors=FALSE)

#Requirement 4: Appropriately labels the data set with descriptive variable names.
names(theData)[1] <- c("Subject")
names(theData)[2] <- c("Activity")
names(theData)[3:563] <- timeLabel[,2]

#finds the variable names containing string 'mean' or 'std'
meanCol <- timeLabel[grep("mean()",timeLabel$V2,fixed=TRUE),]
stdCol <- timeLabel[grep("std()",timeLabel$V2,fixed=TRUE),]

#Requirement 2: Extracts only the measurements on the mean and standard deviation for each measurement.
subsetData <- theData[,c("Subject","Activity",meanCol$V2,stdCol$V2)]

#Read in activity labels
activityLabel <- read.table("./activity_labels.txt", header=FALSE, stringsAsFactors=FALSE)

#Requirement 3: Uses descriptive activity names to name the activities in the data set
finalData <- merge(subsetData,activityLabel, by.x="Activity", by.y="V1", all=TRUE )
finalData$Activity <- finalData$V2
finalData <- subset(finalData, select=-c(V2))
names(finalData)

#Requirement 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
sumData<- ddply(finalData, .(Subject, Activity), numcolwise(mean))
write.table(sumData, "tidyData.txt", row.name=FALSE, sep = ",")
names(sumData)

