
## Coursera Data Science course exdata-002 course project.

## Created: Wed May  7 19:30:28 2014
## Author : Mike Martinez
## Email  : martinezm AT ociweb DOT com

##
## plot3.R - Energy sub-metering
##
## Plot: Energy sub-metering / datetime
##
## This uses the dataset from the UC Irvine Machine Learning
## Repository (http://archive.ics.uci.edu/ml/)
##
## The specific dataset is for Electric Power Consumption

# Locations
dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
datasetFile <- "household_power_consumption.txt"
zipFile <- "./data/epc.zip"
plotFile <- 'plot3.png'

# Ensure there is a directory to put the data in.
if(!file.exists('data')) {
  dir.create('data')
}

# Ensure we have the dataset file.
if(!file.exists(zipFile)) {
  download.file(dataUrl, destfile = zipFile, method = 'curl')
  epc_date <- date();
}

# A bit of magic here... :\
# TODO: Figure out if we can grep while we read with this.
firstrow <- 66638
lastrow  <- 69517

# Extract the data we are interested in.
dataset <- read.table(unz(zipFile, datasetFile),
                      sep=';', stringsAsFactors=F, na.strings = '?',
                      skip=firstrow-1, nrows=lastrow-firstrow+1)


# Extract the names we are interested in.
# (unfortunately I can't read the first line then a chunk later
# in a single operation).
datanames <- read.table(unz(zipFile, datasetFile),
                        sep=';', stringsAsFactors=F, na.strings = '?',
                        nrows=1)
names(dataset) <- datanames

# Pre-pend the combined date/time column to the frame.
dataset <- data.frame(
  datetime = strptime(paste(dataset$Date,
                            dataset$Time),
                      "%d/%m/%Y %H:%M:%S"),
  dataset)

# Convert the Date column to Date() class.
dataset$Date = as.Date(dataset$Date,"%d/%m/%Y")

# Generate the plot to a constrained image file.
png(filename=plotFile, width=480, height=480)

plot(dataset$datetime,
     dataset$Sub_metering_1,
     main='', xlab='', ylab='Energy sub metering',
     type='l',col='black')
lines(dataset$datetime,
      dataset$Sub_metering_2,
      col='red')
lines(dataset$datetime,
      dataset$Sub_metering_3,
      col='blue')
legend('topright',
       c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),
       col=c('black','red','blue'),lty=1)

dev.off()
