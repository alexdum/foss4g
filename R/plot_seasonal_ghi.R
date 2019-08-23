library(raster)
library(rnaturalearth)
library(classInt)
library(RColorBrewer)
library(RSAGA)

# prepare the layer with world borders
countries <- ne_countries(scale = 110, type = "countries")
countries.line <- as(countries, "SpatialLines")
countries.sp <- list("sp.lines", countries.line, col = "#525252",lwd = 1)

# load seasonal data
r.seas <- brick("nc/ghi_seasons_1981_2018.nc")


# extract season from name
season <- sort(unique(substr(names(r.seas),7,8)))

# compute multianual mean for each season 1980-2018
r.multi <- stack()

for (i in season) { 
  
  r.multi <- addLayer(r.multi, mean(r.seas[[which(substr(names(r.seas),7,8) %in% i)]]))
}

names(r.multi) <- c("DJF","MAM", "JJA", "SON")
r.multi[] <- round(getValues(r.multi), 1)

# # check range of values
# summary(brick(r.multi))
# find the preaks with pretty
brks <- classIntervals(as.vector(getValues(r.multi)), n = 14, style = "pretty")
rds <- colorRampPalette(brewer.pal(9,"YlOrRd"))
cols <- rds(length(brks$brks))

p1 <- spplot(r.multi, sp.layout = list(countries.sp), scales = list(draw = TRUE, cex = 0.8),
             col.regions = cols,cuts = length(brks$brks) - 1,at = brks$brks,
             colorkey = list(height = 0.8,
                             labels = list(
                               at = brks$brks[2:(length(brks$brks) - 1)],
                               labels = round(brks$brks,2)[2:(length(brks$brks) - 1)]
                             ), space = "bottom"),
             par.settings = list(strip.background = list(col = "white")))
plot(p1)

# compute multianual mean for each season 2009-2018
##selecct rasters for the period of interest
r.seas2 <- r.seas[[which(substr(names(r.seas),2,5) >= 2009)]]
r.multi2 <- stack()

for (i in season) { 
  
  r.multi2 <- addLayer(r.multi2, mean(r.seas2[[which(substr(names(r.seas2),7,8) %in% i)]]))
}

names(r.multi2) <- c("DJF","MAM", "JJA", "SON")
r.multi2[] <- round(getValues(r.multi2), 1)

# # check range of values
# summary(brick(r.multi))
# find the preaks with pretty
brks <- classIntervals(as.vector(getValues(r.multi2)), n = 14, style = "pretty")
rds <- colorRampPalette(brewer.pal(9,"YlOrRd"))
cols <- rds(length(brks$brks))

p1 <- spplot(r.multi2, sp.layout = list(countries.sp), scales = list(draw = TRUE, cex = 0.8),
             col.regions = cols,cuts = length(brks$brks) - 1,at = brks$brks,
             colorkey = list(height = 0.8,
                             labels = list(
                               at = brks$brks[2:(length(brks$brks) - 1)],
                               labels = round(brks$brks,2)[2:(length(brks$brks) - 1)]
                             ), space = "bottom"),
             par.settings = list(strip.background = list(col = "white")))
plot(p1)



# write rasters as geotiff files
for (i in 1:nlayers(r.multi2)) {
  writeRaster(r.multi2[[i]], paste0("geotiff/",names(r.multi2)[i],"_2009_2018.tif"), overwrite = T)
}

for (i in 1:nlayers(r.multi)) {
  writeRaster(r.multi[[i]], paste0("geotiff/",names(r.multi)[i],"_1980_2018.tif"), overwrite = T)
}


# write kml files
setwd("/Users/alexandrudumitrescu/Documents/clima/2019/foss4g/kml")

for (i in 1:nlayers(r.multi2)) {

  suppressMessages(
    plotKML(r.multi2[[i]], z.lim = c(0,400), colour_scale = SAGA_pal[[1]], alpha = 0.7,
        file.name = paste0(names(r.multi2)[i],"_2009_2018.kml"),
        open.kml = F, verbose = F)
  )
}

for (i in 1:nlayers(r.multi)) {
  
plotKML(r.multi[[i]], z.lim = c(0,400), colour_scale = SAGA_pal[[1]], alpha = 0.7,
        file.name = paste0(names(r.multi2)[i],"_1980_2018.kml"),
        open.kml = F)
}
