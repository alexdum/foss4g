library(raster)
library(ggplot2)


# anual file
r.an <- brick("nc/ghi_annual_1980_2018.nc")
# crop the data for Europe
# across the longitude range -35°E to 60°E and latitude range 35°N to 72°N
r.ancrop <- crop(r.an, extent(-35,60,35,72))
# compute zonals mean
z.anmean <- cellStats(r.ancrop, stat = mean)
# create data frame (table for ploting)
df.anmean <- data.frame(season = substr(names(z.anmean), 7,8), 
                      date = as.Date(paste0(substr(names(z.anmean), 2,5),"-01-01")),
                      ghi = z.anmean, stringsAsFactors = F)
df.anmean$season <- "Annual"
df.anmean$anom <- df.anmean$ghi - mean(df.anmean$ghi)

# seasonal file
r <- brick("nc/ghi_seasons_1981_2018.nc")
r <- r[[-nlayers(r)]]
# crop the data for Europe
r.crop <- crop(r, extent(-35,60,35,72))
# compute zonals mean
z.mean <- cellStats(r.crop, stat = mean)

# create data frame (table for ploting)
df.mean <- data.frame(season = substr(names(z.mean), 7,8), 
                      date = as.Date(paste0(substr(names(z.mean), 2,5),"-01-01")),
                      ghi = z.mean, stringsAsFactors = F)


# rename season
df.mean$season[df.mean$season == "01"] <- "DJF"
df.mean$season[df.mean$season == "04"] <- "MAM"
df.mean$season[df.mean$season == "07"] <- "JJA"
df.mean$season[df.mean$season == "10"] <- "SON"

# comnpute anomalies relative to the mean
df.mean$anom[df.mean$season == "DJF"] <- df.mean$ghi[df.mean$season == "DJF"] - mean(df.mean$ghi[df.mean$season == "DJF"])
df.mean$anom[df.mean$season == "MAM"] <- df.mean$ghi[df.mean$season == "MAM"] - mean(df.mean$ghi[df.mean$season == "MAM"])
df.mean$anom[df.mean$season == "JJA"] <- df.mean$ghi[df.mean$season == "JJA"] - mean(df.mean$ghi[df.mean$season == "JJA"])
df.mean$anom[df.mean$season == "SON"] <- df.mean$ghi[df.mean$season == "SON"] - mean(df.mean$ghi[df.mean$season == "SON"])


# combine the final file for plotting
df.final <- rbind(df.anmean, df.mean)

library(ggplot2)
ggplot(df.anmean, aes(date, anom, group = season, 
                  color = season)) +
  geom_line(size = 1, alpha = 0.8) +
  geom_point(size = 2) +
  scale_colour_manual(values = c("black","#3182bd", "#800026","#feb24c", "#addd8e")) +
  xlab("Year") +
  ylab(bquote('Anomaly GHI ['*'W ·'~m^-2*']')) 

