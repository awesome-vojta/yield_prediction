library(ggplot2)
source("lm/read-rasters.R")


lm_for_field <- function(yield_raster, index_raster) {
  i_df <- as.data.frame(index_raster, xy = TRUE)
  i_name <- ""
  if(grepl("NDVI", colnames(i_df)[3], T)) {
    i_name <- "NDVI"
  } else {
    i_name <- "EVI"
  }
  colnames(i_df) <- c("x","y",i_name)
  
  y_df <- as.data.frame(yield_raster, xy = TRUE)
  y_df[4] <- y_df[3] * 10 # ton -> quintal conversion
  colnames(y_df) <- c("x","y","t/ha","Qx/ha")
  
  y_values <- unlist(y_df[4])
  i_values <- unlist(i_df[3])
  yi_df <- data.frame(y_values, i_values)
  

  
  res <- summary(
    lm(
      formula = i_values ~ y_values,
      data = yi_df
    )
  )
    plot(
    y_values ~ i_values,
    ylab = "Qx/ha",
    xlab = i_name,
    main = paste("y=",round(res$coefficients[[1]],4),"x+",round(res$coefficients[[2]],8),"
    R^2=",round(res$r.squared,4))
  )

  abline(
   lm(
     formula = y_values ~ i_values,
     data = yi_df
   ),
   col = "red"
  )
  print(res$r.squared)
  return(res$r.squared)
}

lm_for_dataset <- function(yields, indices) {
  r_sq <- vector("numeric", length(yields))
  for (i in seq_along(yields)) {
    r_sq[i] <- lm_for_field(yields[[i]], indices[[i]])
  }
  print("avg: ")
  print(mean(r_sq))
}



lm_for_dataset(yields_5_95_p, ndvis)
lm_for_dataset(yields_5_95_p, evis)
lm_for_dataset(yields_5_95_fm, ndvis_fm)
lm_for_dataset(yields_5_95_fm, evis_fm)

lm_for_dataset(yields_10_90_p, ndvis)
lm_for_dataset(yields_10_90_p, evis)
lm_for_dataset(yields_10_90_fm, ndvis_fm)
lm_for_dataset(yields_10_90_fm, evis_fm)

lm_for_dataset(yields_15_85_p, ndvis)
lm_for_dataset(yields_15_85_p, evis)
lm_for_dataset(yields_15_85_fm, ndvis_fm)
lm_for_dataset(yields_15_85_fm, evis_fm)

lm_for_dataset(yields_20_80_p, ndvis)
lm_for_dataset(yields_20_80_p, evis)
lm_for_dataset(yields_20_80_fm, ndvis_fm)
lm_for_dataset(yields_20_80_fm, evis_fm)



plot(ndvis_fm[[7]])
lm_for_field(yields_10_90_fm[[1]], evis_fm[[1]])



# # best candidates:
# # what's up with these images?
# plot(yields_10_90_fm[[8]])
# plot(evis_fm[[8]])
# lm_for_field(yields_10_90_fm[[8]], ndvis_fm[[8]])
#
# plot(yields_5_95[[1]])
# plot(evis[[1]])
# lm_for_field(yields_5_95[[1]], ndvis[[1]])
#
# plot(yields_25_75_fm[[4]])
# plot(ndvis_fm[[4]])
# lm_for_field(yields_25_75_fm[[4]], ndvis_fm[[4]])

# plot(yields_5_95_fm[[8]])
# plot(ndvis[[8]])
# plot(evis[[8]])
# plot(yields_5_95_fm[[1]])
# plot(yields_5_95_p[[9]])
# plot(yields_5_95_p[[1]])
# plot(evis[[9]])


# TODO:
# cherry-pick best fields
# finish-up LM
# start with forest regression