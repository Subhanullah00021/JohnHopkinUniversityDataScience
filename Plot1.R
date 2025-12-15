library(data.table)
library(lubridate)

# Load the data, handle missing values
data <- fread("power.txt", na.strings = "?")

# Subset data for specific dates
filtered_data <- data[Date %in% c("1/2/2007", "2/2/2007")]

# Set up the output image file
output_file <- "plot1.png"
png(output_file, width = 480, height = 480)

# Plot the histogram with customized aesthetics
with(filtered_data, {
    hist(Global_active_power, 
         col = "red", 
         xlab = "Global Active Power (kilowatts)", 
         ylab = "Frequency", 
         main = "Global Active Power"
    )
})

# Close the graphic device
dev.off()
