# Load necessary libraries for data manipulation, visualization, and string operations
library(dplyr)
library(ggplot2)
library(stringr)

# Load the NEI and SCC datasets from the provided RDS files
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

# Filter the SCC dataset to select rows related to coal combustion sources
# Look for entries in 'SCC.Level.One' that contain the word "Comb"
# and in 'SCC.Level.Three' and 'SCC.Level.Four' that contain the word "Coal"
SCC_coal_comb <- SCC %>%
    filter(str_detect(SCC.Level.One, "[Cc]omb")) %>%  # Match "Comb" (case-insensitive) in SCC.Level.One
    filter(str_detect(SCC.Level.Three, "[Cc]oal")) %>% # Match "Coal" (case-insensitive) in SCC.Level.Three
    filter(str_detect(SCC.Level.Four, "[Cc]oal"))     # Match "Coal" (case-insensitive) in SCC.Level.Four

# Filter the NEI dataset to include only data with SCC codes related to coal combustion sources
NEI_coal_comb <- filter(NEI, SCC %in% SCC_coal_comb$SCC)  # Select rows where SCC matches coal combustion sources

# Create a ggplot object to visualize emissions from coal combustion sources over the years
g4 <- ggplot(NEI_coal_comb, aes(factor(year), Emissions)) +
  # Add a bar plot to visualize total emissions by year for coal combustion sources
  geom_bar(stat = "identity") +
  # Apply a clean black-and-white theme with Helvetica font
  theme_bw(base_family = "Helvetica") +
  # Add labels for the axes and the title of the plot
  labs(x = "Years", 
       y = "Total Emissions", 
       title = "Coal Combustion Source Emissions Across US from 1999 to 2008")

# Save the plot as a PNG file with a specific size (30x30 cm)
ggsave("plot4.png", g4, width = 30, height = 30, units = "cm")
