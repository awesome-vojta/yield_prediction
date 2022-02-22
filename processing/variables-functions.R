### STATIC VARIABLES ###

BELOW <- 4
ABOVE <- 5

FLT_DIST <- "DISTANCE"    # distance from last yield measuring point
FLT_SWATH <- "SWATHWIDTH" # swath width (combine gathering)
FLT_YIELD <- "VRYIELDMAS" # total yield mass
FLT_MOIST <- "Moisture"   # yield moist level
FLT_ELEV <- "Elevation"    # above sea level altitude

ITP_DIST <- 0    # distance from last yield measuring point
ITP_SWATH <- 1 # swath width (combine gathering)
ITP_YIELD <- 2 # total yield mass
ITP_MOIST <- 5   # yield moist level
ITP_ELEV <- 8    # above sea level altitude

INDEX_CLIP_FOLDER  <- "processing/04_indices_clipped/"
FILTERED_FOLDER    <- "processing/05_filtered/"
INTERPOLATE_FOLDER <- "processing/06_interpolated/"
MASK_FOLDER        <- "processing/07_masks/"
CLIP_FOLDER        <- "processing/08_clip/"
ALIGNED_FOLDER     <- "processing/09_aligned/"

A_EVI           <- "processing/03_indices/a_EVI.tif"
S_EVI           <- "processing/03_indices/s_EVI.tif"
A_NDVI          <- "processing/03_indices/a_NDVI.tif"
S_NDVI          <- "processing/03_indices/s_NDVI.tif"

### FUNCTIONS ###

get_file_name <- function(filepath) {
  return (
    sub(
      pattern = "(.*)\\..*$",
      replacement = "\\1",
      basename(filepath)
    )
  )
}

filter_points <- function (attribute, method, percent, shapefile) {
  return(
    saga$shapes_points$points_filter(
      radius = 100, minnum = 20, maxnum = 250, method = method,   # 4 = remove BELOW percentile, 5 = remove ABOVE percentile
      field = attribute,
      points = shapefile,
      percent = percent
    )
  )
}

filter_all_point_attributes <- function (shapefile, below_percentile, above_percentile) {
  file_name <- get_file_name(shapefile)
  print(file_name)
  points <- filter_points(FLT_YIELD, BELOW, below_percentile, shapefile)
  points <- filter_points(FLT_YIELD, ABOVE, above_percentile, points)
  points <- filter_points(FLT_MOIST, BELOW, below_percentile, points)
  points <- filter_points(FLT_MOIST, ABOVE, above_percentile, points)
  points <- filter_points(FLT_SWATH, BELOW, below_percentile, points)
  points <- filter_points(FLT_DIST, BELOW, below_percentile, points)

  out_path <- paste(FILTERED_FOLDER, file_name, "_", below_percentile, "_", above_percentile, ".shp", sep="")
  st_write(points, out_path, append=FALSE)
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
  file_name <- sub(pattern = "(.*)\\..*$",
                   replacement = "\\1",
                   basename(srcfile)
  )
  out_path <- paste(INTERPOLATE_FOLDER, file_name, "_itp_", str_attribute ,".shp", sep="")
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
  out_path <- paste(MASK_FOLDER, file_name, "_", "mask.shp", sep="")
  
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
  out_path <- paste(CLIP_FOLDER, file_name, "_", "clip.tif", sep="")
  
  clip_by_mask(input = file, mask = mask, output = out_path)
  return(out_path)
}




align_layer <- function(layer) {
  print(layer)
  file_name <- get_file_name(layer)
  out_path <- paste(ALIGNED_FOLDER, file_name, "_", "aligned.tif", sep="")
  
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

fm_align_layer <- function(layer) {
  print(layer)
  file_name <- get_file_name(layer)
  out_path <- paste(ALIGNED_FOLDER, file_name, "_", "aligned.tif", sep="")

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



get_clipped_NDVI <- function(mask) {
  mask_name <- get_file_name(mask)
  
  src_file <- ""
  if(startsWith(mask_name, "a_")) {
    src_file <- A_NDVI
  } else { 
    src_file <- S_NDVI
  }

  out_path <- paste(INDEX_CLIP_FOLDER, mask_name, "_", "NDVI.tif", sep="")
  clip_by_mask(input = src_file, mask = mask, output = out_path)
  return(out_path)
}

get_clipped_EVI <- function(mask) {
  mask_name <- get_file_name(mask)
  src_file <- ""
  if(startsWith(mask_name, "a_")) {
    src_file <- A_EVI
  } else { 
    src_file <- S_EVI
  }
  
  out_path <- paste(INDEX_CLIP_FOLDER, mask_name, "_", "EVI.tif", sep="")
  clip_by_mask(input = src_file, mask = mask, output = out_path)
  return(out_path)
}

fm_get_clipped_NDVI <- function(mask) {
  mask_name <- get_file_name(mask)

  src_file <- ""
  if(startsWith(mask_name, "fm_a_")) {
    src_file <- A_NDVI
  } else {
    src_file <- S_NDVI
  }

  out_path <- paste(INDEX_CLIP_FOLDER, mask_name, "_", "NDVI.tif", sep="")
  clip_by_mask(input = src_file, mask = mask, output = out_path)
  return(out_path)
}

fm_get_clipped_EVI <- function(mask) {
  mask_name <- get_file_name(mask)
  src_file <- ""
  if(startsWith(mask_name, "fm_a_")) {
    src_file <- A_EVI
  } else {
    src_file <- S_EVI
  }

  out_path <- paste(INDEX_CLIP_FOLDER, mask_name, "_", "EVI.tif", sep="")
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