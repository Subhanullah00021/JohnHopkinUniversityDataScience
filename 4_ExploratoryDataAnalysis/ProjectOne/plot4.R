# Load necessary libraries
library(data.table)   # For efficient data manipulation
library(lubridate)    # For handling date-time conversions

# Step 1: Load the dataset with missing values represented by "?"
data <- fread("power.txt", na.strings = "?")

# Step 2: Filter the rows for specific dates
filtered_data <- data[data$Date %in% c("1/2/2007", "2/2/2007"), ]

# Step 3: Combine the 'Date' and 'Time' columns, convert to datetime
timestamp <- dmy_hms(paste(filtered_data$Date, filtered_data$Time, sep = " "), tz = "UTC")

# Step 4: Prepare the plotting area with 2x2 grid for multiple plots
png("plot4.png", width = 480, height = 480)  # Set output image file
par(mfrow = c(2, 2))  # Arrange plots in 2 rows and 2 columns

# Plot 1: Global Active Power over time
plot(
    timestamp, 
    filtered_data$Global_active_power, 
    type = "l", 
    xlab = "", 
    ylab = "Global Active Power", 
    main = "Global Active Power"
)

# Plot 2: Voltage over time
plot(
    timestamp, 
    filtered_data$Voltage, 
    type = "l", 
    xlab = "Datetime", 
    ylab = "Voltage", 
    main = "Voltage"
)

# Plot 3: Energy Sub-Metering for three categories over time
plot(
    timestamp, 
    filtered_data$Sub_metering_1, 
    type = "l", 
    xlab = "", 
    ylab = "Energy Sub Metering", 
    col = "black", 
    main = "Energy Sub Metering"
)
lines(timestamp, filtered_data$Sub_metering_2, col = "red")
lines(timestamp, filtered_data$Sub_metering_3, col = "blue")

# Add legend to the third plot
legend(
    "topright", 
    legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
    col = c("black", "red", "blue"), 
    lty = 1, 
    bty = "n"
)

# Plot 4: Global Reactive Power over time
plot(
    timestamp, 
    filtered_data$Global_reactive_power, 
    type = "l", 
    xlab = "Datetime", 
    ylab = "Global Reactive Power", 
    main = "Global Reactive Power"
)

# Save the plot and close the graphical device
dev.off()
