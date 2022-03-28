library(raster)
# bind_into_df <- function(rasters, value_col_name) {
#
#   # initialize empty df
#   df <- data.frame(double(),double(),double())
#   colnames(df) <- c("x","y", value_col_name)
#
#   # bind
#   for (raster in rasters) {
#     raster_df <- as.data.frame(raster, xy=TRUE)
#     colnames(raster_df) <- c("x","y", value_col_name)
#     no_missing_values <- raster_df[complete.cases(raster_df), ]
#     df <- rbind(df, no_missing_values)
#   }
#   return(df)
# }
#
#
# names <- c("a_dilec","a_mrazirna","a_padelek","a_pod_vysokou","a_vysoka","a_za_jamou","s_1","s_3")
# quants <- c(2.5, 5, 7.5, 10)
# vars <- c("yield", "elev", "moist", "swat", "dist")
# str <- expand.grid(vars, names, quants)
# str$Var4 <- 100-str$Var3
#
# paths <- paste0("processing/out/", str$Var2, "_", str$Var3, "_", str$Var4, "_itp_", str$Var1, "_aligned_clip.tif")
# fm_paths <- paste0("processing/out/fm_", str$Var2, "_", str$Var3, "_", str$Var4, "_itp_", str$Var1, "_aligned_clip.tif")
# evis_paths <- paste0("processing/out/", str$Var2, "_", str$Var3, "_", str$Var4, "_mask_EVI.tif")
# ndvis_paths <- paste0("processing/out/", str$Var2, "_", str$Var3, "_", str$Var4, "_mask_NDVI.tif")
#
# rasters <- lapply(X=paths, FUN=raster)
# fm_rasters <- lapply(X=fm_paths, FUN=raster)
# evi_rasters <- lapply(X=evis_paths, FUN=raster)
# ndvi_rasters <- lapply(X=ndvis_paths, FUN=raster)
#
#
# dfs <- lapply(X=rasters, FUN=as.data.frame)
# df2.5 <- data.frame(double(),double(),double(),double(),double())
# colnames(df) <- vars
# yield_coord <- seq(1,45,5)
# df$yield <- dfs[seq(1, 45, 5)] # po peti do 40
#
#
#
#
# vars <- c("yield", "elev", "moist", "swat", "dist")
# str <- expand.grid(vars, names)
#
#
# names <- c("a_dilec","a_mrazirna","a_padelek","a_pod_vysokou","a_vysoka","a_za_jamou","s_1","s_3")
# y_paths <- paste0("processing/out/", names, "_2.5_97.5_itp_yield_aligned_clip.tif")
# e_paths <- paste0("processing/out/", names, "_2.5_97.5_mask_EVI.tif")
# n_paths <- paste0("processing/out/", names, "_2.5_97.5_mask_NDVI.tif")

get_variable_df <- function(prefix, quant, str_variable) {
  stopifnot(str_variable %in% c("yield", "elev", "moist", "swat", "dist"))
  stopifnot(quant %in% c(2.5, 5, 7.5, 10))
  stopifnot(prefix %in% c("fm_", ""))

  names <- c("a_dilec","a_mrazirna","a_padelek","a_pod_vysokou","a_vysoka","a_za_jamou","s_1","s_3")
  if(prefix != "") {
    names <- paste0(prefix, names)
  }
  paths_list <- paste0("processing/out/", names, "_", quant, "_", 100-quant, "_itp_", str_variable, "_aligned_clip.tif")
  return(df_from_paths(paths_list, str_variable))
}

get_index_df <- function(prefix, quant, index) {
  stopifnot(index %in% c("evi", "ndvi"))
  stopifnot(quant %in% c(2.5, 5, 7.5, 10))
  stopifnot(prefix %in% c("fm_", ""))

  names <- c("a_dilec","a_mrazirna","a_padelek","a_pod_vysokou","a_vysoka","a_za_jamou","s_1","s_3")
  paths_list <- paste0("processing/out/", prefix, names, "_", quant, "_", 100-quant, "_mask_", index, ".tif")
  return(df_from_paths(paths_list, index))
}

df_from_paths <- function(paths_list, colname) {
  colname <- toupper(colname)
  dfs_list <- lapply(X = lapply(X=paths_list, FUN=raster, xy=TRUE), FUN=as.data.frame, xy=TRUE)
  res <- data.frame(double(), double(),double())
  colnames(res) <- c("x","y",colname)
  for(i in seq_along(dfs_list)) {
    colnames(dfs_list[[i]]) <- c("x","y",colname)
    res <- rbind(res, dfs_list[[i]])
  }
  return(res)
}

get_whole <- function(prefix, quant) {
  y <- get_variable_df(prefix, quant, "yield")
  m <- get_variable_df(prefix, quant, "moist")
  el <- get_variable_df(prefix, quant, "elev")
  d <- get_variable_df(prefix, quant, "dist")
  s <- get_variable_df(prefix, quant, "swat")
  ev <- get_index_df(prefix, quant, "evi")
  n <- get_index_df(prefix, quant, "ndvi")

  y$MOIST <- m$MOIST
  y$ELEV <- el$ELEV
  y$DIST <- d$DIST
  y$SWAT <- s$SWAT
  y$EVI <- ev$EVI
  y$NDVI <- n$NDVI
  y <- y[complete.cases(y), ]
  return(y)
}

p_2.5 <- get_whole("", 2.5)
p_5 <- get_whole("", 5)
p_7.5 <- get_whole("", 7.5)
p_10 <- get_whole("", 10)

f_2.5 <- get_whole("fm_", 2.5)
f_5 <- get_whole("fm_", 5)
f_7.5 <- get_whole("fm_", 7.5)
f_10 <- get_whole("fm_", 10)

save(p_2.5, file = "lm/dataframes/p_2.5.Rda")
save(p_5,   file = "lm/dataframes/p_5.Rda")
save(p_7.5, file = "lm/dataframes/p_7.5.Rda")
save(p_10,  file = "lm/dataframes/p_10.Rda")

save(f_2.5, file = "lm/dataframes/f_2.5.Rda")
save(f_5,   file = "lm/dataframes/f_5.Rda")
save(f_7.5, file = "lm/dataframes/f_7.5.Rda")
save(f_10,  file = "lm/dataframes/f_10.Rda")
