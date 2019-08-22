library(raster)

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

spplot(r.multi)

