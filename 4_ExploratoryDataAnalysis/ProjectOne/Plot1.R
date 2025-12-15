library(data.table)
library(lubridate)

# Load data
data <- fread("power.txt", na.strings = "?")

# Filter data by selected dates
selected_dates <- c("1/2/2007", "2/2/2007")
filtered_data <- data[Date %in% selected_dates]

# Set up PNG output
output_file <- "plot1.png"
png(output_file, width = 480, height = 480)

# Create histogram
hist(
    filtered_data$Global_active_power,
    xlab = "Global Active Power (kilowatts)",
    ylab = "Frequency",
    main = "Global Active Power",
    col = "red"
)

# Close the graphics device
dev.off()

