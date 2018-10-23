#Read the data files necessary
library(reshape2)
#setwd("Coursera/Course 3/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset")
activities<-read.table("activity_labels.txt",colClasses = c("integer", "character"))
features<-read.table("features.txt",colClasses = c("integer", "character"))
xtest <- read.table("test/X_test.txt",colClasses = "numeric")
subjectstest <- read.table("test/subject_test.txt",colClasses = "integer")
ytest <- read.table("test/y_test.txt",colClasses = "integer")
xtrain <- read.table("train/X_train.txt",colClasses = "numeric")
subjectstrain <- read.table("train/subject_train.txt",colClasses = "integer")
ytrain <- read.table("train/y_train.txt",colClasses = "integer")

#Merging the training and test data sets
xtesttrain<-rbind(xtest,xtrain) #X data
ytesttrain<-rbind(ytest,ytrain) #Y data
subjectstesttrain<-rbind(subjectstest,subjectstrain) #Subjects data

#Headings for the columns
colnames(xtesttrain) <- features$V2 #Features as headings for x
colnames(ytesttrain) <- "Actnumber" #Activity number for y
colnames(subjectstesttrain) <- "Subnumber" #subjectnumber for subject

#Select mean,std dev coloumns and combine
selectcolsmean<- grep("mean()",colnames(xtesttrain))
selectcolsstddev<- grep("std()",colnames(xtesttrain))
selectcols<-c(selectcolsmean,selectcolsstddev)

#Get all columns from alldata, create new dataset and average
getdata<-xtesttrain[,selectcols]

#Combine all data
alldata<- cbind(ytesttrain, subjectstesttrain,getdata)

#Descriptive names for activities
alldata$Actnumber <- factor(alldata$Actnumber, labels=c("Walking",
"Walking Upstairs", "Walking Downstairs", "Sitting", "Standing","Laying"))

melted = melt(alldata, id = c("Actnumber","Subnumber"))
tidy = dcast(melted, Actnumber+Subnumber ~ variable, mean)
write.table(tidy, "tidy.txt", row.names = FALSE, quote = FALSE)