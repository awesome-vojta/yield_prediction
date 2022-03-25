### STATIC VARIABLES ###

ITP_DIST  <- 0    # distance from last yield measuring point
ITP_SWATH <- 1 # swath width (combine gathering)
ITP_YIELD <- 2 # total yield mass
ITP_MOIST <- 6   # yield moist level
ITP_ELEV  <- 8    # above sea level altitude

INDEX_CLIP_FOLDER  <- "processing/04_indices_clipped/"
FILTERED_FOLDER    <- "processing/05_filtered/"
INTERPOLATE_FOLDER <- "processing/06_interpolated/"
MASK_FOLDER        <- "processing/07_masks/"
CLIP_FOLDER        <- "processing/08_clip/"
ALIGNED_FOLDER     <- "processing/09_aligned/"

A_EVI  <- "processing/03_indices/a_EVI_corr.tif"
S_EVI  <- "processing/03_indices/s_EVI_corr.tif"
A_NDVI <- "processing/03_indices/a_NDVI.tif"
S_NDVI <- "processing/03_indices/s_NDVI.tif"

### FUNCTIONS ###

get_file_name <- function(filepath) {
  return (sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(filepath)))
}


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
  print(paste0(per,"% filtered from ", file_name))

  return(out_path)
}


interpolate_point_layer <- function(srcfile, str_attribute) {
  stopifnot(str_attribute == "dist" || str_attribute == "swat" ||
            str_attribute == "yield" || str_attribute == "moist" || str_attribute == "elev")
  itp_attribute <- switch(
    str_attribute,
    "dist"  = ITP_DIST,
    "swat"  = ITP_SWATH,
    "yield" = ITP_YIELD,
    "moist" = ITP_MOIST,
    "elev"  = ITP_ELEV
  )

  layer_number <- 0
  type <- 0
  file_name <- get_file_name(srcfile)
  out_path <- paste0(INTERPOLATE_FOLDER, file_name, "_itp_", str_attribute, ".shp")
  qgis_run_algorithm(
    "qgis:tininterpolation",
    INTERPOLATION_DATA = paste(srcfile, layer_number, itp_attribute, type, sep = "::~::"),
    METHOD = 0,
    EXTENT = srcfile,
    PIXEL_SIZE = 3,
    OUTPUT = out_path
  )
  return(out_path)
}


# func concaves-back interpolated convex hulls
# concave masks are required for clipping interpolated layers
create_mask_from_points <- function(file, alpha) {
  file_name <- get_file_name(file)
  out_path <- paste0(MASK_FOLDER, file_name, "_", "mask.shp")
  
  res <- qgis_run_algorithm(
    "qgis:concavehull",
    INPUT = file,
    ALPHA = alpha,
    HOLES = FALSE,
    OUTPUT = out_path
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



# TODO: consolidate
align_layer <- function(layer) {
  print(layer)
  file_name <- get_file_name(layer)
  out_path <- paste0(ALIGNED_FOLDER, file_name, "_", "aligned.tif")
  
  anchor <- ""
  if(startsWith(file_name, "a_")) {
    anchor <- A_NDVI
  } else { 
    anchor <- S_NDVI
  }

  gdalUtils::align_rasters(
    unaligned = layer,
    reference = anchor,
    dstfile = out_path
  )
  return(out_path)
}
# TODO: consolidate
fm_align_layer <- function(layer) {
  print(layer)
  file_name <- get_file_name(layer)
  out_path <- paste0(ALIGNED_FOLDER, file_name, "_", "aligned.tif")

  anchor <- ""
  if(startsWith(file_name, "fm_a_")) {
    anchor <- A_NDVI
  } else {
    anchor <- S_NDVI
  }

  gdalUtils::align_rasters(
    unaligned = layer,
    reference = anchor,
    dstfile = out_path
  )
  return(out_path)
}


# TODO: consolidate
get_clipped_NDVI <- function(mask) {
  mask_name <- get_file_name(mask)
  
  src_file <- ""
  if(startsWith(mask_name, "a_")) {
    src_file <- A_NDVI
  } else { 
    src_file <- S_NDVI
  }

  out_path <- paste0(INDEX_CLIP_FOLDER, mask_name, "_", "NDVI.tif")
  clip_by_mask(input = src_file, mask = mask, output = out_path)
  return(out_path)
}
# TODO: consolidate
get_clipped_EVI <- function(mask) {
  mask_name <- get_file_name(mask)
  src_file <- ""
  if(startsWith(mask_name, "a_")) {
    src_file <- A_EVI
  } else { 
    src_file <- S_EVI
  }
  
  out_path <- paste0(INDEX_CLIP_FOLDER, mask_name, "_", "EVI.tif")
  clip_by_mask(input = src_file, mask = mask, output = out_path)
  return(out_path)
}
# TODO: consolidate
fm_get_clipped_NDVI <- function(mask) {
  mask_name <- get_file_name(mask)

  src_file <- ""
  if(startsWith(mask_name, "fm_a_")) {
    src_file <- A_NDVI
  } else {
    src_file <- S_NDVI
  }

  out_path <- paste0(INDEX_CLIP_FOLDER, mask_name, "_", "NDVI.tif")
  clip_by_mask(input = src_file, mask = mask, output = out_path)
  return(out_path)
}
# TODO: consolidate
fm_get_clipped_EVI <- function(mask) {
  mask_name <- get_file_name(mask)
  src_file <- ""
  if(startsWith(mask_name, "fm_a_")) {
    src_file <- A_EVI
  } else {
    src_file <- S_EVI
  }

  out_path <- paste0(INDEX_CLIP_FOLDER, mask_name, "_", "EVI.tif")
  clip_by_mask(input = src_file, mask = mask, output = out_path)
  return(out_path)
}


clip_by_mask <- function(input, output, mask) {
  res <- qgis_run_algorithm(
    "gdal:cliprasterbymasklayer",
    INPUT  = input,
    MASK   = mask,
    OUTPUT = output
  )
}