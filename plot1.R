# plot1.R ####
# Downloads and reads in zip file and creates a histagram to a .png-file
# 2014-9-9
# Akselix

# Check if file exists in working directory and read in data. If it does not, load zip file, unzip and read in data without saving the file. ####
if(file.exists("household_power_consumption.txt")) {
    alldata <- read.table("household_power_consumption.txt", header=T, sep=";", dec=".", na.strings="?", stringsAsFactors=F)
    
    } else {
        temp <- tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp, method="curl")
        data <- read.table(unz(temp, "household_power_consumption.txt"))
        unlink(temp)
    }

# Subset data for required dates
df <- alldata[alldata$Date== "1/2/2007" | alldata$Date== "2/2/2007",]
# Convert Date and Time to POSIXct and paste both to Date column
df$Date <- strptime(paste(df$Date,df$Time), "%d/%m/%Y %H:%M:%S")
# Remove Time column
df$Time  <-  NULL


# Create histogram of Global_active_power column to .png file ####
png(file="plot1.png")
    par(bg=128)
    with(df, hist(Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)"))
dev.off()