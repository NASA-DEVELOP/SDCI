##Crop AVHRR NDVI data to a defined extent

#create a variable set to where the input files are
directory <- ("/Users/akennedy/2001") 
setwd(directory) #set directory to where input files are

library(chron)
library(RColorBrewer)
library(lattice)
library(ncdf4)
library(raster)
library(rgdal)

dir.create("/Users/akennedy/Desktop/NDVICrop2001") #create new folder for output

# create a variable set to the new folder
dir.output <- ("/Users/akennedy/Desktop/NDVICrop2001/")

# set working directory to that new folder variable
setwd(dir.output)

#create variable set to location of input files
files <- list.files(path="/Users/akennedy/2001/", pattern="*.nc", full.names=T, recursive=T) ### recursive = T <-- loops through all subfolders 



#loops through all files (as defined by above variable) and crops them and formats as geotiff
## For simplicity, I use "i" as the file name, you could change any name you want, "substr" is a good function to do this.
for (i in 1:length(files)) {
  a <- nc_open(files[i]) # load file
  p <- ncvar_get(nc=a,'NDVI') ### select the parameter you want to make into raster files
  
  
  p[p == - 9999] <- NA #accounts for non-data values (this is the particular value for NOAA AVHRR NDVI)
  r <- raster(p)
  e <- extent(-90, 90, -180, 180) ### choose the extent based on the netcdf file info
  re <- setExtent(r,e) ### set the extent to the raster
  projection(re) <- "+proj=longlat +datum=WGS84 +ellps=WGS84" #set projection of new files
  tre <- t(re)
  
  camer <- crop(tre, extent(tre, 1422, 1600, 1740, 1960)) #crops to the extent of Central America
  writeRaster(camer, paste(dir.output, basename(files[i]), sep = ''), format = "GTiff", overwrite = T) #writes new file as geotiff
  
  
}