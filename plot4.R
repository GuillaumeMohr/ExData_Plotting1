#########################################
# Script that creates the graph plot4.png
#########################################

##
## READS THE DATA
##
# the method I used to extract the data 
# (i) is quick (less than a second on my computer, as standard laptop), 
# (ii) does not use more memory than necessary (only load the required data),
# (iii) does not require the installation of extra R-packages. 
# However, the code is only usable on unix-based OS (Mac and Linux), not windows.

# Works only on Mac / Linux  systems
if(.Platform$OS.type != 'unix')
    stop('The current OS is not unix-based.')

# takes header from the file and writes it to hpc.txt
system('head -n 1 household_power_consumption.txt > hpc.txt')

# takes lines that start with 1/2/2007 or 2/2/2007 and adds them to hpc.txt
system('grep "^[12]/2/2007" household_power_consumption.txt >> hpc.txt')

# reads hpc.txt file and stores it in a data frame
dat <- read.csv(file = 'hpc.txt', na.strings = '?', sep = ';',
                colClasses =  c(rep('character', 2), rep('numeric', 7)))

# create a DateTime column from the Date and Time columns
dat$DateTime <- strptime(paste(dat$Date, dat$Time, sep = ' '), 
                           format = '%d/%m/%Y %H:%M:%S')


## CONSTRUCTS THE PLOT
# Sets the device as a PNG file
png('plot4.png', width = 480, height = 480, units = 'px')

# In order to show the weekdays in English, I need to change the locale
Sys.setlocale('LC_TIME', 'en_US.UTF-8')

# Set the frame for 4 plots
par(mfcol = c(2, 2), bg = 'transparent')

# Makes the top-left plot
plot(dat$DateTime, dat$Global_active_power, type = 'l',
     xlab = '', ylab = 'Global Active Power')

# Makes the bottom-left plot
plot(dat$DateTime, dat$Sub_metering_1, type = 'l', col = 'black',
     xlab = '', ylab = 'Energy sub metering')
points(dat$DateTime, dat$Sub_metering_2, type = 'l', col = 'red')
points(dat$DateTime, dat$Sub_metering_3, type = 'l', col = 'blue')
legend('topright', legend = colnames(dat)[7:9], col = c('black','red','blue'),
       lty = 1, box.lty = 0)

# Makes the top-right plot
plot(dat$DateTime, dat$Voltage, type = 'l',
     xlab = 'datetime', ylab = 'Voltage')

# Makes the bottom-right plot
plot(dat$DateTime, dat$Global_reactive_power, type = 'l',
     xlab = 'datetime', ylab = 'Global_reactive_power')


# Write to the file
dev.off()
