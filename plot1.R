# Script to create "plot1.png" for Coursera - Exploratory Data Analysis - Course Project 1

# Download/unzip the data set, and make it quicker to check first if you've already done that 

if (!file.exists("electric_power_consumption.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","electric_power_consumption.zip", method = "curl")
  unzip("electric_power_consumption.zip")}

# ensure "dplyr" and "data.table" are accesible and ready to go. If you have to install them, say
#"install.packages("dplyr")", "install.packages("data.table")", and install.packages("lubridate") 
# respectively at the command prompt:

library(dplyr)
library(data.table)
library(lubridate)


# Read the data in. Set the column classes upfront. Used the information from the assignment sheet
# to set any "?"s to "NA" 

housepowerdata <- fread("household_power_consumption.txt", stringsAsFactors = FALSE, 
                  na.strings = "?", colClasses = c("character", "character", "numeric", 
                  "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

# Format the Date/Time columns:

housepowerdata$Date <- as.Date(housepowerdata$Date, "%d/%m/%Y")
housepowerdata$Time <- times(housepowerdata$Time)

# Filter out the two days needed for this assignment:

two_days_data <- filter(housepowerdata, housepowerdata$Date == "2007-02-01"
                        |housepowerdata$Date == "2007-02-02")

# Right, so the first plot needed appears to be:
# - A histogram (This wasn't obvious at first - I was thinking "frequency" in dealing with AC power)
# - Main title is "Global Active Power"
# - X-Axis is "Global Active Power (kilowatts)
# - Y-Axis is "Frequency" (a unit isn't defined) - so this must mean the "freq" argument is "TRUE"
# - There are 12 "bins", at 0.5 kW intervals (seems to already be defined as default)

hist(two_days_data$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)",
     freq = TRUE, col = "red")

# ...and that looks good, so save it off to a PNG file, being sure to turn that device off immediately afterward:

dev.copy(png, "plot1.png")
dev.off()