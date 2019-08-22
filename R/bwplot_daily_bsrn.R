library(lattice)
tab <- read.table("tabs/rad_network.csv", sep = ";", header = T)
tab <- tab[order(tab$latitude, tab$elevation),]

# for (i in 1:nrow(tab)) {
#   
# rad <- read.csv(paste0("../../2017/radiatie/tabele/daily_obs/", gsub('"','',tab$id[i]),"_2006_2015.csv"))
# 
# rad <- data.frame(date = rad$days, ghi = rad$Glob)
# write.csv(rad,paste0("tabs/daily_bsrn/", tab$id[i],"_2006_2015.csv"),
#           row.names = F)
# }

tabf <- NULL
for (i in 1:nrow(tab)) {
  
  tab.i <- read.csv(paste0("tabs/daily_bsrn/", tab$id[i],"_2006_2015.csv"))
  tab.i$id <- tab$id[i]
  tabf <- rbind(tabf, tab.i)
}

tabf$id <- factor(tabf$id, levels = unique(tabf$id))

bwplot(id~ghi, data = tabf, xlab = "GHI (W/m^2)",col = "red",
       par.settings = list(box.rectangle = list(col = "salmon",fill = "salmon",alpha = 0.4),
                           box.umbrella = list(col = "salmon",alpha = 0.4),
                           plot.symbol = list(col = "salmon",alpha = 0.4, pch = 20)))
