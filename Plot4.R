# Getting the Data

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
data <- read.table(unz(temp, "household_power_consumption.txt"), sep=";", stringsAsFactors = FALSE, header = TRUE, )
unlink(temp)

# Checking that's OK

head(data)
str(data)

# It needs some fine tuning (Everything is chr vector but Sm3)

# We'll start by removing the "?" characters which are suposed to be NA

data[data=="?"] <- NA

# The data it's not in it's propper format, so we'll start reformatting it

library(lubridate)
data$Date <- dmy(data$Date)
data$Time <- hms(data$Time)
data$DateTime <- data$Date + data$Time # This will become handy for the plotting
data$Global_active_power <- as.numeric(data$Global_active_power)
data$Global_reactive_power <- as.numeric(data$Global_reactive_power)
data$Voltage <- as.numeric(data$Voltage)
data$Global_intensity <- as.numeric(data$Global_intensity)
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)

# No Warnings nor Errors, the Data is also OK

#Filtering the Dates that we want

data <- data[data$Date == ymd("2007-02-01") | data$Date == ymd("2007-02-02"),]

# Great, we can start plotting!

#Setting the device (we want a png file with the default parameters)
png("Plot4.png")

# Plotting variables

par(bg=NA)
par(mfcol=c(2,2))

#Plot Code

#Top Left
plot(data$DateTime, data$Global_active_power, type="n", xlab="", ylab="Global Active Power")
lines(data$DateTime, data$Global_active_power)

#Bottom Left
plot(data$DateTime, data$Sub_metering_1, type="n", xlab="",ylab="Energy sub metering")
lines(data$DateTime, data$Sub_metering_1, col="black")
lines(data$DateTime, data$Sub_metering_2, col="red")
lines(data$DateTime, data$Sub_metering_3, col="blue")
legend("topright",col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=1, bty="n")

#Top Right
plot(data$DateTime, data$Voltage, type="n", xlab="datetime", ylab="Voltage")
lines(data$DateTime, data$Voltage)

#Bottom Right
plot(data$DateTime, data$Global_reactive_power, type="n", xlab="datetime", ylab="Global_reactive_power")
lines(data$DateTime, data$Global_reactive_power)

#Closing the device
dev.off()

# And whith this code we have the same plot #4
