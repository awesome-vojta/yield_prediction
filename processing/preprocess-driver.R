
# CRS corrected
points <- c(
  "processing/in/a_dilec.shp",
  # "processing/in/a_dolni_dil.shp", not suitable for FM
  "processing/in/a_mrazirna.shp",
  "processing/in/a_padelek.shp",
  "processing/in/a_pod_vysokou.shp",
  "processing/in/a_vysoka.shp",
  "processing/in/a_za_jamou.shp",
  "processing/in/s_1.shp",
  "processing/in/s_3.shp",
  "processing/in/s_4.shp"
)

# CRS corrected and manually filtered
fm_points <- c(
  "processing/in/fm_a_dilec.shp",
  "processing/in/fm_a_mrazirna.shp",
  "processing/in/fm_a_padelek.shp",
  "processing/in/fm_a_pod_vysokou.shp",
  "processing/in/fm_a_vysoka.shp",
  "processing/in/fm_a_za_jamou.shp",
  "processing/in/fm_s_1.shp",
  "processing/in/fm_s_3.shp",
  "processing/in/fm_s_4.shp"
)



source(file = "processing/variables-functions.R")
source(file = "processing/preprocess.R")

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
