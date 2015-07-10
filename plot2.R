
# make sure the sqldf package is installed.
# this is to make sure we read only the rows from the data file that match dates
install.packages("sqldf")
library(sqldf)

# dataset url to UC Irvine's Electric Power Consumption
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# download destination file name
file_dest <- "household_power_consumption.zip"

# download the file
download.file(url, file_dest, method = "curl")

# unzip the downloaded file
unzip(file_dest)

# read in the data from the file for only those rows that match the given dates
household_power_consumption <- read.csv.sql("household_power_consumption.txt", sep = ";",
                                            sql = "select * from file where Date='1/2/2007' or Date='2/2/2007'", eol = "\n")

#str(household_power_consumption)

# get datetime
date_time <- strptime(
  paste(household_power_consumption$Date, household_power_consumption$Time, sep=" "), 
  "%d/%m/%Y %H:%M:%S") 

# get only global active power
global_active_power <- household_power_consumption$Global_active_power

# open the png device
png("plot2.png", width=480, height=480)

# plot to device
plot(date_time, global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")

# close the device
dev.off()