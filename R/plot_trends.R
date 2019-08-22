library(raster)
library(rnaturalearth)
library(RColorBrewer)
library(lattice)




countries <- ne_countries(scale = 110, type = "countries")
countries.line <- as(countries, "SpatialLines")
countries.sp <- list("sp.lines", countries.line, col = "#525252",lwd = 1)



# plot Winter trends
mk.winter <- readRDS("RData/ghi_trends_01.rds")
# # check the range
# summary(mk.winter)

# process p-values and significance levels
p.winter <- mk.winter[[2]]
p.winter[p.winter > .05 | p.winter < -.05] <- NA
p.winter <- rasterToPoints(p.winter, spatial = T)
signif.winter <- list("sp.points", p.winter, col = "#525252",pch = 15, cex = 0.1, alpha = 0.1, which = 1)

# plot  Spring trends
 mk.spring <- readRDS("RData/ghi_trends_04.rds")

# process p-values and significance levels
# Trends in annual thermal indices of extreme in the Carpathians. The grid cells presenting significant
# increasing (decreasing) trends at 95 % level (two tailed) are in red (blue)
p.spring <- mk.spring[[2]]
p.spring[p.spring > .05 | p.spring < -.05] <- NA
p.spring <- rasterToPoints(p.spring, spatial = T)
signif.spring <- list("sp.points", p.spring, col = "#525252",pch = 15, cex = 0.1, alpha = 0.1, which = 2)


# plot Summer trends
mk.summer <- readRDS("RData/ghi_trends_07.rds")
p.summer <- mk.summer[[2]]
p.summer[p.summer > .05 | p.summer < -.05] <- NA
p.summer <- rasterToPoints(p.summer, spatial = T)
signif.summer <- list("sp.points", p.summer, col = "#525252",pch = 15, cex = 0.1, alpha = 0.1, which = 3)


# plot Fall trends
mk.fall <- readRDS("RData/ghi_trends_10.rds")
p.fall <- mk.fall[[2]]
p.fall[p.fall > .05 | p.fall < -.05] <- NA
p.fall <- rasterToPoints(p.fall, spatial = T)
signif.fall <- list("sp.points", p.fall, col = "#525252",pch = 15, cex = 0.1, alpha = 0.1, which = 4)

signif.lists <- list(signif.winter, signif.spring, signif.summer, signif.winter)


# create raster stack with slopes for al seasons
slopes <- brick(mk.winter[[1]], mk.spring[[1]], mk.summer[[1]], mk.fall[[1]])
names(slopes) <- c("DJF", "JJA", "MAM", "SON")

# # check range of values
# summary(slopes)
brks <- seq(-1.4,1.3, 0.2)
# color pallete from red to blue
bls <- colorRampPalette(brewer.pal(6,"Blues")[1:5])
rds <- colorRampPalette(brewer.pal(6,"YlOrRd")[1:5])
cols <- c(rev(bls(8)), rds(6))

p1 <- spplot(slopes,
             sp.layout = list(countries.sp, signif.fall, signif.summer, signif.spring,signif.winter),
             scales = list(draw = TRUE, cex = 0.8),
             col.regions = cols,cuts = length(brks) - 1,at = brks,
             colorkey = list(height = 0.8,
                             labels = list(
                               at = brks[2:(length(brks) - 1)],
                               labels = round(brks,2)[2:(length(brks) - 1)]
                             ), space = "bottom"),
             par.settings = list(strip.background = list(col = "white")))

print(p1)


            



