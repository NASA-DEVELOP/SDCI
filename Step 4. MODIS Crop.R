##Convert list of MODIS hdf's to tif and clip to study area shapefile


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

# !Change to folder containing tifs!
directory <- '/Users/akennedy/MODIS'
setwd(directory)

studyArea <- shapefile('/Users/akennedy/Desktop/Suitable_Coffee_ElSa/Suitable_Coffee_ElSa.shp') #change this to shapefile
#plot(studyArea)

dir.create("/Users/akennedy/Desktop/MODISElSa") 
# OPTIONAL: Creates last folder in this path, Outputs

dir.output <- "/Users/akennedy/Desktop/MODISElSa"
setwd(dir.output)
# Set working directory to newly created Output folder

files <- list.files(path = "/Users/akennedy/MODIS", full.names=T, recursive = T, pattern = "MOD11C3.A20...")
# Creates vector of files to use in for loop

list(files)

for (i in 1:length(files)) {
  #print(files[i])
  info <- gdalinfo(files[i]) #extracts information from hdf
  sds <- get_subdatasets(files[i]) #gets lists of subdatasets contained within hdf
  #print(sds[1])
  x <- paste0(basename(files[i]))
  #print(x)
  name <- substr(x, start = 1, stop = 16)
  #print(name)
  newName <- paste0(name,".tif")
  print(newName)
  gdal_translate(sds[1], dst_dataset = newName) #grabbing first subdataset (which should be daily LST)
  r <- raster(newName)
  crs(r) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
  final <- mask(r,studyArea)
  rf <- writeRaster(x=final, filename=newName, format = "GTiff", overwrite=T)
  #plot(rf)
}

