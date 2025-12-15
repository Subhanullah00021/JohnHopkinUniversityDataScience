# Load necessary libraries for data manipulation and visualization
library(dplyr)
library(ggplot2)

# Load the dataset from the RDS file
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

# Filter the dataset for Baltimore City (FIPS code '24510') 
# and select the relevant columns: type, fips, Emissions, and year
baltimore_emissions_by_type <- NEI %>%
  select(type, fips, Emissions, year) %>%  # Select relevant columns
  filter(fips == '24510')  # Filter data to include only Baltimore City (FIPS 24510)

# Create a ggplot object to visualize emissions by type over the years
# Use 'year' as the x-axis and 'Emissions' as the y-axis, grouped by 'type'
g3 <- ggplot(baltimore_emissions_by_type, aes(factor(year), Emissions, fill = type)) +
  # Add a bar plot with the total emissions for each year and type
  geom_bar(stat = "identity") +
  # Set the theme to a clean black-and-white theme with Helvetica font
  theme_bw(base_family = "Helvetica") +
  # Facet the plot by 'type' with a 2x2 grid
  facet_wrap(. ~ type, nrow = 2, ncol = 2) +
  # Add labels for the axes and title
  labs(x = "Years", 
       y = "Total Emissions", 
       title = "Total Emissions in Baltimore City by Source Types")

# Save the plot to a PNG file with specific dimensions
ggsave("plot3.png", g3, width = 30, height = 30, units = "cm")
