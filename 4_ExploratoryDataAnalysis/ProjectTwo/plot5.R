# Load necessary libraries for data manipulation, visualization, and string operations
library(dplyr)
library(ggplot2)
library(stringr)

# Load the NEI and SCC datasets from the provided RDS files
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# Filter the SCC dataset to select rows related to motor vehicle sources
# Look for entries in 'SCC.Level.Two' that contain the word "Vehicle" (case-insensitive)
vehicleSCC <- filter(SCC, str_detect(SCC.Level.Two, "[Vv]ehicle"))

# Filter the NEI dataset to include only rows where the SCC is related to motor vehicles
vehicleNEI <- filter(NEI, SCC %in% vehicleSCC$SCC)

# Further filter the NEI dataset to include only data from Baltimore City (FIPS code '24510')
balt_vehicleNEI <- filter(vehicleNEI, fips == "24510")

# Create a ggplot object to visualize motor vehicle emissions in Baltimore over the years
g5 <- ggplot(balt_vehicleNEI, aes(factor(year), Emissions)) +
  # Add a bar plot to visualize total emissions from motor vehicles by year
  geom_bar(stat = "identity") +
  # Apply a clean black-and-white theme with Helvetica font
  theme_bw(base_family = "Helvetica") +
  # Add labels for the axes and the title of the plot
  labs(x = "Years", 
       y = "Total Emissions", 
       title = "Motor Vehicle Sources Emissions in Baltimore from 1999 to 2008")

# Save the plot as a PNG file with a specific size (30x30 cm)
ggsave("plot5.png", g5, width = 30, height = 30, units = "cm")
