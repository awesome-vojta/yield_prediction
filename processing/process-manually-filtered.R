library(sf)
library(raster)
library(Rsagacmd)
library(qgisprocess)

options(qgisprocess.path = "C:/Program Files/QGIS 3.16.11/bin/qgis_process-qgis-ltr.bat")
options(Rsagacmd.path = "C:/dev/saga-8.0.1_x64/saga_cmd.exe")
qgis_configure()
saga <- saga_gis(saga_bin = "C:/dev/saga-8.0.1_x64/saga_cmd.exe")
setwd("C:/Users/vojte/Documents/01_VSE/00_baka/05_r_proj")

source(file = "processing/variables-functions.R")


### DATA PREPARATION ###
yield_points_files <- c(
  "processing/filtered_manually/fm_a_dilec.shp",
  "processing/filtered_manually/fm_a_mrazirna.shp",
  "processing/filtered_manually/fm_a_padelek.shp",
  "processing/filtered_manually/fm_a_pod_vysokou.shp",
  "processing/filtered_manually/fm_a_vysoka.shp",
  "processing/filtered_manually/fm_a_za_jamou.shp",
  "processing/filtered_manually/fm_s_1.shp",
  "processing/filtered_manually/fm_s_3.shp",
  "processing/filtered_manually/fm_s_4.shp"
)

# TODO: mask was created in QGIS based on fm_ file, consider making mask out of [filtered_point_files]
#  -> percentile filtering may cause 'holes'
masks <- c(
  "processing/filtered_manually/fm_a_dilec_mask.shp",
  "processing/filtered_manually/fm_a_mrazirna_mask.shp",
  "processing/filtered_manually/fm_a_padelek_mask.shp",
  "processing/filtered_manually/fm_a_pod_vysokou_mask.shp",
  "processing/filtered_manually/fm_a_vysoka_mask.shp",
  "processing/filtered_manually/fm_a_za_jamou_mask.shp",
  "processing/filtered_manually/fm_s_1_mask.shp",
  "processing/filtered_manually/fm_s_3_mask.shp",
  "processing/filtered_manually/fm_s_4_mask.shp"
)


### PROCESSING CHAIN ###
# 1) filter each .shp
filtered_point_files <- lapply(
  yield_points_files,
  filter_all_point_attributes,
  quant = 20
)

# 2) interpolate each .shp
yield_points_files_interpolated <- lapply(
  filtered_point_files,
  interpolate_point_layer,
  pixel_size=3
)
plot(raster(yield_points_files_interpolated[[1]]))

# 3) convert interpolated onto 10m
# use the big indices_p
# big indices_p -> big overall pic
aligned <- lapply(yield_points_files_interpolated, fm_align_layer)
plot(raster(aligned[[3]]))

# 4) cut interpolated 10m layers
df_to_clip <- data.frame(layer = unlist(aligned), mask = masks)
interpolated_clipped <- apply(
  df_to_clip, 1,
  function(x) clip_interpolated(x[1], x[2])
)
plot(raster(interpolated_clipped[[9]]))

# 5) cut 10m indices_p
clipped_EVIs <- lapply(masks, fm_get_clipped_EVI)
plot(raster(clipped_EVIs[[4]]))
clipped_NDVIs <- lapply(masks, fm_get_clipped_NDVI)
plot(raster(clipped_NDVIs[[4]]))









