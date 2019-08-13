##Calculates SDCI based off of MODIS, CHIRPS, and AVHRR data that has been clipped to the shapefile

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

#directory <- '/Users/akennedy/SDCI2015/'
#setwd(directory)


AVHRR <- '/Users/akennedy/Desktop/AVHRRElSa'
filesAVHRR <- list.files(path = AVHRR, full.names=T, recursive = T, pattern = 'AVHRR.2017...')
#file name is AVHRR.2000_07.tif
list(filesAVHRR)
SDCI_A.list <- list()
for (i in 1:length(filesAVHRR)) {
  r <- raster(filesAVHRR[i])
  Amax <- maxValue(r)
  Amin <- minValue(r)
  scaleAnum <- r - Amin
  scaleAden <- Amax - Amin
  scaleA <- scaleAnum / scaleAden
  SDCI_A <- scaleA * .25
  SDCI_A.list[i] <- SDCI_A
}

#####################################
##  Creating list of DATE strings  ## 
#####################################
CHIRPS <- '/Users/akennedy/Desktop/CHIRPSElSa'
filesCHIRPS <- list.files(path = CHIRPS, full.names=T, recursive = T, pattern = 'CHIRPS.2017...')
#file name is CHIRPS.2017.07.tif
dates.list <- list()
for (i in 1:length(filesCHIRPS)) {
  x <- paste0(basename(filesCHIRPS[i]))
  #print(x)
  date <- substr(x, start = 8, stop = 14)
  #print(date)
  dates.list[i] <- date
}

print(dates.list)

CHIRPS <- '/Users/akennedy/Desktop/CHIRPSElSa'
filesCHIRPS <- list.files(path = CHIRPS, full.names=T, recursive = T, pattern = 'CHIRPS.2017...')
#file name is CHIRPS.2017.07.tif
list(filesCHIRPS)
SDCI_R.list <- list()
for (i in 1:length(filesCHIRPS)) {
  r <- raster(filesCHIRPS[i])
  Rmax <- maxValue(r)
  Rmin <- minValue(r)
  scaleRnum <- r - Rmin
  scaleRden <- Rmax - Rmin
  scaleR <- scaleRnum / scaleRden
  SDCI_R <- scaleR * .5
  SDCI_R.list[i] <- SDCI_R
}

print(SDCI_R.list)

MODIS <- '/Users/akennedy/Desktop/MODISElSa'
filesMODIS <- list.files(path = MODIS, full.names=T, recursive = F, pattern = 'MOD11C3.A2017...')
list(filesMODIS)
SDCI_MODIS.list <- list()
for (i in 1:length(filesMODIS)) {
  r <- raster(filesMODIS[i])
  Mmax <- maxValue(r)
  Mmin <- minValue(r)
  scaleMODISnum <- Mmax - r
  scaleMODISden <- Mmax - Mmin
  scaleMODIS <- scaleMODISnum / scaleMODISden
  SDCI_MODIS <- scaleMODIS * .25
  SDCI_MODIS.list[i] <- SDCI_MODIS
}

#dir.create('/Users/akennedy/Desktop/SDCIElSa')
dir.create('/Users/akennedy/Desktop/SDCIElSa/2017')
output_dir <- '/Users/akennedy/Desktop/SDCIElSa/2017'
setwd(output_dir)

for (i in 1:length(SDCI_A.list)) {
  A <- SDCI_A.list[[i]]
  R <- SDCI_R.list[[i]]
  MODIS <- SDCI_MODIS.list[[i]]
  SDCI <- A + R + MODIS
  #x <- dates.list[i]
  #print(x)
  newName <- paste0('SDCI.',dates.list[[i]],'.tif')
  print(newName)
  rf <- writeRaster(x=SDCI, filename=newName, format = "GTiff", overwrite=T)
}
