##Crops CHIRPS precipitation and AVHRR NDVI data that is in tif format to a shapefile
# Change 'input' and 'file_pattern' to clip different directories of tifs to a mask
#Do this for CHIRPS and AVHRR for suitable_coffee shapefile


#install.packages("ncdf4") 
require(ncdf4)
library(ncdf4)
#install.packages("sp")
library(sp)
#install.packages("raster") 
library(raster)
#install.packages("rgdal")
library(rgdal)
#install.packages("maptools")
library(maptools)
gpclibPermit()
#install.packages("gdalUtils")
library(gdalUtils)

directory <- '/Users/akennedy/Desktop/Final NDVI/' #folder containing monthly averages
setwd(directory)


studyArea <- shapefile('/Users/akennedy/Desktop/Suitable_Coffee_Hond/Suitable_Coffee_Hond.shp')
plot(studyArea)

dir.create("/Users/akennedy/Desktop/AVHRRHond") #create folder for output
dir.output <- "/Users/akennedy/Desktop/AVHRRHond" #set new folder to output
setwd(dir.output) #set working directory to newly created output folder
# Set working directory to newly created Output folder

files <- list.files(path = "/Users/akennedy/Desktop/Final NDVI/", full.names=T, recursive = T, pattern = "...")
# Creates vector of files to use in for loop

list(files)

for (i in 1:length(files)) {
  x <- paste0(basename(files[i]))
  #print(x)
  date <- substr(x, start = 25, stop = 31) #name of the file; change start and stop to character in original file name that is start of date and end of date
  newName <- paste0("AVHRR.",date,".tif")
  print(newName)
  r <- raster(files[i])
  crs(r) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
  final <- mask(r,studyArea)
  rf <- writeRaster(x=final, filename=newName, format = "GTiff", overwrite=T)
  #plot(rf)
}