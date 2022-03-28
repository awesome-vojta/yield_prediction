library(sf)
library(qgisprocess)
library(raster)

options(qgisprocess.path = "C:/Program Files/QGIS 3.16.11/bin/qgis_process-qgis-ltr.bat")
qgis_configure()
setwd("C:/Users/vojte/Documents/01_VSE/00_baka/05_r_proj")
source(file = "processing/variables-functions.R")


# alpha_per_file <- c(0.03,0.03,0.05,0.03,0.03,0.03,0.1,0.1,0.03,0.03)
# files_and_alphas <- data.frame(layer = yield_points_files, alpha = alpha_per_file)
# masks <- apply(files_and_alphas, 1, function(x) create_mask_from_points(x[1], x[2]))


### PROCESSING CHAIN ###

#' Main preprocessing function
#' Filter -> Interpolate -> Align -> Clip -> Generate indices
#' @param points list of layers comprised of datapoints with proper CRS
#' @param masks list of masks (points outlines)
#' @param flt_quant quantile for determining Upper and Lower filtering bounds
#' @param itp_attribute variable according to which should the interpolation algo interpolate
preprocess <- function(points, flt_quant, itp_attribute) {

  # 1) filter each .shp
    filtered_point_files <- lapply(
      X = points,
      FUN = filter_all_point_attributes,
      quant = flt_quant
    )

  # 2) interpolate each .shp
  yield_points_files_interpolated <- lapply(
    X = filtered_point_files,
    FUN = interpolate_point_layer,
    itp_attribute = itp_attribute #ITP_DIST, ITP_SWATH, ITP_YIELD, ITP_MOIST, ITP_ELEV,
    )

  # 3) convert interpolated onto 10m
  # use the big indices_p
  # big indices_p -> big overall pic
  aligned <- lapply(X = yield_points_files_interpolated, FUN = align_layer)


  # 3b) masks
  alpha_per_file <- c(0.03,0.03,0.05,0.03,0.03,0.03,0.1,0.1,0.03)
  files_and_alphas <- data.frame(layer = unlist(filtered_point_files), alpha = alpha_per_file)
  masks <- apply(files_and_alphas, 1, function(x) create_mask_from_points(x[1], x[2]))


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
}
