## plot4.R script
## this script contains the code used to plot plot3.png
## of the Exploratory Data Analysis Course 1 Project Assignment
##
## the scirpt is organized in two parts
##     the first part contains the code to read the data
##     the second part contains the code to plot 


## ==================================== 
## Part 1
## reading the data
## We will only be using data from the dates 2007-02-01 and 2007-02-02
##
## Since the dataset is big (The dataset has 2,075,259 rows and 9 columns)
## I will read the data from just those dates rather than reading in the entire
## dataset and subsetting to those dates.


## Defining my working (git) directory to where files will be saved
## The reader should use a different directory for obvious reasons
setwd("/Users/mmfonseca/git/Coursera_Exploratory_Data_Analysis/ExData_Plotting1/")

## Downloading the dataset table to the working directory
        ## Note that the table will be downloaded only one time
        ## Locally, the table will be named "exdata-data-household_power_consumption.zip"
        mydatasetPath <- "exdata-data-household_power_consumption.zip"
        if (!file.exists(mydatasetPath)){
                system("wget https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip --output-document=\" exdata-data-household_power_consumption.zip\"")
        }

        ## To read the data I will use system commads to extract the content of the zip
        ## to STDOUT and pipe that content to select only data for the specified dates
        ## note that the date information is found in the first column
        ## Date in format dd/mm/yyyy but if day and/or month is between 1 and 9 then format is
        ## d/m/yyyy 

        mySubsetPath <- "household_power_consumption_subset.txt"
        if (!file.exists(mySubsetPath)){
                mycommand <- paste("tar xvf",mydatasetPath,"-O | grep '^1/2/2007\\|^2/2/2007' > ", 
                                   mySubsetPath)
                system(mycommand)
        }

## Reading the dataset
        mydataset <- read.table(mySubsetPath, header = F, sep = ";", na.strings = "?")
        # header of the dataset
        myheader <- c("Date","Time", "Global_active_power", "Global_reactive_power", "Voltage",
                     "Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")
        colnames(mydataset) <- myheader

## Format columns 1 and 2 as Date and Time variables, respectively
        dates <- as.vector(mydataset$Date)
        times <- as.vector(mydataset$Time)
        x <- paste(dates, times)

## with no information about the time zone, I will use the default one "WEST"
## create a new column with Date and Time in POSIXlt format
        mydataset$DateTime <- strptime(x, "%d/%m/%Y %H:%M:%S")

## ==================================== 

## Part 2
## making plot 3
## Description:
## A timeseries plot of the Energy sub metering across the defined period
## divided by sub metering

## initiate png file to store plot4
png(filename = "plot4.png",width = 480, height = 480)
        ## defining layout to plot four figures together
        par(mfrow = c(2,2))
        
        ## plotting Global Active Power across the selected period (top right)
        plot(mydataset$DateTime, mydataset$Global_active_power, type = "l",
                ylab = "Global Active Power", xlab = "")
        ## plotting Voltage across selected period (top left)
        plot(mydataset$DateTime, mydataset$Voltage, type = "l",
                ylab = "Voltage", xlab = "datetime")
        ## plotting Sub_metering_1 (bottom right)
        plot(mydataset$DateTime, mydataset$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "")
                ## adding Sub_metering_2
                points(mydataset$DateTime, mydataset$Sub_metering_2, type = "l", col = "red")
                ## adding Sub_metering_3
                points(mydataset$DateTime, mydataset$Sub_metering_3, type = "l", col = "blue")
                ## add legend
                legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
                        lty=c(1,1,1), col = c("black", "red", "blue"), 
                        bty = "n", cex = 0.9
                )
        ## plotting Global Reactive Power across the selected period
        plot(mydataset$DateTime, mydataset$Global_reactive_power, type = "l",
                ylab = "Global_reactive_power", xlab = "datetime")

dev.off()

## ==================================== 