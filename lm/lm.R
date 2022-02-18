library(ggplot2)
source("lm/read-rasters.R")


get_yield_index_dataframe <- function(yield_raster, index_raster) {
  i_df <- as.data.frame(index_raster, xy = TRUE)
  y_df <- as.data.frame(yield_raster, xy = TRUE)
  y_df[4] <- y_df[3] * 10                             # ton -> quintal conversion
  yi_df <- data.frame(unlist(y_df[1]), unlist(y_df[2]), unlist(y_df[4]), unlist(i_df[3]))
  yi_df <- yi_df[complete.cases(yi_df), ]             # remove NA's
  colnames(yi_df) <- c("x_coor","y_coor", "yield", get_index_name(index_raster))
  return(yi_df)
}

plot_linear_model <- function(yi_df, res) {
  plot(
    yield ~ yi_df[[4]],
    ylab = "Qx/ha",
    xlab = colnames(yi_df)[4],
    data = yi_df,
    main = paste("y=",round(res$coefficients[[1]],4),"x=",round(res$coefficients[[2]],8),"
    R^2=",round(res$r.squared,4))
  )
  abline(
   lm(
     formula = yield ~ yi_df[[4]],
     data = yi_df
   ),
   col = "red"
  )
}

get_linear_model_for_field <- function(yi_df) {
  res <- summary(
    lm(
      formula = yield ~ yi_df[[4]],
      data = yi_df
    )
  )
  return(res)
}

get_index_name <- function(index_raster) {
  i_name <- ""
  if(grepl("NDVI", index_raster@data@names, T)) {
    i_name <- "NDVI"
  } else {
    i_name <- "EVI"
  }
  return(i_name)
}

get_linear_model_for_dataset <- function(yields, indices) {
  avg_rsq <-  vector("numeric", length(yields))
  for (i in seq_along(yields)) {
    df <- get_yield_index_dataframe(yields[[i]], indices[[i]])
    res <- get_linear_model_for_field(df)
    # par(mfrow=c(2,2))
    # plot_linear_model(df, res)
    writeLines("_____________")
    writeLines(paste0("Field: ", gsub("_interpolated_aligned_clip","", yields[[i]]@data@names)))
    writeLines(paste0("R^2:   ", round(res$r.squared,4)))
    writeLines(paste0("x:     ", round(res$coefficients[[2]],4)))
    avg_rsq[i] <- res$r.squared
  }
  writeLines(paste0("avg R^2: ", round(mean(avg_rsq),4)))
}

prewriteLines_dataset <-function (str) {
  str <- paste("### ",str," ###",sep="")
  writeLines("######################")
  writeLines(str)
  writeLines("######################")
}

prewriteLines_dataset("5_95_p ~ ndvis")
get_linear_model_for_dataset(yields_5_95_p, ndvis)
prewriteLines_dataset("5_95_p ~ evis")
get_linear_model_for_dataset(yields_5_95_p, evis)
prewriteLines_dataset("yields_5_95_fm ~ ndvis_fm")
get_linear_model_for_dataset(yields_5_95_fm, ndvis_fm)
prewriteLines_dataset("yields_5_95_fm ~ evis_fm")
get_linear_model_for_dataset(yields_5_95_fm, evis_fm)

prewriteLines_dataset("yields_10_90_p ~ ndvis")
get_linear_model_for_dataset(yields_10_90_p, ndvis)
prewriteLines_dataset("yields_10_90_p ~ evis")
get_linear_model_for_dataset(yields_10_90_p, evis)
prewriteLines_dataset("yields_10_90_fm ~ ndvis_fm")
get_linear_model_for_dataset(yields_10_90_fm, ndvis_fm)
prewriteLines_dataset("yields_10_90_fm ~ evis_fm")
get_linear_model_for_dataset(yields_10_90_fm, evis_fm)

prewriteLines_dataset("yields_15_85_p ~ ndvis")
get_linear_model_for_dataset(yields_15_85_p, ndvis)
prewriteLines_dataset("yields_15_85_p ~ evis")
get_linear_model_for_dataset(yields_15_85_p, evis)
prewriteLines_dataset("yields_15_85_fm ~ ndvis_fm")
get_linear_model_for_dataset(yields_15_85_fm, ndvis_fm)
prewriteLines_dataset("yields_15_85_fm ~ evis_fm")
get_linear_model_for_dataset(yields_15_85_fm, evis_fm)

prewriteLines_dataset("yields_20_80_p ~ ndvis")
get_linear_model_for_dataset(yields_20_80_p, ndvis)
prewriteLines_dataset("yields_20_80_p ~ evis")
get_linear_model_for_dataset(yields_20_80_p, evis)
prewriteLines_dataset("yields_20_80_fm ~ ndvis_fm")
get_linear_model_for_dataset(yields_20_80_fm, ndvis_fm)
prewriteLines_dataset("yields_20_80_fm ~ evis_fm")
get_linear_model_for_dataset(yields_20_80_fm, evis_fm)



plot(ndvis_fm[[7]])
# get_linear_model_for_field(yields_10_90_fm[[1]], evis_fm[[1]])