library(sf)
library(ggplot2)
library(gridExtra)

shapes <- c(
  "processing/01_yield_points/a_dilec.shp",
  "processing/01_yield_points/a_dolni_dil.shp",
  "processing/01_yield_points/a_mrazirna.shp",
  "processing/01_yield_points/a_padelek.shp",
  "processing/01_yield_points/a_pod_vysokou.shp",
  "processing/01_yield_points/a_vysoka.shp",
  "processing/01_yield_points/a_za_jamou.shp",
  "processing/01_yield_points/s_1.shp",
  "processing/01_yield_points/s_3.shp",
  "processing/01_yield_points/s_4.shp"
)

# tenhle je asi nejlepsi
p1 <-
  ggplot() +
  geom_sf(data = st_read(shapes[1]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 15, mid = "blue", high = "green", name = "t/ha") +
  ggtitle("dilec") +
  theme(plot.title = element_text(hjust = 0.5))

p2 <- ggplot() +
  geom_sf(data = st_read(shapes[2]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 3.5, mid = "blue", high = , name = "t/ha") +
  ggtitle("dolni dil") +
  theme(plot.title = element_text(hjust = 0.5))

p3 <- ggplot() +
  geom_sf(data = st_read(shapes[3]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 40, mid = "blue", high = , name = "t/ha") +
  ggtitle("mrazirna") +
  theme(plot.title = element_text(hjust = 0.5))

p4 <- ggplot() +
  geom_sf(data = st_read(shapes[4]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 25, mid = "blue", high = , name = "t/ha") +
  ggtitle("padelek") +
  theme(plot.title = element_text(hjust = 0.5))

p5 <- ggplot() +
  geom_sf(data = st_read(shapes[5]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 4, mid = "blue", high = , name = "t/ha") +
  ggtitle("pod vysokou") +
  theme(plot.title = element_text(hjust = 0.5))

p6 <- ggplot() +
  geom_sf(data = st_read(shapes[6]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 12.5, mid = "blue", high = , name = "t/ha") +
  ggtitle("vysoka") +
  theme(plot.title = element_text(hjust = 0.5))

p7 <- ggplot() +
  geom_sf(data = st_read(shapes[7]), aes(color = VRYIELDMAS, stroke = 2)) +
  scale_color_gradient2(low = "red", midpoint = 11, mid = "blue", high = , name = "t/ha") +
  ggtitle("za jamou") +
  theme(plot.title = element_text(hjust = 0.5, size = 20), legend.text = element_text(size = 20), text = element_text(size = 20))

p8 <- ggplot() +
  geom_sf(data = st_read(shapes[8]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 30, mid = "blue", high = , name = "t/ha") +
  ggtitle("straskov 1") +
  theme(plot.title = element_text(hjust = 0.5))
p9 <- ggplot() +
  geom_sf(data = st_read(shapes[9]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 10, mid = "blue", high = , name = "t/ha") +
  ggtitle("straskov 3") +
  theme(plot.title = element_text(hjust = 0.5))
p10 <- ggplot() +
  geom_sf(data = st_read(shapes[10]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 15, mid = "blue", high = , name = "t/ha") +
  ggtitle("straskov 4") +
  theme(plot.title = element_text(hjust = 0.5))

# grid.arrange(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10, ncol=2)
grid.arrange(p7, ncol=1)

