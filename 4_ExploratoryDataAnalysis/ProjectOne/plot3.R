library(data.table)
library(lubridate)

# Load the data from the file, treating '?' as missing values
power_data <- fread("power.txt", na.strings = "?")

# Filter data for the specific dates of interest
date_filter <- c("1/2/2007", "2/2/2007")
filtered_power_data <- power_data[Date %in% date_filter]

# Combine Date and Time columns and convert to Date-Time format
combined_datetime <- dmy_hms(paste(filtered_power_data$Date, filtered_power_data$Time), tz = "UTC")

# Set up PNG device to save the plot
output_png <- "plot3.png"
png(output_png, width = 480, height = 480)

# Create the plot for Sub_metering_1 (black line)
plot(
    combined_datetime,
    filtered_power_data$Sub_metering_1,
    type = "l",               # Line plot
    xlab = "",                # No label for x-axis
    ylab = "Energy sub metering"  # Label for y-axis
)

# Add Sub_metering_2 (red line) to the existing plot
lines(combined_datetime, filtered_power_data$Sub_metering_2, col = "red")

# Add Sub_metering_3 (blue line) to the existing plot
lines(combined_datetime, filtered_power_data$Sub_metering_3, col = "blue")

# Add a legend to the top right corner of the plot
legend(
    "topright",                                # Position of the legend
    legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),  # Legend labels
    col = c("black", "red", "blue"),           # Colors of the lines
    lty = 1,                                   # Line type (solid)
    lwd = 1                                    # Line width
)

# Close the graphics device and save the plot
dev.off()
