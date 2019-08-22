tab <- read.table("tabs/rad_network.csv", sep = ";", header = T)

tabf <- NULL
for (i in 1:nrow(tab)) {
  
  era5 <- read.csv(paste0("tabs/daily_era5/", tab$id[i], "_2006_2015.csv"))
  era5$date <- as.Date(era5$date)
  
  bsrn <- read.csv(paste0("tabs/daily_bsrn/", tab$id[i], "_2006_2015.csv"))
  bsrn$date <- as.Date(as.character(bsrn$date), format = "%Y%m%d")
  tab.i <- merge(era5, bsrn, by.x.y = "date")
  names(tab.i)[3] <- "bsrn_ghi"
  tab.i$id <- tab$id[i]
  tab.i$kg_class <- tab$kg_class[i]
  tab.i$kg_code <- tab$kg_code[i]
  
  # add hemisphere
  tab.i$hemisphere <- ifelse(tab$latitude[i] > 0, "Northern hemisphere", "Southern hemisphere")
  
  tabf <- rbind(tabf, tab.i)
}

saveRDS(tabf, file = "RData/ghi_bsrn_era5.RDS")
