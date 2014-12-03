####################################################-
#---------------------------------------------------#
# Friday R - GIS with Rasters in R - Nick Murray  ####
#---------------------------------------------------#
####################################################-

#---------------------------------------------------#
#### 1. Setting up ####
#---------------------------------------------------#


# Get data here:
https://www.dropbox.com/sh/cqmbk7zj1en8tnv/AACI3l-lalRVEn8f_C-8WvP1a?dl=0 

install.packages(c('raster', 'dismo','rgdal', 'maps'))  # raster for raster objects, dismo is SDM, rgdal to read and write various spatial data
library (raster) # load raster package
#vignette('Raster') # refer to raster vignette
?"raster-package" # or click the raster link here
setwd ("C:/Dropbox/Workshops/2013_FridayR/Murray_SpatialR_11102014")





#---------------------------------------------------#
#### 2. Understanding Raster Data ####
#---------------------------------------------------#

# make a raster object 
x = raster(ncol = 10, nrow = 10) # let's make a small raster
nrow(x) # number of pixels
ncol(x) # number of pixels
ncell(x) # total number of pixels 
plot(x) # doesn't plot because the raster is empty
hasValues(x) # can check whether your raster has data
values(x)<-1 # give the raster a pixel value - in this case 1
plot(x) # entire raster has a pixel value of 1 

# make a random number raster for better viewing and check some things
values(x)<-runif(ncell(x)) # each pixel is assigned a random number
plot(x) # raster now has pixels with random numbers
x[1,1] # value of the top pixel cell of the raster
click(x) # handy just to check things, esc to exit

# what's special about a raster?
str(x) # note the CRS and extent, plus plenty of other slots
crs(x) # check what coordinate system it is in, the default in the PROJ.4 format
xmax(x) # check extent
xmin(x)
ymax(x)
ymin(x)
extent(x) # easier to use extent
res(x)  # resolution
xres(x) # just pixel width

#---------------------------------------------------#
#### 3. Working with real raster data ####
#---------------------------------------------------#

# import the Cairns mangrove data
mangrove <- raster("Cairns_Mangroves_30m.tif") 
crs(mangrove) # get projection
plot(mangrove, col = topo.colors("2")) # note two pixel values, 0 (not mangrove) and 1 (mangrove)
NAvalue(mangrove) <- 0 # make a single ecosystem dataset with raster value 1
plot(mangrove, col = "mediumseagreen")

# simple changes
agg.mangrove <- aggregate(mangrove, fact=10) # aggregate cells (10 times bigger)
plot(agg.mangrove, col = "firebrick")
plot(mangrove, col = "mediumseagreen", add = T)

# buffers
buf.mangrove <- buffer(agg.mangrove, width=1000) # add a buffer
plot(buf.mangrove, col = "peachpuff")
plot(mangrove, col = "mediumseagreen", add = T)


# other processing: crop, merge, trim, interpolate, reclassify, raster to points, raster to polygon
# analysis: zonal statistics, focal window analysis, raster calculator, 
# distance analysis, summary stats, sampling etc.

# export the aggregated raster
KML(agg.mangrove, "aggmangrove.kml", overwrite = T)
writeRaster(agg.mangrove, "agg.mangrove.tif", format = "GTiff")

#---------------------------------------------------#
#### 4. Some simple analyses ####
#---------------------------------------------------#

# get SST data
sst.feb <- raster("msk_sst_mnmean_OIv2_201302.img")
plot(sst.feb)

# crop it to the pacific
pacific.extent <- extent(mangrove) + 80 # a quick way but probably better to define it yourself
pacific.extent # check it
sst.feb.crop <- crop(sst.feb, pacific.extent) # crop to the pacific
plot (sst.feb.crop)

# get the long-term mean
sst.feb.mn <- raster("LongtermMonthlyMeansst_ltmean_OIv2_20010201_2.img")
plot(sst.feb.mn)
sst.mn.crop <- crop(sst.feb.mn, pacific.extent)
plot (sst.mn.crop)

# make the 'anomaly'
sst.anomaly <- sst.feb.crop - sst.mn.crop  
plot (sst.anomaly) # plot the anomaly map
plot(sst.anomaly, col = topo.colors("100")) # add better colours
contour(sst.anomaly, add = T) # add contours

# some others
minValue(sst.anomaly) # coldest pixel
maxValue(sst.anomaly) # warmest pixel
hist(sst.anomaly, main = "February SST Anomaly - Pacific", xlab = "sst anomaly") # check histogram of values

# writing rasters
writeRaster(sst.anomaly, "sst.anomaly.tif", format = "GTiff") # write as a geotiff
KML(sst.anomaly, "sst.anomaly.kml") # write as a kml for google maps

# other things - raster size is often a problem
inMemory(sst.feb.mn) #  FALSE because it hasn't read in the whole raster - R will only access it when needed.
inMemory(sst.anomaly) # TRUE - so it's in memory. 

#---------------------------------------------------#
#### 5. So many other cool things ####
#---------------------------------------------------#

# raster stack and raster brick
sst.stack <- stack(sst.mn.crop, sst.feb.crop) # make a 'pile' of the two rasters
plot(sst.stack)
nlayers(sst.stack) # two layers
plot(sst.stack,2) 
# brick is similar, like a satellite image with bands and save on file

# just a quick example of what we can do with rasters - extract random data for species distribution modelling
library(dismo)  # species distribution modelling package
rpoints.sst<- randomPoints(sst.stack,500)  # now we just make 500 random points across our study area
points(rpoints.sst, pch = 16, cex = 0.7)
sst.samp <- extract(sst.stack, rpoints.sst)  # now extract the data value at each point across all rasters in the stack
head(sst.samp)

# get climate data using raster package
rain = getData('worldclim', var = "prec", res = 10, lon=5, lat=45)
plot(rain)
nlayers(rain)
rpoints.rain<- randomPoints(rain,500)  # now we just make 500 random points across our study area
plot(rain,1) # plot january rainfall
points(rpoints.rain, pch = 16, cex = 0.7)
samp.rain <- extract(rain, rpoints.rain) 
head(samp.rain)

# get maps using dismo
Aus<-gmap("Australia") # get google maps normal
plot(Aus)
AusSat<-gmap("Australia", type = "satellite") # get google maps satellite image
plot(AusSat)

# get simple maps
library (maps)
map(database = "world", col = "grey")

# also see
library(rasterVis)
library(maptools) 
library (sp) # shapefiles
