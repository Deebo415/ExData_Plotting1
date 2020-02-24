# Script to create "plot2.png" for Coursera - Exploratory Data Analysis - Course Project 1

# Download/unzip the data set, and make it quicker to check first if you've already done that 

if (!file.exists("electric_power_consumption.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","electric_power_consumption.zip", method = "curl")
  unzip("electric_power_consumption.zip")}

# ensure "dplyr" and "data.table" are accesible and ready to go. If you have to install them, say
#"install.packages("dplyr")", "install.packages("data.table")", install.packages("tidyr"), and install.packages("lubridate") 
# respectively at the command prompt:

library(dplyr)
library(data.table)
library(lubridate)
library(tidyr)


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

# Seeming characteristics of this plot
# - A scatter plot, with lines but no points (type = "l")
# - No main title
# - X-Axis is unlabeled, but appears to be the days of the week corresponding to Thu-Fri and Fri-Sat (presumably our two days)
# - ...so I might want to add a column that is the date and time all together, alongside them separately (violates tidy data practices,
# but need it as a helper column. Will remove what I don't need later)

two_days_data <- unite(two_days_data,"DateTime",Date:Time, remove = FALSE)
two_days_data$DateTime <- ymd_hms(two_days_data$DateTime)

# - Y-Axis is "Global Active Power (kilowatts)

plot(two_days_data$DateTime, two_days_data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

# Like before, save it off to a PNG file, and turn off that device immediately:

dev.copy(png, "plot2.png")
dev.off()