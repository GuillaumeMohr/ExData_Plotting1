#########################################
# Script that creates the graph plot1.png
#########################################

##  
## extract_data function
##
## Function that create a file named by default 'hpc.txt' which contains only
## the relevant data for our analysis and reads it and returns a data_frame
##
## If the file already exists, it does not create the file and simply reads it.
## 
## If the OS is unix-based (Linux or Mac for instance), the function use the 
## system 'grep' function which is :
## (i) is quick (less than a second on my computer, a standard laptop), 
## (ii) does not use more memory than necessary (only load the required data).
## However, the code is only usable on unix-based OS (Mac and Linux), not windows.
##
## If a Windows OS is detected, the function will use R 'grep',
## combined with R 'readLines' and 'writeLines' to do the same job. It is
## however significantly slower (around 50 seconds on my laptop) but still do
## not use more memory than necessary.
##
## Example : 
## dat <- extract_data()
##
extract_data <- function(data_file = 'hpc.txt') {
    ## First we check if the file does not already exists
    if(!file.exists(data_file)) {     
        # If the OS is unix-based, we use the fast method
        if(.Platform$OS.type == 'unix') {
            # takes header from the file and writes it to hpc.txt
            system(paste('head -n 1 household_power_consumption.txt > ', data_file))
            
            # takes lines that start with 1/2/2007 or 2/2/2007 and adds them to hpc.txt
            system(paste('grep "^[12]/2/2007" household_power_consumption.txt >> ', 
                         data_file))
        }   
        # If the OS is Windows we use the 'slow' method
        else{
            fr <- file('household_power_consumption.txt', open = 'rt')
            fw <- file(data_file, open = 'wt')
            
            #Read / Write the header
            x <- readLines(con = fr, n = 1)
            writeLines(x, con = fw)
            
            #Read each lines one by one and write only the relevant ones
            while(1) {
                x <- readLines(con = fr, n =1)
                if (length(x) == 0) break
                if(grepl('^[12]/2/2007', x)) writeLines(x, con = fw)
            }
            close(fr)
            close(fw)
        }    
    }
    
    ## Then we read the data from the file data_file, which is small enough
    dat <- read.csv(file = data_file, na.strings = '?', sep = ';',
                    colClasses =  c(rep('character', 2), rep('numeric', 7)))
    
    ## For several plots, we need to create a column with date and time
    ## in a POSIXlt format
    dat$DateTime <- strptime(paste(dat$Date, dat$Time), 
                             format = '%d/%m/%Y %H:%M:%S')
    
    ## Returns the dataframe
    dat
}


##
##  plot1 function 
##
##  Function that constructs the first plot of the assignment and save it into
##  a PNG file in the required format.
##
##  Example :
##  plot1()
##

plot1 <- function() {
    
    # Loads the data using the previous function
    dat <- extract_data()
    
    # Set the device as a PNG file
    png('plot1.png', width = 480, height = 480, units = 'px')
    
    # Makes the expected plot
    par(bg = 'transparent')
    hist(dat$Global_active_power, col = 'red', 
         xlab = 'Global Active Power (kilowatts)', 
         main = 'Global Active Power')
    
    # Writes to the file
    dev.off()
}

## In order to generate the plot, just call the function below :
plot1()

