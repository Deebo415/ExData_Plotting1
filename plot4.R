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
two_days_data <- unite(two_days_data,"DateTime",Date:Time, remove = FALSE)
two_days_data$DateTime <- ymd_hms(two_days_data$DateTime)

# Seeming characteristics of this plot
# - Right, so it looks like 4 plots set up in quadrants. But, lucky for us, it appears that two of them are already the ones 
# we'd created in "plot2.R" and "plot3.R", for the most part

par(mfrow = c(2,2)) # this should give us 4 plots in a 2 x 2 formation. It'll fill from top left, then top right,
                    # then bottom left, then bottom right 

# TOP LEFT PLOT
# copy the code from "plot2.R", except that the y-axis label is just "Global Active Power
plot(two_days_data$DateTime, two_days_data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")

# TOP RIGHT PLOT
# new plot. Appears to just be a simple time vs. Voltage plot, with "datetime" as the x-label, and "Voltage" as the y-label
plot(two_days_data$DateTime, two_days_data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

# BOTTOM LEFT PLOT
# This is the exact plot from "plot3.R"
plot(two_days_data$DateTime, two_days_data$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
par(new=T)
plot(two_days_data$DateTime, two_days_data$Sub_metering_2, type = "l", ylim = c(0,38), xlab = "", ylab = "", col = "red")
par(new=T)
plot(two_days_data$DateTime, two_days_data$Sub_metering_3, type = "l", ylim = c(0,38), xlab = "", ylab = "", col = "blue")
par(new=F)
legend("topright", inset = 0.05,  lwd = 1, box.lty = 0, col = c("black", "red", "blue"), 
       legend = c("Sub_Metering_1","Sub_Metering_2","Sub_metering_3"), cex = 0.75) 
# This is to get rid of the box around the legend and move it out of the corner a bit to atch the example

# BOTTOM RIGHT PLOT
# the other new plot. Appears to be another simple one similar to the top right one. DateTime vs. Global Reactive Power
plot(two_days_data$DateTime, two_days_data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")

# Save it off to a PNG file, and turn off that device immediately:

dev.copy(png, "plot4.png")
dev.off()