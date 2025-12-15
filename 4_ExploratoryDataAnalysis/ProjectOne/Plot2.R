library(data.table)
library(lubridate)

# Load the data
power_data <- fread("power.txt", na.strings = "?")

# Filter data for specific dates
date_filter <- c("1/2/2007", "2/2/2007")
filtered_power_data <- power_data[Date %in% date_filter]

# Combine Date and Time, then convert to Date-Time format
combined_datetime <- dmy_hms(paste(filtered_power_data$Date, filtered_power_data$Time), tz = "UTC")

# Set up PNG device for output
output_png <- "plot2.png"
png(output_png, width = 480, height = 480)

# Create the time series plot
plot(
    combined_datetime,
    filtered_power_data$Global_active_power,
    type = "l",
    xlab = "",
    ylab = "Global Active Power (kilowatts)"
)

# Close the graphics device
dev.off()
