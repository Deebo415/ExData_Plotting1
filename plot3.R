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
# - Three overlaid scatter plots, with lines but no points (type = "l"). The first is "Sub_metering_1", and the color is "black".
# The second is "Sub_metering_2", and the color is "red". The third is "Sub_metering_3", and the color is "blue"
# - No main title
# - X-Axis is labeled the same as in "plot2.R", that is - the defailt is what we want
# - Y-Axis is "Energy sub metering"
# - the legend is in the top right corner
# - this time, we have ot set the limits of the y-axis to 0,

plot(two_days_data$DateTime, two_days_data$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
par(new=T) #this command says "hey, the next thing I plot, overlay it onto the plot I just made
plot(two_days_data$DateTime, two_days_data$Sub_metering_2, type = "l", ylim = c(0,38), xlab = "", ylab = "", col = "red")
# the axis appeared to be *just* short of 40 - so set it to 38 just to match the example exactly. But it might be 39 too. Or neither,
# and I'm just missing the "correct" way to do it
par(new=T)
plot(two_days_data$DateTime, two_days_data$Sub_metering_3, type = "l", ylim = c(0,38), xlab = "", ylab = "", col = "blue")
par(new=F) #now, turn that command off, because we're done putting series of data on this plot

# Add the legend

legend("topright", lwd = 1, col = c("black", "red", "blue"), legend = c("Sub_Metering_1","Sub_Metering_2","Sub_metering_3"))

# Save it off to a PNG file, and turn off that device immediately:

dev.copy(png, "plot3.png")
dev.off()