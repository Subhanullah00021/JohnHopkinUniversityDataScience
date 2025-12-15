
library(dplyr)

# Read the data
nei_data <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

# Filter data for Baltimore (fips == '24510') and aggregate emissions by year
baltimore_emissions <- nei_data %>%
    filter(fips == "24510") %>%
    select(fips, Emissions, year) %>%
    group_by(year) %>%
    summarize(total_emissions = sum(Emissions), .groups = "drop") %>%
    mutate(year = as.factor(year))

# Create and save the plot
output_image <- "plot2.png"
png(output_image)

# Plot the bar chart
barplot(
    baltimore_emissions$total_emissions,
    names.arg = baltimore_emissions$year,
    col = "skyblue",
    xlab = "Year",
    ylab = "Total Emissions",
    main = "Total PM2.5 Emissions in Baltimore (1999-2008)"
)

# Close the graphic device
dev.off()
