#########################################
# Script that creates the graph plot1.png
#########################################

## READS THE DATA quickly and without using more memory than necessary
## Works only on Mac / Linux  systems
if(.Platform$OS.type != 'unix')
    stop('The current OS is not unix-based.')

# takes header from the file and writes it to hpc.txt
system('head -n 1 household_power_consumption.txt > hpc.txt')

# takes lines that start with 1/2/2007 or 2/2/2007 and adds them to hpc.txt
system('grep "^[12]/2/2007" household_power_consumption.txt >> hpc.txt')

# reads hpc.txt file and stores it in a data frame
dat <- read.csv(file = 'hpc.txt', na.strings = '?', sep = ';',
                colClasses =  c(rep('character', 2), rep('numeric', 7)))


## CONSTRUCTS THE PLOT
# Set the device as a PNG file
png('plot1.png', width = 480, height = 480, units = 'px')

# Makes the expected plot
hist(dat$Global_active_power, col = 'red', 
     xlab = 'Global Active Power (kilowatts)', 
     main = 'Global Active Power')

# Writes to the file
dev.off()
