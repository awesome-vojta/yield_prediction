library(raster)

bind_into_df <- function(rasters, value_col_name) {

  # initialize empty df
  df <- data.frame(double(),double(),double())
  colnames(df) <- c("x","y", value_col_name)

  # bind
  for (raster in rasters) {
    raster_df <- as.data.frame(raster, xy=TRUE)
    colnames(raster_df) <- c("x","y", value_col_name)
    no_missing_values <- raster_df[complete.cases(raster_df), ]
    df <- rbind(df, no_missing_values)
  }
  return(df)
}

#TODO: consider converting to Rda as well
yields_5_95_p <- c(
  raster("lm/yields/yields_5_95_p/a_dilec_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_p/a_mrazirna_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_p/a_padelek_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_p/a_pod_vysokou_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_p/a_vysoka_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_p/a_za_jamou_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_p/s_1_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_p/s_3_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_p/s_4_5_95_3_interpolated_aligned_clip.tif")
)
moist_5_95_p <- c(
  raster("lm/other_attributes/a_dilec_5_95_itp_moist_aligned_clip.tif"),
  raster("lm/other_attributes/a_mrazirna_5_95_itp_moist_aligned_clip.tif"),
  raster("lm/other_attributes/a_padelek_5_95_itp_moist_aligned_clip.tif"),
  raster("lm/other_attributes/a_pod_vysokou_5_95_itp_moist_aligned_clip.tif"),
  raster("lm/other_attributes/a_vysoka_5_95_itp_moist_aligned_clip.tif"),
  raster("lm/other_attributes/a_za_jamou_5_95_itp_moist_aligned_clip.tif"),
  raster("lm/other_attributes/s_1_5_95_itp_moist_aligned_clip.tif"),
  raster("lm/other_attributes/s_3_5_95_itp_moist_aligned_clip.tif"),
  raster("lm/other_attributes/s_4_5_95_itp_moist_aligned_clip.tif")
)

dist_5_95_p <- c(
  raster("lm/other_attributes/a_dilec_5_95_itp_dist_aligned_clip.tif"),
  raster("lm/other_attributes/a_mrazirna_5_95_itp_dist_aligned_clip.tif"),
  raster("lm/other_attributes/a_padelek_5_95_itp_dist_aligned_clip.tif"),
  raster("lm/other_attributes/a_pod_vysokou_5_95_itp_dist_aligned_clip.tif"),
  raster("lm/other_attributes/a_vysoka_5_95_itp_dist_aligned_clip.tif"),
  raster("lm/other_attributes/a_za_jamou_5_95_itp_dist_aligned_clip.tif"),
  raster("lm/other_attributes/s_1_5_95_itp_dist_aligned_clip.tif"),
  raster("lm/other_attributes/s_3_5_95_itp_dist_aligned_clip.tif"),
  raster("lm/other_attributes/s_4_5_95_itp_dist_aligned_clip.tif")
)

swat_5_95_p <- c(
  raster("lm/other_attributes/a_dilec_5_95_itp_swat_aligned_clip.tif"),
  raster("lm/other_attributes/a_mrazirna_5_95_itp_swat_aligned_clip.tif"),
  raster("lm/other_attributes/a_padelek_5_95_itp_swat_aligned_clip.tif"),
  raster("lm/other_attributes/a_pod_vysokou_5_95_itp_swat_aligned_clip.tif"),
  raster("lm/other_attributes/a_vysoka_5_95_itp_swat_aligned_clip.tif"),
  raster("lm/other_attributes/a_za_jamou_5_95_itp_swat_aligned_clip.tif"),
  raster("lm/other_attributes/s_1_5_95_itp_swat_aligned_clip.tif"),
  raster("lm/other_attributes/s_3_5_95_itp_swat_aligned_clip.tif"),
  raster("lm/other_attributes/s_4_5_95_itp_swat_aligned_clip.tif")
)

elev_5_95_p <- c(
  raster("lm/other_attributes/a_dilec_5_95_itp_elev_aligned_clip.tif"),
  raster("lm/other_attributes/a_mrazirna_5_95_itp_elev_aligned_clip.tif"),
  raster("lm/other_attributes/a_padelek_5_95_itp_elev_aligned_clip.tif"),
  raster("lm/other_attributes/a_pod_vysokou_5_95_itp_elev_aligned_clip.tif"),
  raster("lm/other_attributes/a_vysoka_5_95_itp_elev_aligned_clip.tif"),
  raster("lm/other_attributes/a_za_jamou_5_95_itp_elev_aligned_clip.tif"),
  raster("lm/other_attributes/s_1_5_95_itp_elev_aligned_clip.tif"),
  raster("lm/other_attributes/s_3_5_95_itp_elev_aligned_clip.tif"),
  raster("lm/other_attributes/s_4_5_95_itp_elev_aligned_clip.tif")
)

yields_5_95_fm <- c(
  raster("lm/yields/yields_5_95_fm/fm_a_dilec_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_fm/fm_a_mrazirna_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_fm/fm_a_padelek_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_fm/fm_a_pod_vysokou_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_fm/fm_a_vysoka_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_fm/fm_a_za_jamou_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_fm/fm_s_1_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_fm/fm_s_3_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_5_95_fm/fm_s_4_5_95_3_interpolated_aligned_clip.tif")
)

yields_10_90_p <- c(
  raster("lm/yields/yields_10_90_p/a_dilec_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_p/a_mrazirna_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_p/a_padelek_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_p/a_pod_vysokou_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_p/a_vysoka_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_p/a_za_jamou_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_p/s_1_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_p/s_3_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_p/s_4_10_90_3_interpolated_aligned_clip.tif")
)

yields_10_90_fm <- c(
  raster("lm/yields/yields_10_90_fm/fm_a_dilec_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_fm/fm_a_mrazirna_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_fm/fm_a_padelek_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_fm/fm_a_pod_vysokou_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_fm/fm_a_vysoka_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_fm/fm_a_za_jamou_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_fm/fm_s_1_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_fm/fm_s_3_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_10_90_fm/fm_s_4_10_90_3_interpolated_aligned_clip.tif")
)

yields_15_85_p <- c(
  raster("lm/yields/yields_15_85_p/a_dilec_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_p/a_mrazirna_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_p/a_padelek_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_p/a_pod_vysokou_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_p/a_vysoka_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_p/a_za_jamou_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_p/s_1_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_p/s_3_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_p/s_4_15_85_3_interpolated_aligned_clip.tif")
)

yields_15_85_fm <- c(
  raster("lm/yields/yields_15_85_fm/fm_a_dilec_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_fm/fm_a_mrazirna_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_fm/fm_a_padelek_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_fm/fm_a_pod_vysokou_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_fm/fm_a_vysoka_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_fm/fm_a_za_jamou_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_fm/fm_s_1_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_fm/fm_s_3_15_85_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_15_85_fm/fm_s_4_15_85_3_interpolated_aligned_clip.tif")
)

yields_20_80_p <- c(
  raster("lm/yields/yields_20_80_p/a_dilec_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_p/a_mrazirna_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_p/a_padelek_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_p/a_pod_vysokou_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_p/a_vysoka_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_p/a_za_jamou_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_p/s_1_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_p/s_3_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_p/s_4_20_80_3_interpolated_aligned_clip.tif")
)

yields_20_80_fm <- c(
  raster("lm/yields/yields_20_80_fm/fm_a_dilec_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_fm/fm_a_mrazirna_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_fm/fm_a_padelek_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_fm/fm_a_pod_vysokou_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_fm/fm_a_vysoka_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_fm/fm_a_za_jamou_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_fm/fm_s_1_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_fm/fm_s_3_20_80_3_interpolated_aligned_clip.tif"),
  raster("lm/yields/yields_20_80_fm/fm_s_4_20_80_3_interpolated_aligned_clip.tif")
)

ndvis <- c(
  raster("lm/indices/indices_p/a_dilec_poly_NDVI.tif"),
  raster("lm/indices/indices_p/a_mrazirna_poly_NDVI.tif"),
  raster("lm/indices/indices_p/a_padelek_poly_NDVI.tif"),
  raster("lm/indices/indices_p/a_pod_vysokou_poly_NDVI.tif"),
  raster("lm/indices/indices_p/a_vysoka_poly_NDVI.tif"),
  raster("lm/indices/indices_p/a_za_jamou_poly_NDVI.tif"),
  raster("lm/indices/indices_p/s_1_poly_NDVI.tif"),
  raster("lm/indices/indices_p/s_3_poly_NDVI.tif"),
  raster("lm/indices/indices_p/s_4_poly_NDVI.tif")
)

evis <- c(
  raster("lm/indices/indices_p/a_dilec_poly_EVI.tif"),
  raster("lm/indices/indices_p/a_mrazirna_poly_EVI.tif"),
  raster("lm/indices/indices_p/a_padelek_poly_EVI.tif"),
  raster("lm/indices/indices_p/a_pod_vysokou_poly_EVI.tif"),
  raster("lm/indices/indices_p/a_vysoka_poly_EVI.tif"),
  raster("lm/indices/indices_p/a_za_jamou_poly_EVI.tif"),
  raster("lm/indices/indices_p/s_1_poly_EVI.tif"),
  raster("lm/indices/indices_p/s_3_poly_EVI.tif"),
  raster("lm/indices/indices_p/s_4_poly_EVI.tif")
)

ndvis_fm <- c(
  raster("lm/indices/indices_fm/fm_a_dilec_mask_NDVI.tif"),
  raster("lm/indices/indices_fm/fm_a_mrazirna_mask_NDVI.tif"),
  raster("lm/indices/indices_fm/fm_a_padelek_mask_NDVI.tif"),
  raster("lm/indices/indices_fm/fm_a_pod_vysokou_mask_NDVI.tif"),
  raster("lm/indices/indices_fm/fm_a_vysoka_mask_NDVI.tif"),
  raster("lm/indices/indices_fm/fm_a_za_jamou_mask_NDVI.tif"),
  raster("lm/indices/indices_fm/fm_s_1_mask_NDVI.tif"),
  raster("lm/indices/indices_fm/fm_s_3_mask_NDVI.tif"),
  raster("lm/indices/indices_fm/fm_s_4_mask_NDVI.tif")
)

evis_fm <- c(
  raster("lm/indices/indices_fm/fm_a_dilec_mask_EVI.tif"),
  raster("lm/indices/indices_fm/fm_a_mrazirna_mask_EVI.tif"),
  raster("lm/indices/indices_fm/fm_a_padelek_mask_EVI.tif"),
  raster("lm/indices/indices_fm/fm_a_pod_vysokou_mask_EVI.tif"),
  raster("lm/indices/indices_fm/fm_a_vysoka_mask_EVI.tif"),
  raster("lm/indices/indices_fm/fm_a_za_jamou_mask_EVI.tif"),
  raster("lm/indices/indices_fm/fm_s_1_mask_EVI.tif"),
  raster("lm/indices/indices_fm/fm_s_3_mask_EVI.tif"),
  raster("lm/indices/indices_fm/fm_s_4_mask_EVI.tif")
)
