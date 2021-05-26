### Downloading occurrence data from GBIF and plotting on a map ###
install.packages('dismo')
install.packages('rgdal')
install.packages('GISTools')
library(dismo)
library(rgdal)
library(maps)

## Go to www.naturalearthdata.com > Get the Data > Medium Scale Data; Cultural > Download countries.
# then load the shapefile back into R.
continents<-readOGR(dsn = "C:\\Users\\pgalante\\layers\\ne_50m_countries", layer = "ne_50m_admin_0_countries")
# Subset the SpatialPolygonsDataset by North America. Try plotting this and see how it looks. 
N.America<-continents[continents@data$CONTINENT == "North America",]
# crop North America by a rough extent of the area of interest.
Amb.opa<-crop(N.America, extent(c(-99, -66, 23, 46)))
# Plot this extent of the map. Use any color you like.
plot(Amb.opa, col='blue')

### AN EASY WAY TO FIND THE EXTENT
# An easy way to get the extent is to use R plotting an draw the extent.
# Run the following function, and click to create upper-left and lower-right corners.
# Use the "e" object in the above "crop" function 
e <- drawExtent()

# Query GBIF for data associated with species name
MarbSalam<- gbif(genus = "Ambystoma", species = "opacum", download = T)
# Look at the first 5 rows of MarbSalam. Get only the columns that have the species name, latitude and longitude.
Locs<-na.omit(data.frame(cbind(MarbSalam$species), MarbSalam$lon, MarbSalam$lat))
# Save the file if desired
write.csv(Locs, "C:\\Users\\pgalante\\Downloads\\sessionData\\Session1_data\\Locs.csv", row.names = F)
# Rename the column names of the Locs data.frame
colnames(Locs)<-c("SPECIES","LONGITUDE","LATITUDE")
# Put these points on the map
points(Locs[,2:3], col='red', pch=16)
# Add a legend
legend("bottomright", col='red', pch=16, legend = 'Ambystoma opacum')
# Add a scale
map.scale(x = -98, y = 23, relwidth=0.25, metric=T)
# Add north arrow.
library(GISTools)
GISTools::north.arrow(xb=-67, yb = 30, len=0.5, lab="N")

### This map is unprojected. Project it to a more useful projection, then recreate the plot
# Get the Proj4 string for a suitable projection. You can search for one online or use QGIS.
proj4 <- "+proj=aea +lat_0=40 +lon_0=-96 +lat_1=20 +lat_2=60 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
# reproject
NArepro <- spTransform(N.America, CRSobj = proj4)

# crop North America by a rough extent of the area of interest.

# Plot the map. Use any color you like.

# Add the points on the map - this will need several intermediate steps
# First, convert to a spatialpoints object
spCoords <- SpatialPoints(Locs[,2:3], proj4string = CRS(as.character("+proj=longlat +datum=WGS84 +no_defs")))
# Then, reproject
spCoordsRepro <- spTransform(spCoords, proj4)
points(spCoordsRepro, col = "red")
# Add a legend

# Add a scale. You will need to provide x and y values.

# Add north arrow. You will need to provide xb and yb values.
