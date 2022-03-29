library(sf)
library(ggplot2)
library(gridExtra)

shapes <- c(
  "processing/in/a_dilec.shp",
  # "processing/in/a_dolni_dil.shp",  ! NOT suitable for manual filtering
  "processing/in/a_mrazirna.shp",
  "processing/in/a_padelek.shp",
  "processing/in/a_pod_vysokou.shp",
  "processing/in/a_vysoka.shp",
  "processing/in/a_za_jamou.shp",
  "processing/in/s_1.shp",
  "processing/in/s_3.shp"
  # "processing/in/s_4.shp"    ! NOT suitable for manual filtering
)


p1 <-
  ggplot() +
  geom_sf(data = st_read(shapes[1]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 15, mid = "blue", high = "green", name = "t/ha") +
  ggtitle("dilec") +
  theme(plot.title = element_text(hjust = 0.5))

p2 <- ggplot() +
  geom_sf(data = st_read(shapes[2]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 40, mid = "blue", high = , name = "t/ha") +
  ggtitle("mrazirna") +
  theme(plot.title = element_text(hjust = 0.5))

p3 <- ggplot() +
  geom_sf(data = st_read(shapes[3]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 25, mid = "blue", high = , name = "t/ha") +
  ggtitle("padelek") +
  theme(plot.title = element_text(hjust = 0.5))

p4 <- ggplot() +
  geom_sf(data = st_read(shapes[4]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 4, mid = "blue", high = , name = "t/ha") +
  ggtitle("pod vysokou") +
  theme(plot.title = element_text(hjust = 0.5))

p5 <- ggplot() +
  geom_sf(data = st_read(shapes[5]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 12.5, mid = "blue", high = , name = "t/ha") +
  ggtitle("vysoka") +
  theme(plot.title = element_text(hjust = 0.5))

p6 <- ggplot() +
  geom_sf(data = st_read(shapes[6]), aes(color = VRYIELDMAS, stroke = 2)) +
  scale_color_gradient2(low = "red", midpoint = 11, mid = "blue", high = , name = "t/ha") +
  ggtitle("za jamou") +
  theme(plot.title = element_text(hjust = 0.5))

p7 <- ggplot() +
  geom_sf(data = st_read(shapes[7]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 30, mid = "blue", high = , name = "t/ha") +
  ggtitle("straskov 1") +
  theme(plot.title = element_text(hjust = 0.5))
p8 <- ggplot() +
  geom_sf(data = st_read(shapes[8]), aes(color = VRYIELDMAS, stroke = 1)) +
  scale_color_gradient2(low = "red", midpoint = 10, mid = "blue", high = , name = "t/ha") +
  ggtitle("straskov 3") +
  theme(plot.title = element_text(hjust = 0.5))


grid.arrange(p1,p2,p3,p4,p5,p6,p7,p8, ncol=2)
# grid.arrange(p7, ncol=1)

