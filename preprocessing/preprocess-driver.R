
# CRS corrected
points <- c(
  "preprocessing/in/a_dilec.shp",
  # "preprocessing/in/a_dolni_dil.shp", not suitable for FM
  "preprocessing/in/a_mrazirna.shp",
  "preprocessing/in/a_padelek.shp",
  "preprocessing/in/a_pod_vysokou.shp",
  "preprocessing/in/a_vysoka.shp",
  "preprocessing/in/a_za_jamou.shp",
  "preprocessing/in/s_1.shp",
  "preprocessing/in/s_3.shp",
  "preprocessing/in/s_4.shp"
)

# CRS corrected and manually filtered
fm_points <- c(
  "preprocessing/in/fm_a_dilec.shp",
  "preprocessing/in/fm_a_mrazirna.shp",
  "preprocessing/in/fm_a_padelek.shp",
  "preprocessing/in/fm_a_pod_vysokou.shp",
  "preprocessing/in/fm_a_vysoka.shp",
  "preprocessing/in/fm_a_za_jamou.shp",
  "preprocessing/in/fm_s_1.shp",
  "preprocessing/in/fm_s_3.shp",
  "preprocessing/in/fm_s_4.shp"
)



source(file = "preprocessing/variables-functions.R")
source(file = "preprocessing/preprocess.R")

# preprocess(points = points, flt_quant = 2.5, itp_attribute = ITP_YIELD)
# preprocess(points = points, flt_quant = 2.5, itp_attribute = ITP_ELEV)
# preprocess(points = points, flt_quant = 2.5, itp_attribute = ITP_MOIST)
# --------- run lines below
preprocess(points = points, flt_quant = 2.5, itp_attribute = ITP_SWATH)
preprocess(points = points, flt_quant = 2.5, itp_attribute = ITP_DIST)

preprocess(points = points, flt_quant = 5, itp_attribute = ITP_YIELD)
preprocess(points = points, flt_quant = 5, itp_attribute = ITP_MOIST)
preprocess(points = points, flt_quant = 5, itp_attribute = ITP_ELEV)
preprocess(points = points, flt_quant = 5, itp_attribute = ITP_SWATH)
preprocess(points = points, flt_quant = 5, itp_attribute = ITP_DIST)

preprocess(points = points, flt_quant = 7.5, itp_attribute = ITP_YIELD)
preprocess(points = points, flt_quant = 7.5, itp_attribute = ITP_MOIST)
preprocess(points = points, flt_quant = 7.5, itp_attribute = ITP_ELEV)
preprocess(points = points, flt_quant = 7.5, itp_attribute = ITP_SWATH)
preprocess(points = points, flt_quant = 7.5, itp_attribute = ITP_DIST)

preprocess(points = points, flt_quant = 10, itp_attribute = ITP_YIELD)
preprocess(points = points, flt_quant = 10, itp_attribute = ITP_MOIST)
preprocess(points = points, flt_quant = 10, itp_attribute = ITP_ELEV)
preprocess(points = points, flt_quant = 10, itp_attribute = ITP_SWATH)
preprocess(points = points, flt_quant = 10, itp_attribute = ITP_DIST)




preprocess(points = fm_points, flt_quant = 2.5, itp_attribute = ITP_YIELD)
preprocess(points = fm_points, flt_quant = 2.5, itp_attribute = ITP_MOIST)
preprocess(points = fm_points, flt_quant = 2.5, itp_attribute = ITP_ELEV)
preprocess(points = fm_points, flt_quant = 2.5, itp_attribute = ITP_SWATH)
preprocess(points = fm_points, flt_quant = 2.5, itp_attribute = ITP_DIST)

preprocess(points = fm_points, flt_quant = 5, itp_attribute = ITP_YIELD)
preprocess(points = fm_points, flt_quant = 5, itp_attribute = ITP_MOIST)
preprocess(points = fm_points, flt_quant = 5, itp_attribute = ITP_ELEV)
preprocess(points = fm_points, flt_quant = 5, itp_attribute = ITP_SWATH)
preprocess(points = fm_points, flt_quant = 5, itp_attribute = ITP_DIST)

preprocess(points = fm_points, flt_quant = 7.5, itp_attribute = ITP_YIELD)
preprocess(points = fm_points, flt_quant = 7.5, itp_attribute = ITP_MOIST)
preprocess(points = fm_points, flt_quant = 7.5, itp_attribute = ITP_ELEV)
preprocess(points = fm_points, flt_quant = 7.5, itp_attribute = ITP_SWATH)
preprocess(points = fm_points, flt_quant = 7.5, itp_attribute = ITP_DIST)

preprocess(points = fm_points, flt_quant = 10, itp_attribute = ITP_YIELD)
preprocess(points = fm_points, flt_quant = 10, itp_attribute = ITP_MOIST)
preprocess(points = fm_points, flt_quant = 10, itp_attribute = ITP_ELEV)
preprocess(points = fm_points, flt_quant = 10, itp_attribute = ITP_SWATH)
preprocess(points = fm_points, flt_quant = 10, itp_attribute = ITP_DIST)
