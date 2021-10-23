library(raster)
library(ggplot2)

#setwd(getSrcDirectory()[1])
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

ndvi <- raster("data\\NDVI_noextent.tif")
evi <- raster("data\\EVI_noextent.tif")
yield <- raster("data\\yield_noextent.tif")


evi_df <- as.data.frame(evi, xy = TRUE)
str(evi_df)
ggplot() +
  geom_raster(data = evi_df , aes(x = x, y = y, fill = EVI_noextent)) +
  scale_fill_viridis_c() +
  coord_quickmap()

ndvi_df <- as.data.frame(ndvi, xy = TRUE)
str(ndvi_df)
ggplot() +
  geom_raster(data = ndvi_df , aes(x = x, y = y, fill = NDVI_noextent)) +
  scale_fill_viridis_c() +
  coord_quickmap()


yield_df <- as.data.frame(yield, xy = TRUE)
str(yield_df)
ggplot() +
  geom_raster(data = yield_df , aes(x = x, y = y, fill = yield_noextent)) +
  scale_fill_viridis_c() +
  coord_quickmap()

#####
# zavislost vynosu na indexu NDVI
yield_values <- unlist(yield_df["yield_noextent"])
ndvi_values <- unlist(ndvi_df["NDVI_noextent"])


yield_on_NDVI = data.frame(cbind(yield_values, ndvi_values))

plot(
  yield_values ~ ndvi_values,
  yield_on_NDVI
)

summary(
  lm(
    formula = yield_values ~ ndvi_values,
    data = yield_on_NDVI
  )
)

abline(
  lm(
    formula = yield_values ~ ndvi_values,
    data = yield_on_NDVI
  ),
  col = "red"
)

#####
# zavislost vynosu na indexu EVI
evi_values <- unlist(evi_df["EVI_noextent"])


yield_on_EVI = data.frame(cbind(yield_values, evi_values))

plot(
  yield_values ~ evi_values,
  lm_data
)

summary(
  lm(
    formula = yield_values ~ evi_values,
    data = yield_on_EVI
  )
)

#####
# zavislost indexu NDVI na indexu EVI
NDVI_on_EVI = data.frame(cbind(ndvi_values, evi_values))

plot(
  ndvi_values ~ evi_values,
  NDVI_on_EVI
)

abline(
  lm(
    formula = ndvi_values ~ evi_values,
    data = NDVI_on_EVI
  ),
  col = "red"
)

summary(
  lm(
    formula = ndvi_values ~ evi_values,
    data = NDVI_on_EVI
  )
)



