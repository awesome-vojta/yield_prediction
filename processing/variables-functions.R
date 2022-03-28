##########################
###  STATIC VARIABLES  ###
##########################

ITP_DIST  <- 0    # distance from last yield measuring point
ITP_SWATH <- 1 # swath width (combine gathering)
ITP_YIELD <- 2 # total yield mass
ITP_MOIST <- 3   # yield moist level
ITP_ELEV  <- 4    # above sea level altitude

EVI_INDEX  <- "EVI"
NDVI_INDEX <- "NDVI"

INDEX_CLIP_FOLDER  <- "processing/out/"
FILTERED_FOLDER    <- "processing/cache/"
INTERPOLATE_FOLDER <- "processing/cache/"
MASK_FOLDER        <- "processing/in/"
CLIP_FOLDER        <- "processing/out/"
ALIGNED_FOLDER     <- "processing/cache/"

A_EVI  <- "processing/in/a_EVI.tif"
S_EVI  <- "processing/in/s_EVI.tif"
A_NDVI <- "processing/in/a_NDVI.tif"
S_NDVI <- "processing/in/s_NDVI.tif"

###################
###  FUNCTIONS  ###
###################

get_file_name <- function(filepath) {
  return (sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(filepath)))
}

#' Filters input points according to entered quantile
#' Upper and lower bound is calculated from quantile
#' Bounds are
#' Points above and below bounds are removed
filter_all_point_attributes <- function (shapefile, quant) {
  shp <- st_read(shapefile, quiet = TRUE)
  shp$Crop      <- NULL
  shp$SECTIONID <- NULL
  shp$Time      <- NULL
  shp$Heading   <- NULL
  shp$Variety   <- NULL
  shp$IsoTime   <- NULL
  shp$Machine   <- NULL
  shp$WetMass   <- NULL

  above <- 1.00 - (quant/100)
  below <- 0.00 + (quant/100)
  y_below <- quantile(shp$VRYIELDMAS, probs = below)[[1]]
  y_above <- quantile(shp$VRYIELDMAS, probs = above)[[1]]
  m_below <- quantile(shp$Moisture,   probs = below)[[1]]
  m_above <- quantile(shp$Moisture,   probs = above)[[1]]
  s_below <- quantile(shp$SWATHWIDTH, probs = below)[[1]]
  d_below <- quantile(shp$DISTANCE,   probs = below)[[1]]

  points <- shp[shp$VRYIELDMAS < y_above & shp$VRYIELDMAS > y_below &
                shp$Moisture   < m_above & shp$Moisture   > m_below &
                                           shp$SWATHWIDTH > s_below &
                                           shp$DISTANCE   > d_below, ]

  file_name <- get_file_name(shapefile)
  out_path <- paste0(FILTERED_FOLDER, file_name, "_", below * 100, "_", above * 100, ".shp")
  st_write(points, out_path, append=FALSE)

  per <- round((1 - (nrow(points) / nrow(shp)) ) * 100,1)
  writeLines(paste0(" # ", per,"% filtered from ", file_name))

  return(out_path)
}

#' Algorithm interpolates inputted variable, stripping all others from dataset
#' Output is ".tif" raster file with smoothed out variable on 3x3 grid
interpolate_point_layer <- function(srcfile, itp_attribute) {
  stopifnot(itp_attribute == ITP_DIST || itp_attribute == ITP_SWATH ||
            itp_attribute == ITP_YIELD || itp_attribute == ITP_MOIST || itp_attribute == ITP_ELEV)

  if(itp_attribute == ITP_DIST)  str_attribute <- "dist"
  if(itp_attribute == ITP_SWATH) str_attribute <- "swat"
  if(itp_attribute == ITP_YIELD) str_attribute <- "yield"
  if(itp_attribute == ITP_MOIST) str_attribute <- "moist"
  if(itp_attribute == ITP_ELEV)  str_attribute <- "elev"

  layer_number <- 0
  type <- 0
  file_name <- get_file_name(srcfile)
  out_path <- paste0(INTERPOLATE_FOLDER, file_name, "_itp_", str_attribute, ".shp")
  writeLines(paste0(" # ", " interpolating ", file_name," -> ", out_path))
  qgis_run_algorithm(
    "qgis:tininterpolation",
    INTERPOLATION_DATA = paste(srcfile, layer_number, itp_attribute, type, sep = "::~::"),
    METHOD = 0,
    EXTENT = srcfile,
    PIXEL_SIZE = 3,
    OUTPUT = out_path,
    .quiet = TRUE
  )
  return(out_path)
}


#' Func concaves-back interpolated convex hulls
#' Concave masks are required for clipping interpolated layers
create_mask_from_points <- function(file, alpha) {
  file_name <- get_file_name(file)
  out_path <- paste0(MASK_FOLDER, file_name, "_", "mask.shp")
  
  res <- qgis_run_algorithm(
    "qgis:concavehull",
    INPUT = file,
    ALPHA = alpha,
    HOLES = FALSE,
    OUTPUT = out_path,
    MULTITHREADING = TRUE
  )
  return(out_path)
}


# Algorithm returns .tif file!
clip_interpolated <- function(file, mask) {
  file_name <- get_file_name(file)
  out_path <- paste0(CLIP_FOLDER, file_name, "_", "clip.tif")
  
  clip_by_mask(input = file, mask = mask, output = out_path)
  return(out_path)
}



#' Aligns layer onto reference-layer depending on layers prefix
#' @param layer to be aligned
align_layer <- function(layer) {
  file_name <- get_file_name(layer)
  out_path <- paste0(ALIGNED_FOLDER, file_name, "_", "aligned.tif")
  
  anchor <- ""
  if(startsWith(file_name, "a_") | startsWith(file_name, "fm_a_")) {
    anchor <- A_NDVI
  }
  else if(startsWith(file_name, "s_") | startsWith(file_name, "fm_s_")) {
    anchor <- S_NDVI
  }
  else { return(NULL) }


  writeLines(paste0(" # ", " aligning ", file_name," -> ", out_path))
  gdalUtils::align_rasters(
    unaligned = layer,
    reference = anchor,
    dstfile = out_path,
    overwrite = TRUE
  )
  return(out_path)
}

#' Aligns layer onto reference-layer depending on layers prefix
#' @param mask mask of field for which NDVI should be generated (clipped-out)
get_clipped_NDVI <- function(mask) {
  mask_name <- get_file_name(mask)

  src_file <- ""
  if(startsWith(mask_name, "a_") | startsWith(mask_name, "fm_a_")) {
    src_file <- A_NDVI
  } else if (startsWith(mask_name, "s_") | startsWith(mask_name, "fm_s_")){
    src_file <- S_NDVI
  }

  out_path <- paste0(INDEX_CLIP_FOLDER, mask_name, "_", "NDVI.tif")
  clip_by_mask(input = src_file, mask = mask, output = out_path)
  return(out_path)
}


#' Aligns layer onto reference-layer depending on layers prefix
#' @param mask mask of field for which EVI should be generated (clipped-out)
get_clipped_EVI <- function(mask) {
  mask_name <- get_file_name(mask)

  src_file <- ""
  if(startsWith(mask_name, "a_") | startsWith(mask_name, "fm_a_")) {
    src_file <- A_EVI
  } else if(startsWith(mask_name, "s_") | startsWith(mask_name, "fm_s_")) {
    src_file <- S_EVI
  }
  
  out_path <- paste0(INDEX_CLIP_FOLDER, mask_name, "_", "EVI.tif")
  clip_by_mask(input = src_file, mask = mask, output = out_path)
  return(out_path)
}


#' Clips input layer according to a mask
clip_by_mask <- function(input, output, mask) {
  writeLines(paste0(" # ", " clipping ", input," -> ", output))
  res <- qgis_run_algorithm(
    "gdal:cliprasterbymasklayer",
    INPUT  = input,
    MASK   = mask,
    OUTPUT = output,
    .quiet = TRUE
  )
}