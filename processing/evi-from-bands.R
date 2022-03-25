library(raster)

blue <- as.data.frame(raster("processing/02_bands_clipped/s_bands/1_B02_10m.tif"), xy=TRUE)
red <- as.data.frame(raster("processing/02_bands_clipped/s_bands/1_B04_10m.tif"), xy=TRUE)
nir <- as.data.frame(raster("processing/02_bands_clipped/s_bands/1_B08_10m.tif"), xy=TRUE)

EVI <- as.data.frame(matrix(nrow = nrow(blue), ncol = 6))
colnames(EVI) <- c("x","y","blue","red","nir","evi")
EVI$x <- blue$x
EVI$y <- blue$y
EVI$blue <- blue$X1_B02/10000
EVI$red <- red$X1_B04/10000
EVI$nir <- nir$X1_B08/10000

EVI$evi <- 2.5 * ((EVI$nir - EVI$red) / (EVI$nir + (6 * EVI$red) - (6.5 * EVI$blue) + 1))

EVI$blue <- NULL
EVI$red <- NULL
EVI$nir <- NULL

r <- rasterFromXYZ(EVI)
r1 <- raster("processing/03_indices/s_EVI.tif")
r1_df <- as.data.frame(r1, xy=TRUE)
crs(r) <- crs(r1)
writeRaster(r, "processing/03_indices/s_EVI_corr.tif")