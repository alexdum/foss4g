library(raster)

# load seasonal data
r.seas <- brick("nc/ghi_seasons_1981_2018.nc")


# extract index for eac seasons
r.seas <- setZ(r.seas, as.Date(substr(names(r.seas),2,11), format = "%Y.%m.%d"))
# compute multianual means

index <- as.integer(substr(names(r.seas),7,8))
r.seas.mean <- stackApply(r.seas,index, fun = mean)
plot(r.seas.mean)

show(crop(r.seas.mean)


r <- brick("~/Downloads/ghi_1980_2018.nc")

plot(mean(r[[4:6]])-r.seas[[2]] )


round(summary((mean(r[[4:7]])-r.seas[[2]] )))
