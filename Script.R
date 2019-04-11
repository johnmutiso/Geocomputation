library(leaflet)

# Chatper - 02
# packages
# install.packages("sf")
# install.packages("raster")
# install.packages("spData") 
# devtools::install_github("Nowosad/spDataLarge")

library(sf) # classes and functions for vector data
library(raster) # classes and functions for raster data

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

