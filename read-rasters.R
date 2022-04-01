library(raster)

get_variable_df <- function(prefix, quant, str_variable) {
  stopifnot(str_variable %in% c("yield", "elev", "moist", "swat", "dist"))
  stopifnot(quant %in% c(2.5, 5, 7.5, 10))
  stopifnot(prefix %in% c("fm_", ""))

  names <- c("a_dilec","a_mrazirna","a_padelek","a_pod_vysokou","a_vysoka","a_za_jamou","s_1","s_3")
  if(prefix != "") {
    names <- paste0(prefix, names)
  }
  paths_list <- paste0("preprocessing/out/", names, "_", quant, "_", 100-quant, "_itp_", str_variable, "_aligned_clip.tif")
  return(df_from_paths(paths_list, str_variable))
}

get_index_df <- function(prefix, quant, index) {
  stopifnot(index %in% c("evi", "ndvi"))
  stopifnot(quant %in% c(2.5, 5, 7.5, 10))
  stopifnot(prefix %in% c("fm_", ""))

  names <- c("a_dilec","a_mrazirna","a_padelek","a_pod_vysokou","a_vysoka","a_za_jamou","s_1","s_3")
  paths_list <- paste0("preprocessing/out/", prefix, names, "_", quant, "_", 100-quant, "_mask_", index, ".tif")
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

write.csv(p_2.5, file = "data/p_2.5.csv")
write.csv(p_5,   file = "data/p_5.csv")
write.csv(p_7.5, file = "data/p_7.5.csv")
write.csv(p_10,  file = "data/p_10.csv")

write.csv(f_2.5, file = "data/f_2.5.csv")
write.csv(f_5,   file = "data/f_5.csv")
write.csv(f_7.5, file = "data/f_7.5.csv")
write.csv(f_10,  file = "data/f_10.csv")
