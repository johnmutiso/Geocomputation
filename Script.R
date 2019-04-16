library(leaflet)

# Chapter - 02
# packages
# install.packages("sf")
# install.packages("raster")
# install.packages("spData") 
# devtools::install_github("Nowosad/spDataLarge")

library(sf) # classes and functions for vector data
library(raster) # classes and functions for raster data
library(rgdal)

library(spData) # Loading geographic data
library(spDataLarge) # Loading larger geographic data

# Availability of sf package vignettes 
vignette(package = "sf")
vignette("sf2")

# Working with thw world data from the spData package
data(world)
names(world)
plot(world)

summary(world)

# Subsetting spatial data frame
world.mini <- world[1:2,1:3]
world.mini
plot(world.mini)

library(sp)

world_sp <- as(world, Class = "Spatial")
# Spatila objects can be conversted into sf (spatial data frames) using
# the st_as_sf() function

world_sf <- st_as_sf(world_sp)

# Basic map making
# in sf using plot() - creates a multi-panel plot just like sp's spplot()
plot(world[3:6])
plot(world["pop"])
world_asia = world[world$continent == "Asia", ]
asia = st_union(world_asia)

# The plot must have one facet for add feature to work
plot(world["pop"], reset = FALSE)
plot(asia, add = TRUE, col = "red")

# tmap package can be used for more interactive mapping
plot(world["continent"], reset = FALSE)
cex = sqrt(world$pop) / 10000
world_cents = st_centroid(world, of_largest = TRUE)
plot(st_geometry(world_cents), add = TRUE, cex = cex)

india = world[world$name_long == "India", ]
plot(st_geometry(india), expandBB = c(0, 0.2, 0.1, 1), col = "gray", lwd = 3, reset = T)
plot(world_asia[0], add = TRUE)

# simple feature geometries
st_point(c(0,1))
st_point(c(5, 2, 3)) 
st_point(c(5, 2, 3, 1))

multipoint_matrix = rbind(c(5, 2), c(1, 3), c(3, 4), c(3, 2))
st_multipoint(multipoint_matrix)

linestring_matrix = rbind(c(1, 5), c(4, 4), c(4, 1), c(2, 2), c(3, 2))
st_linestring(linestring_matrix)
polygon_list = list(rbind(c(1, 5), c(2, 2), c(4, 1), c(4, 4), c(1, 5)))
st_polygon(polygon_list)

# Single features columns (sfc)
point1 = st_point(c(5, 2))
point2 = st_point(c(1, 3))
points_sfc = st_sfc(point1, point2)
points_sfc

# sfc polygon
polygon_list1 = list(rbind(c(1, 5), c(2, 2), c(4, 1), c(4, 4), c(1, 5)))
polygon1 = st_polygon(polygon_list1)
polygon_list2 = list(rbind(c(0, 2), c(1, 2), c(1, 3), c(0, 3), c(0, 2)))
polygon2 = st_polygon(polygon_list2)
polygon_sfc = st_sfc(polygon1, polygon2)
st_geometry_type(polygon_sfc)

# sfc MULTILINESTRING
multilinestring_list1 = list(rbind(c(1, 5), c(4, 4), c(4, 1), c(2, 2), c(3, 2)), rbind(c(1, 2), c(2, 4)))
multilinestring1 = st_multilinestring((multilinestring_list1))
multilinestring_list2 = list(rbind(c(2, 9), c(7, 9), c(5, 6), c(4, 7), c(2, 7)), rbind(c(1, 7), c(3, 8)))
multilinestring2 = st_multilinestring((multilinestring_list2))
multilinestring_sfc = st_sfc(multilinestring1, multilinestring2)
st_geometry_type(multilinestring_sfc)

# sfc GEOMETRY
point_multilinestring_sfc = st_sfc(point1, multilinestring1)
st_geometry_type(point_multilinestring_sfc)

st_crs(points_sfc)
# Adding coordinate reference system in sfc objects
points_sfc_wgs = st_sfc(point1, point2, crs = 4326)
st_crs(points_sfc_wgs)

# PROJ4STRING definition
st_sfc(point1, point2, crs = "+proj=longlat +datum=WGS84 +no_defs")

lnd_point = st_point(c(0.1, 51.5))                 # sfg object
lnd_geom = st_sfc(lnd_point, crs = 4326)           # sfc object
lnd_attrib = data.frame(                           # data.frame object
        name = "London",
        temperature = 25,
        date = as.Date("2017-06-21")
)
lnd_sf = st_sf(lnd_attrib, geometry = lnd_geom)    # sf object
lnd_sf

class(lnd_sf)
plot(lnd_sf)

# introduction to raster ----
# 

raster_filepath = system.file("raster/srtm.tif", package = "spDataLarge")
new_raster = raster(raster_filepath)

# basic plotting
plot(new_raster)

# Raster classes

raster_filepath = system.file("raster/srtm.tif", package = "spDataLarge")
new_raster = raster(raster_filepath)

# raster package supports many drivers which can be viewed using 
# raster::writeFormats() and rgdal::gdalDrivers()
# 
 # Creating raster files from scratch using the raster function

new_raster2 = raster(nrows = 6, ncols = 6, res = 0.5, 
                     xmn = -1.5, xmx = 1.5, ymn = -1.5, ymx = 1.5,
                     vals = 1:36)
plot(new_raster2)

# CRS
# can be created using espg or proj4string

crs_data = rgdal::make_EPSG()
View(crs_data)

vector_filepath = system.file("vector/zion.gpkg", package = "spDataLarge")
new_vector = st_read(vector_filepath)

st_set_crs() # sets a CRS system

new_vector = st_set_crs(new_vector, 4326) 
