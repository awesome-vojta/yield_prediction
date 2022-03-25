# Input: CRS synced data from grain yield monitor
# Processing:
#   1) filtering by given percentile
#   2) interpolating (points to squares) points onto

library(sf)
library(Rsagacmd)
library(qgisprocess)

# in order to use QGIS functions, QGIS has to be installed
# and the path to its qgis_process file has to be specified
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

alpha_per_file <- c(0.03,0.03,0.05,0.03,0.03,0.03,0.1,0.1,0.03,0.03)

files_and_alphas <- data.frame(layer = yield_points_files, alpha = alpha_per_file)
# masks <- apply(files_and_alphas, 1, function(x) create_mask_from_points(x[1], x[2]))
masks <- c(
  "processing/07_masks/a_dilec_mask.shp",
  "processing/07_masks/a_dolni_dil_mask.shp",
  "processing/07_masks/a_mrazirna_mask.shp",
  "processing/07_masks/a_padelek_mask.shp",
  "processing/07_masks/a_pod_vysokou_mask.shp",
  "processing/07_masks/a_vysoka_mask.shp",
  "processing/07_masks/a_za_jamou_mask.shp",
  "processing/07_masks/s_1_mask.shp",
  "processing/07_masks/s_3_mask.shp",
  "processing/07_masks/s_4_mask.shp"
)


### PROCESSING CHAIN ###

# 1) filter each .shp
filtered_point_files <- lapply(
  X = yield_points_files,
  FUN = filter_all_point_attributes,
  quant = 5
)

# 2) interpolate each .shp
yield_points_files_interpolated <- lapply(
  X = filtered_point_files,
  FUN = interpolate_point_layer,
  str_attribute = "yield" # "dist", "swat", "yield", "moist", "elev"
)

# 3) convert interpolated onto 10m
# use the big indices_p
# big indices_p -> big overall pic
aligned <- lapply(X = yield_points_files_interpolated, FUN = align_layer)

# 4) cut interpolated 10m layers
df_to_clip <- data.frame(layer = unlist(aligned), mask = masks)
interpolated_clipped <- apply(
  X = df_to_clip,
  MARGIN = 1,
  FUN = function(x) clip_interpolated(x[1], x[2])
)

# 5) cut 10m indices_p
clipped_EVIs <- lapply(X = masks, FUN = get_clipped_EVI)
clipped_NDVIs <- lapply(X = masks, FUN = get_clipped_NDVI)









