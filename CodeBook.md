---
title: "Run Analysis CodeBook"
output: html_document
---

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.


trainSub 
    <br><ol>Training Subject Data File</ol>
    
trainTime 
    <br><ol>Training Time Variables Data File (561 Variables/Columns)</ol>

trainActivity 
    <br><ol>Training Activity Data File</ol>
    
trainData 
    <br><ol>Combined data set of trainSub, trainTime, and trainActivity (total of 563 columns) </ol>
    
testSub
    <br><ol>Testing Subject Data File</ol>
    
testTime
    <br><ol>Testing Time Variables Data File (561 Variables/Columns)</ol>
    
testActivity 
    <br><ol>Training Activity Data File</ol>
    
testData
    <br><ol>Combined data set of testSub, testTime, and testActivity (total of 563 columns)</ol>
    
theData
    <br><ol>Combined of training data (trainData) and testing data (testData)</ol>
    
timeLabel
    <br><ol>Labels for Time Variables (561 labels for 561 variables)</ol>

<br>
Assign meaningful labels to each variables/columns
```{r}
    names(theData)[1] <- c("Subject")
    names(theData)[2] <- c("Activity")
    names(theData)[3:563] <- timeLabel[,2]
``` 

<br>
Finds the variable names containing string 'mean' or 'std'
```{r}
    meanCol <- timeLabel[grep("mean()",timeLabel$V2,fixed=TRUE),]
    stdCol <- timeLabel[grep("std()",timeLabel$V2,fixed=TRUE),]
```

<br>
Requirement 2: Extracts only the measurements on the mean and standard deviation for each measurement.
```{r}
subsetData <- theData[,c("Subject","Activity",meanCol$V2,stdCol$V2)]
``` 

<br>
Read in activity labels
```{r}
activityLabel <- read.table("./activity_labels.txt", header=FALSE, stringsAsFactors=FALSE)
``` 

<br>
Requirement 3: Uses descriptive activity names to name the activities in the data set
```{r}
finalData <- merge(subsetData,activityLabel, by.x="Activity", by.y="V1", all=TRUE )
finalData$Activity <- finalData$V2
finalData <- subset(finalData, select=-c(V2))
``` 

<br>
Requirement 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```{r}
sumData<- ddply(finalData, .(Subject, Activity), numcolwise(mean))
write.table(sumData, "tidyData.txt", row.name=FALSE, sep = ",")
```     
    