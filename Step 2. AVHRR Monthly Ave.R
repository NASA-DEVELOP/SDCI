##Takes daily AVHRR NDVI files and computes a monthly average for each month in the study period

library(chron)
library(RColorBrewer)
library(lattice)
library(ncdf4)
library(raster)
library(tools)
library(rgdal)

##Sort files by month
setwd('/Users/akennedy/Desktop/NDVICrop2001/') #set directory to files to be organized by month
img <- list.files(pattern='\\.tif$', recursive=T)

ymd<- substr(img, 37,38) #set to characters in each file that signify the month

no_return_values = sapply(ymd, dir.create) #Creates folders by month (ymd)
no_return_values = mapply(file.copy, img, ymd) #Copies files and sorts them into monthly folders

##Monthly stacking to create monthly averages
dir.create("/Users/akennedy/Desktop/NDVICrop2001/monthlystacks") #create new folder for output

setwd('/Users/akennedy/Desktop/NDVICrop2001') #Sets directory to where monthly folders are
dir.output <- '/Users/akennedy/Desktop/NDVICrop2001/monthlystacks/' #Sets output for monthly tables
folders<- list.dirs(recursive = TRUE) #create variable for monthly sorted files

##Loop that calculates monthly averages
for (i in 1:length(folders)){
  files <- list.files (folders[i], pattern ='\\.tif$', full.names=T)
  s <- stack(files)
  m.stack <- calc(s, mean, na.rm = TRUE)
  

  writeRaster(m.stack, paste0(dir.output,"Camer_NDVI_monthly_2001","_",basename(folders[i])), format = 'GTiff', overwrite = T) ##the basename allows the file to be named the same as the original ##change year (2001) in file name based on input files
}


