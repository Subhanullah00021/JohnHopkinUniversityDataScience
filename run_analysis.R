# Below is what this script does
# 1. Merges the training and test datasets into one.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities.
# 4. Appropriately labels the dataset with descriptive variable names.
# 5. Creates a second tidy dataset with the average of each variable for each activity and subject.

# Load necessary packages
if (!require("pacman")) {
    install.packages("pacman")
}
pacman::p_load(data.table, reshape2, gsubfn)

# Set working directory and download data
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "data.zip"))
unzip(zipfile = "data.zip")

# Load activity labels and feature names
activity_labels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"),
                         col.names = c("id", "activity_name"))

features <- fread(file.path(path, "UCI HAR Dataset/features.txt"),
                  col.names = c("index", "feature_name"))

# Filter features for mean and standard deviation measurements
selected_features <- grep("(mean|std)\\(\\)", features[, feature_name])
selected_measurements <- features[selected_features, feature_name]

# Clean up feature names
cleaned_measurements <- gsubfn(
    "(^t|^f|Acc|Gyro|Mag|BodyBody|\\(\\))",
    list(
        "t" = "Time",
        "f" = "Frequency",
        "Acc" = "Accelerometer",
        "Gyro" = "Gyroscope",
        "Mag" = "Magnitude",
        "BodyBody" = "Body",
        "()" = ""
    ),
    selected_measurements
)

# Load training data and apply feature filter
train_data <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, selected_features, with = FALSE]
setnames(train_data, colnames(train_data), cleaned_measurements)

train_labels <- fread(file.path(path, "UCI HAR Dataset/train/y_train.txt"), col.names = "activity_id")
train_subjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt"), col.names = "subject_id")

# Combine train data with activity and subject info
train_data <- cbind(train_labels, train_subjects, train_data)

# Load test data and apply feature filter
test_data <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, selected_features, with = FALSE]
setnames(test_data, colnames(test_data), cleaned_measurements)

test_labels <- fread(file.path(path, "UCI HAR Dataset/test/y_test.txt"), col.names = "activity_id")
test_subjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt"), col.names = "subject_id")

# Combine test data with activity and subject info
test_data <- cbind(test_labels, test_subjects, test_data)

# Merge training and test datasets
combined_data <- rbind(train_data, test_data)

# Convert activity IDs to descriptive activity names
combined_data[["activity_id"]] <- factor(combined_data[["activity_id"]],
                                         levels = activity_labels[["id"]],
                                         labels = activity_labels[["activity_name"]])

# Convert subject IDs to factors
combined_data[["subject_id"]] <- as.factor(combined_data[["subject_id"]])

# Reshape the data: melt to long format and then calculate mean for each subject and activity
long_data <- melt.data.table(combined_data, id = c("subject_id", "activity_id"))
tidy_data <- dcast(long_data, subject_id + activity_id ~ variable, mean)

# Save the tidy dataset to a file
fwrite(tidy_data, file = "tidyData.txt")
