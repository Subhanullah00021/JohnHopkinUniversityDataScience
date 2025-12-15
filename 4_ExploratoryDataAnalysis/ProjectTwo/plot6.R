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

# Filter the NEI dataset for data from Baltimore City (fips == "24510") and Los Angeles County (fips == "06037")
balt_la <- vehicleNEI %>% filter(fips %in% c("24510", "06037"))

# Create custom labels for the facet_grid to label the two cities more meaningfully
facet_labels <- as_labeller(c(`24510` = "Baltimore City", `06037` = "Los Angeles County"))

# Create a ggplot object to visualize motor vehicle emissions for both cities over the years
g6 <- ggplot(balt_la, aes(factor(year), Emissions, fill = fips)) +
  # Add a bar plot to visualize total emissions from motor vehicles by year and fips
  geom_bar(stat = "identity") +
  # Apply a clean black-and-white theme with Helvetica font
  theme_bw(base_family = "Helvetica") +
  # Facet the plot by fips (Baltimore City and Los Angeles County) with custom labels
  facet_grid(. ~ fips, labeller = facet_labels) +
  # Add labels for the axes and the title of the plot
  labs(x = "Years", 
       y = "Total Emissions", 
       title = "Motor Vehicle Emissions Between Baltimore & LA County from 1999 to 2008")

# Save the plot as a PNG file with a specific size (30x30 cm)
ggsave("plot6.png", g6, width = 30, height = 30, units = "cm")
