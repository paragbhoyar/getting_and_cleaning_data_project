wd <- getwd()
#read subject_test.txt
setwd("test")
subject_test <- read.table("subject_test.txt")
# read y_test.txt
y_test <- read.table("y_test.txt")
#read X_test.txt
x_test <- read.table("X_test.txt")
# combining test data
test_data <- cbind(subject_test,y_test, x_test)
#reset working directory
setwd(wd)
#read subject_train.txt
setwd("train")
subject_train <- read.table("subject_train.txt")
# read y_train.txt
y_train <- read.table("y_train.txt")
#read X_train.txt
x_train <- read.table("X_train.txt")
# combining test data
train_data <- cbind(subject_train,y_train, x_train)
#combining test and train data
combine_data <- rbind(test_data, train_data)
#reset working directory
setwd(wd)
# reading column names from features.txt
features <- read.table("features.txt")
list_features <- as.character(features[,2])
col_names <- c("subject", "activity", list_features)
#changing name of combned data columns
colnames(combine_data) <- col_names
#subsetting mean() and std() column data
data_mean <- combine_data[,grep("mean\\(\\)", 
                                colnames(combine_data))]
data_std <- combine_data[,grep("std\\(\\)", 
                               colnames(combine_data))]
temp_data <- combine_data[,1:2]
filtered_data <- cbind(temp_data,data_mean, data_std)
#reading activity_labels.txt
activity_labels <- read.table("activity_labels.txt")
# using descriptive activity names
for (i in 1:nrow(filtered_data)) {
    temp <- filtered_data[i,2]
    temp <- as.character(activity_labels[temp,2])
    filtered_data[i,2] <- temp
}
# replacing column names with descriptive names
colnames(filtered_data) <- gsub("^t","time", 
                                colnames(filtered_data))
colnames(filtered_data) <- gsub("^f","frequency", 
                                colnames(filtered_data))
colnames(filtered_data) <- gsub("mean\\(\\)","mean", 
                                colnames(filtered_data))
colnames(filtered_data) <- gsub("std\\(\\)","stdev",
                                colnames(filtered_data))
#loading dplyr
library(dplyr)
#grouping by subject and then activity
temp_tbl <- group_by(filtered_data, subject, activity)
#finding average of all columns
temp_tbl <- summarise_all(temp_tbl,mean)
#writing table in txt file
write.table(temp_tbl, file = "tidy_data.txt", row.names = FALSE)








