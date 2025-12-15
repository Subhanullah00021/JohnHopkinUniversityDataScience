# Load the necessary library for data manipulation
library(dplyr)

# Load the dataset from the provided RDS file
NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

# Filter the dataset for Baltimore City (FIPS code '24510'), 
# select relevant columns (fips, Emissions, and year), 
# group by year, and summarize total emissions per year
baltimore_data <- NEI %>%
  select(fips, Emissions, year) %>%  # Select the fips, Emissions, and year columns
  filter(fips == '24510') %>%        # Filter data to only include rows for Baltimore City (FIPS 24510)
  group_by(year) %>%                 # Group the data by the 'year' column
  mutate(year = factor(year)) %>%    # Convert 'year' to a factor for categorical plotting
  summarize(total_em = sum(Emissions))  # Summarize emissions by summing them for each year

# Define the output file for the plot
output_file_baltimore <- "plot2.png"

# Open the PNG device to save the plot
png(filename = output_file_baltimore)

# Create the bar plot using base R for Baltimore City emissions over the years
with(
  baltimore_data,  # Use the 'baltimore_data' dataframe
  barplot(
    total_em,  # Total emissions as the bar heights
    names.arg = year,  # Set the years as the labels on the x-axis
    xlab = "Years",  # Label for the x-axis
    ylab = "Emissions",  # Label for the y-axis
    main = "Total Emissions in Baltimore City from 1999 to 2008"  # Main title for the plot
  )
)

# Close the graphical device to save the plot to the file
dev.off()
