# Load the necessary library for data manipulation
library(dplyr)

# Load the dataset from the provided RDS file
dataset <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

# Data tidying: Select relevant columns (Emissions and year)
# Group the data by year, and calculate the total emissions per year
# Convert the 'year' column into a factor for better plotting
aggregate_data <- dataset %>%
  select(Emissions, year) %>%  # Select only the Emissions and year columns
  group_by(year) %>%           # Group the data by the 'year' column
  mutate(year = factor(year)) %>%  # Convert 'year' to a factor for categorical plotting
  summarise(total_emissions = sum(Emissions))  # Summarize emissions by summing them for each year

# Define the output file for the plot
output_file <- "plot1.png"

# Open the PNG device to save the plot
png(filename = output_file)

# Create the bar plot using base R
with(
  aggregate_data,  # Use the 'aggregate_data' dataframe
  barplot(
    total_emissions,  # Total emissions as the bar heights
    names.arg = year,  # Set the years as the labels on the x-axis
    xlab = "Time Period",  # Label for the x-axis
    ylab = "Emission Levels",  # Label for the y-axis
    main = "Annual Emission Trends"  # Main title for the plot
  )
)

# Close the graphical device to save the plot to the file
dev.off()
