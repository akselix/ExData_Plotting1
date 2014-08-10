# plot2.R ####
# Downloads and reads in zip file and creates a plot to a .png-file
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

# Subset data for required dates ####
df <- alldata[alldata$Date== "1/2/2007" | alldata$Date== "2/2/2007",]
# Convert Date and Time to POSIXct and paste both to Date column
df$Date <- strptime(paste(df$Date,df$Time), "%d/%m/%Y %H:%M:%S")
# Remove Time column
df$Time  <-  NULL


plotdays <- c("Thu", "Fri", "Sat")

# Create plot of Global_active_power column to .png file ####
library(ggplot2)
library(scales) # For date_format function
library(grid) # For panel.grid option

png(file="plot2.png")
    
    # Create the plot
    qplot(Date, 
          Global_active_power, 
          data=df, 
          geom="line"
         ) +
    
    # Set theme options
    theme(
        panel.margin = unit(2, "lines"),
        panel.background = element_rect(colour="black", fill="128", size=1),
        plot.background = element_rect(fill="128"),
        axis.text.y = element_text(colour="black", angle=90, size=12),
        axis.text.x = element_text(colour="black", size=12),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank()
        ) +
    
    # Set axis labels
    labs(x=NULL, y="Global Active Power (kilowatts)") +
    
    # Set x-axis labels to days
    scale_x_datetime(breaks = "days", labels=date_format("%a"))
  
dev.off()