library(raster)

# function to compute Slope and p values
trend.slope <- function(y) {
  fit <- EnvStats::kendallTrendTest(y ~ 1)
  fit.results <- fit$estimate[2]
  fit.results <- c(fit.results, fit$p.value)
  return(fit.results)
}

# read seasonal means
r <- brick("nc/ghi_seasons_1981_2018.nc")

mid.seasons <- c("04", "07", "10", "01")

# it takes about 20 min
for (i in 1:length(mid.seasons)) {
  print(mid.seasons[i])
  # subset for each season
  r.seasons <- r[[which(substr(names(r),7,8) == mid.seasons[i])]]
  
  # compute trend in parallel (8 threads)
  beginCluster(n = 8)
  # system.time(
  ghi.trend.parallel <- clusterR(r.seasons , calc, args = list(fun = trend.slope))
  # )
  endCluster()
  
  names(ghi.trend.parallel) <- c("slope", "p.value")
  
  # write raster brick as R objects
  saveRDS(ghi.trend.parallel, file = paste0("RData/ghi_trends_",mid.seasons[i], ".rds"))
  #plot(ghi.trend.parallel)
}

# # verify with spatialEco function
# r.logo <- stack(system.file("external/rlogo.grd", package="raster"),
#                 system.file("external/rlogo.grd", package="raster"),
#                 system.file("external/rlogo.grd", package="raster")) 
# trend.eco <- spatialEco::raster.kendall(r.logo, tau = TRUE, intercept = TRUE,  p.value = TRUE, z.value = TRUE, confidence = TRUE)
# 
# plot(ghi.trend.parallel)
# plot(trend.eco[[c(1,4)]])
# 
# plot(trend.eco[[c(1,4)]] - ghi.trend.parallel)


