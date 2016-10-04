# We assume that the unzipped file "household_power_consumption.txt"
# already exists in the working directory.
# If not, download it (and unzip it) from
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

if(!exists("dpower")){
  file_name = "household_power_consumption.txt"
  
  # copies ONLY the headers of the file
  header <- read.table(file_name, nrows = 1, header = FALSE, sep =';', stringsAsFactors = FALSE)
  
  # copies the rest of the file in a data frame	
  dpower <- read.table(file_name, skip = 2, header = FALSE, sep =';', na.strings = "?", stringsAsFactors = FALSE)
  
  # uses the header for naming the columns of the data frame
  colnames(dpower) <- unlist(header)
  
  # uses a logical vector in order to subset only the rows we are interested in
  logical <- dpower$Date == "1/2/2007" | dpower$Date == "2/2/2007"
  dpower <- dpower[logical,]
  
  # adds an additional column ("complete_Time") obtained by pasting the "Date" and "Time" columns,
  # then converting them to a date class
  complete_Time <- strptime(paste(dpower$Date,dpower$Time), "%d/%m/%Y %H:%M:%S")
  dpower <- cbind(dpower, complete_Time)
}

# Checks for existence of open devices
# If there is only the null device (device 1),
# then the next instruction would give an error.
# With this if-instruction we will never experience errors
if(dev.cur() == 1)
  dev.new()

# opens a connection to plot2.png (creates the file if it does not exist)
dev.copy(png, file="plot2.png")

# creates the frame of the plot, but does not write any point in it
with(dpower,plot(complete_Time, Global_active_power, xlab = "", ylab = "Global Active Power (kilowatts)", type = "n"))

# plots the couples (complete_Time,Global_active_power) in the frame dpower
with(dpower,lines(complete_Time,Global_active_power))

# finishes to write on the file, and closes the connection
dev.off()
