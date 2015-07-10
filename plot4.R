
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

# get global reactive power
global_reactive_power <- household_power_consumption$Global_reactive_power

#get voltage
voltage <- household_power_consumption$Voltage

# get submetering values
sub_metering1 <- household_power_consumption$Sub_metering_1
sub_metering2 <- household_power_consumption$Sub_metering_2
sub_metering3 <- household_power_consumption$Sub_metering_3

# open the png device
png("plot4.png", width=480, height=480)
par(mfrow=c(2,2))

# first plot top left
plot(date_time, global_active_power, type="l", xlab="", ylab="Global Active Power", cex=0.2)
# second plot top right
plot(date_time, voltage, type="l", xlab="datetime", ylab="Voltage")
# third plot bottom left
plot(date_time, sub_metering1, type="l", ylab="Energy Submetering", xlab="")
lines(date_time, sub_metering2, type="l", col="red")
lines(date_time, sub_metering3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2.5, col=c("black", "red", "blue"))
# fourth plot bottom right
plot(date_time, global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")

# close the device
dev.off()