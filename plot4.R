plot4<- function(){
        packages <- c("data.table", "downloader")
        
        sapply(packages, require, character.only = TRUE, quietly = TRUE)
        ##ensures that the necessary packages are loaded 
        
        path <- file.path(getwd(), "project1")
        if (!file.exists(path)) {dir.create(path)}
        setwd(path)
        ##sets/creates the working directory 
        
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        f <- "household_power_consumption.zip"
        download(url, destfile = f, quiet=TRUE)
        dateDownloaded <- date()
        ##downloads the file and records the data it was downloaded 
        
        zipfile<-file.path(getwd(), f)
        file_names <- unzip(zipfile, list=TRUE)$Name
        unzip(zipfile, exdir=path)
        message("Data file successfully downloaded and unzipped. Your data is stored here:")
        print(path)
        print(file_names)
        print(dateDownloaded)
        
        data <- subset(read.csv(file_names[1], 
                                header=TRUE, 
                                sep=";", 
                                quote="\"", 
                                na.strings="?", 
                                colClasses=c(rep("character",2), rep("numeric",7))), 
                       Date=="1/2/2007" | Date=="2/2/2007")
        ##loads and cleans the data
        
        data$DateTime<-strptime(paste(data$Date,data$Time),"%d/%m/%Y %H:%M:%S")
        ## converts the time  and date fields to a positx timedate stamp 
        
        png("plot4.png", width=480, height=480)
        ##turns on the png device 
        
        par(mfrow=c(2,2))
        plot(data$DateTime, data$Global_active_power, typ="l", ylab="Global Active Power (kilowatts)", xlab="")
        plot(data$DateTime, data$Voltage, typ="l", ylab="Voltage", xlab="datetime")
        plot(data$DateTime, data$Sub_metering_1,type="l", xlab="", ylab="Energy sub metering")
        lines(data$DateTime, data$Sub_metering_2, col="red")
        lines(data$DateTime, data$Sub_metering_3, col="blue")
        leg.txt=c("Sub_metering_1  ", "Sub_metering_2  ", "Sub_metering_3  ")
        legend("topright", col = c("black", "red", "blue"), legend = leg.txt, lty=c(1,1), bty="n", cex=1)
        plot(data$DateTime, data$Global_reactive_power, typ="l", ylab="Global_reactive_power", xlab="datetime")   
        ##creates plot 4
        
        dev.off()
        ##turns of the png device. 
}