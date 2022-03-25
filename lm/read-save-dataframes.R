source("lm/read-rasters.R")

yields_5_95_p    <- bind_into_df(yields_5_95_p,   "yield")
yields_5_95_fm   <- bind_into_df(yields_5_95_fm,  "yield")
yields_10_90_p   <- bind_into_df(yields_10_90_p,  "yield")
yields_10_90_fm  <- bind_into_df(yields_10_90_fm, "yield")
yields_15_85_p   <- bind_into_df(yields_15_85_p,  "yield")
yields_15_85_fm  <- bind_into_df(yields_15_85_fm, "yield")
yields_20_80_p   <- bind_into_df(yields_20_80_p,  "yield")
yields_20_80_fm  <- bind_into_df(yields_20_80_fm, "yield")
ndvis            <- bind_into_df(ndvis,           "NDVI")
evis             <- bind_into_df(evis,            "EVI")
ndvis_fm         <- bind_into_df(ndvis_fm,        "NDVI")
evis_fm          <- bind_into_df(evis_fm,         "EVI")

elev_5_95_p <- bind_into_df(elev_5_95_p,   "elev")
moist_5_95_p <- bind_into_df(moist_5_95_p, "moist")
swat_5_95_p <- bind_into_df(swat_5_95_p,   "swat")
dist_5_95_p <- bind_into_df(dist_5_95_p,   "dist")

indices <- merge(ndvis, evis, by=c("x","y"))
indices_fm <- merge(ndvis_fm, evis_fm, by=c("x","y"))

fields_5_p <- merge(x = yields_5_95_p, y = indices, by=c("x","y"), all.x = TRUE)
fields_10_p <- merge(x = yields_10_90_p, y = indices, by=c("x","y"), all.x = TRUE)
fields_15_p <- merge(x = yields_15_85_p, y = indices, by=c("x","y"), all.x = TRUE)
fields_20_p <- merge(x = yields_20_80_p, y = indices, by=c("x","y"), all.x = TRUE)

fields_5_f <- merge(x = yields_5_95_fm, y = indices_fm, by=c("x","y"), all.x = TRUE)
fields_10_f <- merge(x = yields_10_90_fm, y = indices_fm, by=c("x","y"), all.x = TRUE)
fields_15_f <- merge(x = yields_15_85_fm, y = indices_fm, by=c("x","y"), all.x = TRUE)
fields_20_f <- merge(x = yields_20_80_fm, y = indices_fm, by=c("x","y"), all.x = TRUE)

others_5_p <- merge(x = elev_5_95_p, y = moist_5_95_p, by = c("x","y"), all.x = TRUE)
others_5_p <- merge(x = others_5_p, y = swat_5_95_p, by = c("x","y"), all.x = TRUE)
others_5_p <- merge(x = others_5_p, y = dist_5_95_p, by = c("x","y"), all.x = TRUE)

fields_with_others_5_p <- merge(x = fields_5_p, y = others_5_p, by = c("x","y"), all.x = TRUE)

save(fields_5_p, file =  "lm/fields/fields_5_p.Rda")
save(fields_10_p, file = "lm/fields/fields_10_p.Rda")
save(fields_15_p, file = "lm/fields/fields_15_p.Rda")
save(fields_20_p, file = "lm/fields/fields_20_p.Rda")

save(fields_5_f, file =  "lm/fields/fields_5_f.Rda")
save(fields_10_f, file = "lm/fields/fields_10_f.Rda")
save(fields_15_f, file = "lm/fields/fields_15_f.Rda")
save(fields_20_f, file = "lm/fields/fields_20_f.Rda")

save(fields_with_others_5_p, file = "lm/fields/fields_with_others_5_p.Rda")

