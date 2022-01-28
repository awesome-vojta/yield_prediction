library(raster)


# filtered 3rd and 98th percentile
yields_3_98 <- c(
  raster("lm/yields_3_98/a_dilec_3_98_3_interpolated_clip_aligned_clip.tif"),
  raster("lm/yields_3_98/a_dolni_dil_3_98_3_interpolated_clip_aligned_clip.tif"),
  raster("lm/yields_3_98/a_mrazirna_3_98_3_interpolated_clip_aligned_clip.tif"),
  raster("lm/yields_3_98/a_padelek_3_98_3_interpolated_clip_aligned_clip.tif"),
  raster("lm/yields_3_98/a_pod_vysokou_3_98_3_interpolated_clip_aligned_clip.tif"),
  raster("lm/yields_3_98/a_vysoka_3_98_3_interpolated_clip_aligned_clip.tif"),
  raster("lm/yields_3_98/a_za_jamou_3_98_3_interpolated_clip_aligned_clip.tif"),
  raster("lm/yields_3_98/s_1_3_98_3_interpolated_clip_aligned_clip.tif"),
  raster("lm/yields_3_98/s_3_3_98_3_interpolated_clip_aligned_clip.tif"),
  raster("lm/yields_3_98/s_4_3_98_3_interpolated_clip_aligned_clip.tif")
)

# filtered 5th and 95th percentile
yields_5_95 <- c(
  raster("lm/yields_5_95_p/a_dilec_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_5_95_p/a_dolni_dil_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_5_95_p/a_mrazirna_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_5_95_p/a_padelek_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_5_95_p/a_pod_vysokou_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_5_95_p/a_vysoka_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_5_95_p/a_za_jamou_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_5_95_p/s_1_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_5_95_p/s_3_5_95_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_5_95_p/s_4_5_95_3_interpolated_aligned_clip.tif")
)

#filtered 10th and 90th percentile
yields_10_90_p <- c(
  raster("lm/yields_10_90_p/a_dilec_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_p/a_dolni_dil_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_p/a_mrazirna_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_p/a_padelek_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_p/a_pod_vysokou_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_p/a_vysoka_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_p/a_za_jamou_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_p/s_1_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_p/s_3_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_p/s_4_10_90_3_interpolated_aligned_clip.tif")
)

#filtered 10th and THEN 90th percentile
yields_10_90 <- c(
  raster("lm/yields_10_90/a_dilec_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90/a_dolni_dil_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90/a_mrazirna_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90/a_padelek_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90/a_pod_vysokou_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90/a_vysoka_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90/a_za_jamou_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90/s_1_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90/s_3_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90/s_4_10_90_3_interpolated_aligned_clip.tif")
)

#filtered 25th and THEN 75th percentile
yields_25_75 <- c(
  raster("lm/yields_25_75/a_dilec_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75/a_dolni_dil_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75/a_mrazirna_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75/a_padelek_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75/a_pod_vysokou_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75/a_vysoka_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75/a_za_jamou_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75/s_1_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75/s_3_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75/s_4_25_75_3_interpolated_aligned_clip.tif")
)

#manual filter and THEN 25th and 75th percentile
yields_25_75_fm <- c(
  raster("lm/yields_25_75_fm/fm_a_dilec_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75_fm/fm_a_mrazirna_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75_fm/fm_a_padelek_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75_fm/fm_a_pod_vysokou_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75_fm/fm_a_vysoka_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75_fm/fm_a_za_jamou_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75_fm/fm_s_1_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75_fm/fm_s_3_25_75_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_25_75_fm/fm_s_4_25_75_3_interpolated_aligned_clip.tif")
)

#manual filter and THEN 10th and 90th percentile
yields_10_90_fm <- c(
  raster("lm/yields_10_90_fm/fm_a_dilec_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_fm/fm_a_mrazirna_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_fm/fm_a_padelek_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_fm/fm_a_pod_vysokou_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_fm/fm_a_vysoka_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_fm/fm_a_za_jamou_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_fm/fm_s_1_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_fm/fm_s_3_10_90_3_interpolated_aligned_clip.tif"),
  raster("lm/yields_10_90_fm/fm_s_4_10_90_3_interpolated_aligned_clip.tif")
)

ndvis <- c(
  raster("lm/indices/a_dilec_poly_NDVI.tif"),
  raster("lm/indices/a_dolni_dil_poly_NDVI.tif"),
  raster("lm/indices/a_mrazirna_poly_NDVI.tif"),
  raster("lm/indices/a_padelek_poly_NDVI.tif"),
  raster("lm/indices/a_pod_vysokou_poly_NDVI.tif"),
  raster("lm/indices/a_vysoka_poly_NDVI.tif"),
  raster("lm/indices/a_za_jamou_poly_NDVI.tif"),
  raster("lm/indices/s_1_poly_NDVI.tif"),
  raster("lm/indices/s_3_poly_NDVI.tif"),
  raster("lm/indices/s_4_poly_NDVI.tif")
)

evis <- c(
  raster("lm/indices/a_dilec_poly_EVI.tif"),
  raster("lm/indices/a_dolni_dil_poly_EVI.tif"),
  raster("lm/indices/a_mrazirna_poly_EVI.tif"),
  raster("lm/indices/a_padelek_poly_EVI.tif"),
  raster("lm/indices/a_pod_vysokou_poly_EVI.tif"),
  raster("lm/indices/a_vysoka_poly_EVI.tif"),
  raster("lm/indices/a_za_jamou_poly_EVI.tif"),
  raster("lm/indices/s_1_poly_EVI.tif"),
  raster("lm/indices/s_3_poly_EVI.tif"),
  raster("lm/indices/s_4_poly_EVI.tif")
)

#NDVI raster clipped to manual filter
ndvis_fm <- c(
  raster("lm/indices_fm/fm_a_dilec_mask_NDVI.tif"),
  raster("lm/indices_fm/fm_a_mrazirna_mask_NDVI.tif"),
  raster("lm/indices_fm/fm_a_padelek_mask_NDVI.tif"),
  raster("lm/indices_fm/fm_a_pod_vysokou_mask_NDVI.tif"),
  raster("lm/indices_fm/fm_a_vysoka_mask_NDVI.tif"),
  raster("lm/indices_fm/fm_a_za_jamou_mask_NDVI.tif"),
  raster("lm/indices_fm/fm_s_1_mask_NDVI.tif"),
  raster("lm/indices_fm/fm_s_3_mask_NDVI.tif"),
  raster("lm/indices_fm/fm_s_4_mask_NDVI.tif")
)

#EVI raster clipped to manual filter
evis_fm <- c(
  raster("lm/indices_fm/fm_a_dilec_mask_EVI.tif"),
  raster("lm/indices_fm/fm_a_mrazirna_mask_EVI.tif"),
  raster("lm/indices_fm/fm_a_padelek_mask_EVI.tif"),
  raster("lm/indices_fm/fm_a_pod_vysokou_mask_EVI.tif"),
  raster("lm/indices_fm/fm_a_vysoka_mask_EVI.tif"),
  raster("lm/indices_fm/fm_a_za_jamou_mask_EVI.tif"),
  raster("lm/indices_fm/fm_s_1_mask_EVI.tif"),
  raster("lm/indices_fm/fm_s_3_mask_EVI.tif"),
  raster("lm/indices_fm/fm_s_4_mask_EVI.tif")
)