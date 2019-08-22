library(raster)
library(rnaturalearth)
library(classInt)
library(RColorBrewer)

# prepare the layer with world borders
countries <- ne_countries(scale = 110, type = "countries")
countries.line <- as(countries, "SpatialLines")
countries.sp <- list("sp.lines", countries.line, col = "#525252",lwd = 1)

# load seasonal data
r.seas <- brick("nc/ghi_seasons_1981_2018.nc")


# extract season from name
season <- sort(unique(substr(names(r.seas),7,8)))

# compute multianual mean for each season
r.multi <- stack()

for (i in season) { 
  
  r.multi <- addLayer(r.multi, mean(r.seas[[which(substr(names(r.seas),7,8) %in% i)]]))
}

names(r.multi) <- c("DJF","MAM", "JJA", "SON")
r.multi[] <- round(getValues(r.multi), 1)

# # check range of values
# summary(brick(r.multi))
# find the preaks with pretty
brks <- classIntervals(as.vector(getValues(r.multi)), n = 9, style = "pretty")
cols <- colorRampPalette(brewer.pal(length(brks$brks),"YlOrRd"))


p1 <- spplot(r.multi, sp.layout = list(countries.sp), scales = list(draw = TRUE, cex = 0.8),
             col.regions = cols,cuts = length(brks$brks) - 1,at = brks$brks,
             colorkey = list(height = 0.8,
                             labels = list(
                               at = brks$brks[2:(length(brks$brks) - 1)],
                               labels = round(brks$brks,2)[2:(length(brks$brks) - 1)]
                             ), space = "bottom"),
             par.settings = list(strip.background = list(col = "white")))
plot(p1)
