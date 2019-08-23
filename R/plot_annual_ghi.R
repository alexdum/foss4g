library(raster)
library(rnaturalearth)
library(classInt)
library(RColorBrewer)
library(RSAGA)

# prepare the layer with world borders
countries <- ne_countries(scale = 110, type = "countries")
countries.line <- as(countries, "SpatialLines")
countries.sp <- list("sp.lines", countries.line, col = "#525252",lwd = 1)

# load sannual data
r.ann <- brick("nc/ghi_annual_1980_2018.nc")

#average for the all periods
r.p1 <- mean(r.ann)



# compute multianual mean for each season 2009-2018
##selecct rasters for the period of interest
r.p2 <- r.ann[[which(substr(names(r.ann),2,5) >= 2009)]]
r.p2 <- mean(r.p2)

# combine the two files
rf <- brick(r.p1, r.p2)
names(rf) <- c("1980", "2009")
# # check range of values
# summary(brick(r.multi))
# find the preaks with pretty
brks <- classIntervals(as.vector(getValues(r.p2)), n = 14, style = "pretty")
rds <- colorRampPalette(brewer.pal(9,"YlOrRd"))
cols <- rds(length(brks$brks))

p1 <- spplot(rf, sp.layout = list(countries.sp), scales = list(draw = TRUE, cex = 0.8),
             col.regions = cols,cuts = length(brks$brks) - 1,at = brks$brks,
             names.attr = c("1980 - 2018", "2009 - 2018"),
             colorkey = list(height = 0.8,
                             labels = list(
                               at = brks$brks[2:(length(brks$brks) - 1)],
                               labels = round(brks$brks,2)[2:(length(brks$brks) - 1)]
                             ), space = "bottom"),
             par.settings = list(strip.background = list(col = "white")))
plot(p1)



# write rasters as geotiff files
for (i in 1:nlayers(rf)) {
  writeRaster(rf[[i]], paste0("geotiff/Annual_",gsub("X", "",names(rf)[i]),"_2018.tif"), overwrite = T)
}



# write kml files
setwd("/Users/alexandrudumitrescu/Documents/clima/2019/foss4g/kml")

for (i in 1:nlayers(rf)) {
  
plotKML(rf[[i]], z.lim = c(0,320), colour_scale = SAGA_pal[[1]], alpha = 0.7,
        file.name = paste0("Annual_",gsub("X", "",names(rf)[i]),"_2018.kml"),
        open.kml = F)
}
