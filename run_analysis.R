###Read the files into Path###
if(!file.exists("./Project")){dir.create("./Project")}
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="./Project/Coursera_Project.zip",method="curl")
unzip(zipfile="./Project/Coursera_Project.zip",exdir="./Project")
path_files <- file.path("./Project" , "UCI HAR Dataset")
###Load file data into variables###
testdata  <- read.table(file.path(path_files, "test" , "y_test.txt" ),header = FALSE)
traindata <- read.table(file.path(path_files, "train", "y_train.txt"),header = FALSE)
traindata_sub <- read.table(file.path(path_files, "train", "subject_train.txt"),header = FALSE)
testdata_sub  <- read.table(file.path(path_files, "test" , "subject_test.txt"),header = FALSE)
testdata_feat  <- read.table(file.path(path_files, "test" , "x_test.txt" ),header = FALSE)
traindata_feat <- read.table(file.path(path_files, "train", "x_train.txt"),header = FALSE)
featuresnames <- read.table(file.path(path_files, "features.txt"),head=FALSE)

###Merge Data###
subject <- rbind(traindata_sub, testdata_sub)
activity <- rbind(traindata, testdata)
features <- rbind(traindata_feat, testdata_feat)


###Name Variables###
names(subject)<-c("Subject")
names(activity)<-c("Activity")
names(features)<- featuresnames$V2

###Create Dataset###
combine <- cbind(subject, activity)
dataset <- cbind(features, combine)


###Mean and Standard Deviation###
mean_std <- featuresnames$V2[grep("mean\\(\\)|std\\(\\)", featuresnames$V2)]
naming <-c(as.character(mean_std), "Subject", "Activity" )
dataset <-subset(dataset, select=naming)


###Descriptive Activity Names###
activityNames <- read.table(file.path(path_files, "activity_labels.txt"),header = FALSE)
dataset$Activity <- factor(dataset$Activity,labels=activityNames[,2])
head(dataset$Activity,30)

###Labels for Variable Names###
names(dataset)<-gsub("^t", "Time", names(dataset))
names(dataset)<-gsub("BodyBody", "Body", names(dataset))
names(dataset)<-gsub("Gyro", "Gyroscope", names(dataset))
names(dataset)<-gsub("^f", "Frequency", names(dataset))
names(dataset)<-gsub("Mag", "Magnitude", names(dataset))
names(dataset)<-gsub("Acc", "Accelerometer", names(dataset))

View(dataset)

###2nd Tidy Data Set###
dataset2 <-aggregate(. ~Subject + Activity, dataset, mean)
dataset2 <- dataset2[order(dataset2$Subject,dataset2$Activity),]
write.table(dataset2, file = "tidydataset.txt",row.name=FALSE,quote = FALSE, sep = '\t')

##End###

