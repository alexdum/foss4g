library(seas)
library(Metrics)
library(dplyr)
library(knitr)
library(moments)

# read ERA5 and BSRN date
tab <- readRDS("RData/ghi_bsrn_era5.rds")


# extract KG main climate groups
tab$KG <- substr(tab$kg_class, 1,2)

# compute seasons
tab$season <-  mkseas(x = tab, width = "DJF")


# compute indiccators by kg classes
indicators.kg <- tab %>% group_by(KG) %>% 
  summarise(ME = round(bias(bsrn_ghi, era5_ghi), 3), 
            MAE = round(mae(bsrn_ghi, era5_ghi), 3),
            RMSE = round(rmse(bsrn_ghi, era5_ghi), 3))

# transpose table
ti.kg <- t(indicators.kg[,2:4])
colnames(ti.kg) <- indicators.kg$KG

kable(ti.kg )



# compute indicators by seasons
indicators.seas <- tab %>% group_by(season, hemisphere) %>% 
  summarise(ME = round(bias(bsrn_ghi, era5_ghi), 3), 
            MAE = round(mae(bsrn_ghi, era5_ghi), 3),
            RMSE = round(rmse(bsrn_ghi, era5_ghi), 3))

# transpose table
ti.seas <- t(indicators.seas[,2:5])
colnames(ti.seas) <- indicators.seas$season

kable(ti.seas)

# compute summary statistics by KG classes
tab1 <- data.frame(tab[,c(1,2,4,5,6,7,8)], source = "ERA5")
names(tab1)[2] <- "GHI"
tab2 <- data.frame(tab[,c(1,3,4,5,6,7,8)], source = "BSRN")
names(tab2)[2] <- "GHI"
tabs <- rbind(tab1, tab2)


stats <- tabs %>%  group_by(KG, source) %>% summarise(Mean = mean(GHI), Median = median(GHI), Sd = sd(GHI),Cv = (sd(GHI)/mean(GHI)) * 100,
                                                 Max = max(GHI), Skewness = skewness(GHI), Kurtosis = kurtosis(GHI))
   
stats[,3:8] <- round(stats[,3:8], 3)   
kable(stats)


scatterPlot(tab, x = "era5_ghi", y = "bsrn_ghi", type = "KG", ylab = "BSRN GHI [W/m²]", xlab = "ERA5 GHI [W/m²]",
            linear = T, smooth = T)

