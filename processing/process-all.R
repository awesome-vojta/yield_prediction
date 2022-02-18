library(sf)
library(Rsagacmd)
library(qgisprocess)

options(qgisprocess.path = "C:/Program Files/QGIS 3.16.11/bin/qgis_process-qgis-ltr.bat")
options(Rsagacmd.path = "C:/dev/saga-8.0.1_x64/saga_cmd.exe")
qgis_configure()
saga <- saga_gis(saga_bin = "C:/dev/saga-8.0.1_x64/saga_cmd.exe")

setwd("C:/Users/vojte/Documents/01_VSE/00_baka/05_r_proj")
# setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

source(file = "processing/variables-functions.R")


### DATA PREPARATION ###
yield_points_files <- c(
  "processing/01_yield_points/a_dilec.shp",
  "processing/01_yield_points/a_dolni_dil.shp",
  "processing/01_yield_points/a_mrazirna.shp",
  "processing/01_yield_points/a_padelek.shp",
  "processing/01_yield_points/a_pod_vysokou.shp",
  "processing/01_yield_points/a_vysoka.shp",
  "processing/01_yield_points/a_za_jamou.shp",
  "processing/01_yield_points/s_1.shp",
  "processing/01_yield_points/s_3.shp",
  "processing/01_yield_points/s_4.shp"
)
# plot(st_read(yield_points_files[2]))

alpha_per_file <- c(0.03,0.03,0.05,0.03,0.03,0.03,0.1,0.1,0.03,0.03)

files_and_alphas <- data.frame(layer = yield_points_files, alpha = alpha_per_file)
masks <- apply(files_and_alphas, 1, function(x) create_mask_from_points(x[1], x[2]))



### PROCESSING CHAIN ###

# 1) filter each .shp
filtered_point_files <- lapply(
  yield_points_files,
  filter_all_point_attributes,
  below_percentile = 20, above_percentile = 80
)

# 2) interpolate each .shp
yield_points_files_interpolated <- lapply(
  filtered_point_files,
  interpolate_point_layer,
  pixel_size=3
)
plot(raster(yield_points_files_interpolated[[3]]))


# 3) convert interpolated onto 10m
# use the big indices_p
# big indices_p -> big overall pic
aligned <- lapply(yield_points_files_interpolated, align_layer)

# 4) cut interpolated 10m layers
df_to_clip <- data.frame(layer = unlist(aligned), mask = masks)
interpolated_clipped <- apply(
  df_to_clip, 1,
  function(x) clip_interpolated(x[1], x[2])
)

# 5) cut 10m indices_p
clipped_EVIs <- lapply(masks, get_clipped_EVI)
clipped_NDVIs <- lapply(masks, get_clipped_NDVI)









