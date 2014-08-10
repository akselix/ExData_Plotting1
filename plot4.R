# plot4.R ####
# Downloads and reads in zip file and creates 4 charts to the same .png-file
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


# Create 4 charts to same .png file ####
library(ggplot2)
library(scales) # For date_format function
library(grid) # For panel.grid option
library(gridExtra) # For grid.arrange to get multiple charts to same page

png(file="plot4.png", bg="128")


# Chart1 ####
    c1 <- 
    qplot(Date,
          Global_active_power,
          data=df,
          geom="line"
    ) +
    
    # Set axis labels
    labs(x=NULL, y="Global Active Power") +
    
    # Set x-axis labels to days
    scale_x_datetime(breaks = "days", labels=date_format("%a")) +
    
    # Set theme options
    theme(
        panel.border=element_blank(),
        panel.background = element_rect(colour="Black", fill="128", size=1),
        plot.background = element_rect(fill="128"),
        plot.margin = unit(c(3,1,3,1), "lines"),
        axis.text.y = element_text(colour="black", angle=90, size=10),
        axis.text.x = element_text(colour="black", size=10),
        axis.title.y = element_text(size=10, vjust =2),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank()
    )
    

# Chart2 ####
c2 <- 
qplot(Date,
      Voltage,
      data=df,
      geom="line"
) +
    
    # Set axis labels
    labs(x="datetime", y="Voltage") +
    
    # Set x-axis labels to days
    scale_x_datetime(breaks = "days", labels=date_format("%a")) +
    
    # Set theme options
    theme(
        panel.border=element_blank(),
        panel.background = element_rect(colour="Black", fill="128", size=1),
        plot.background = element_rect(fill="128"),
        plot.margin = unit(c(3,1,2,1), "lines"),
        axis.text.y = element_text(colour="black", angle=90, size=10),
        axis.text.x = element_text(colour="black", size=10),
        axis.title.x = element_text(size=10, vjust =-1),
        axis.title.y = element_text(size=10, vjust =2),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank()
    )


# Chart3 ####
    c3 <- 
    ggplot(df, aes(Date)) + 
        geom_line(aes(y = Sub_metering_1, colour = "Sub_metering_1")) + 
        geom_line(aes(y = Sub_metering_2, colour = "Sub_metering_2")) +
        geom_line(aes(y = Sub_metering_3, colour = "Sub_metering_3")) +
    
    
    
    # Set theme options
    theme(
        panel.border=element_blank(),
        panel.background = element_rect(colour="Black", fill="128", size=0),
        plot.background = element_rect(fill="128"),
        plot.margin = unit(c(3,1,3,1), "lines"),
        axis.text.y = element_text(colour="Black", angle=90, size=10),
        axis.text.x = element_text(colour="Black", size=10),
        axis.title.y = element_text(size=10, vjust =2),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        
        legend.position = c(1,1),
        legend.background = element_rect(colour="128", fill="128", size=0),
        legend.key = element_blank()
        legend.key.width = unit(5, "mm"),
        legend.title=element_blank(),
        legend.text=element_text(size=10)
        
    ) +
    
    scale_color_manual(values=c("Black", "Red", "Blue")) +
    
    # Set axis labels
    labs(x=NULL, y="Energy Sub Metering") +
    
    # Set x-axis labels to days
    scale_x_datetime(breaks = "days", labels=date_format("%a"))


# Chart4 ####
c4 <- 
    qplot(Date,
          Global_reactive_power,
          data=df,
          geom="line"
    ) +
    
    # Set axis titles
    labs(x="datetime", y="Global_reactive_power") +
    
    # Set x-axis labels to days
    scale_x_datetime(breaks = "days", labels=date_format("%a")) +
    
    # Set theme options
    theme(
        panel.border=element_blank(),
        panel.background = element_rect(colour="Black", fill="128", size=1),
        plot.background = element_rect(fill="128"),
        plot.margin = unit(c(3,1,2,1), "lines"),
        axis.text.y = element_text(colour="black", angle=90, size=10),
        axis.text.x = element_text(colour="black", size=10),
        axis.title.x = element_text(size=10, vjust =-1),
        axis.title.y = element_text(size=10, vjust =2),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank()
    )

# Combine charts to one page ####
grid.arrange(c1, c2, c3, c4, ncol=2)

dev.off()
