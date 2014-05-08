
## Coursera Data Science course exdata-002 course project.

## Created: Wed May  7 19:30:28 2014
## Author : Mike Martinez
## Email  : martinezm AT ociweb DOT com

##
## plot1.R - Global Active Power
##
## Plot: Frequency / Global Active Power (kilowatts)
##
## This uses the dataset from the UC Irvine Machine Learning
## Repository (http://archive.ics.uci.edu/ml/)
##
## The specific dataset is for Electric Power Consumption

# Locations
dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
datasetFile <- "household_power_consumption.txt"
localFile <- "./data/epc.zip"
plotFile <- 'plot2.png'

# Ensure there is a directory to put the data in.
if(!file.exists('data')) {
  dir.create('data')
}

# Ensure we have the dataset file.
if(!file.exists(localFile)) {
  download.file(dataUrl, destfile = localFile, method = 'curl')
  epc_date <- date();
}

# A bit of magic here... :\
# TODO: Figure out if we can grep while we read with this.
firstrow <- 66638
lastrow  <- 69517

# Extract the data we are interested in.
datafile <- unz(localFile, datasetFile)
dataset <- read.table(datafile,
                      sep=';', stringsAsFactors=F, na.strings = '?',
                      skip=firstrow-1, nrows=lastrow-firstrow+1)


# Extract the names we are interested in.
# (unfortunately I can't read the first line then a chunk later
# in a single operation).
datafile <- unz(localFile, datasetFile)
datanames <- read.table(datafile,
                        sep=';', stringsAsFactors=F, na.strings = '?',
                        nrows=1)
names(dataset) = datanames

dataset <- data.frame(
  datetime = strptime(paste(dataset$Date,
                            dataset$Time),
                      "%d/%m/%Y %H:%M:%S"),
  dataset)

dataset$Date = as.Date(dataset$Date,"%d/%m/%Y")

# Generate the plot.
png(filename=plotFile, width=480, height=480)
plot(dataset$datetime,
     dataset$Global_active_power,
     main='', xlab='', ylab='Global Active Power (kilowatts)',
     type='l')
dev.off()
