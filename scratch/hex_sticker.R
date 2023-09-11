library(ggplot2)
library(tibble)
library(dplyr)
library(MGMM)
library(ggpointdensity)
library(hexSticker)

mean_list <- asplit(expand.grid(1:5, 1:5), 1)
cov <- matrix(c(0.01, 0.008, 0.008, 0.01), nrow = 2)
beads <- as_tibble(rGMM(n = 5e3, d = 2, k = 25, means = mean_list, covs = cov))

mod <- function(x, a, b, c, d) {
  d + ((a-d)/(1+(x/c)^b))
}

curves <- tibble(
  y1 = seq(1, 5, 0.01),
  y2 = mod(x = y1, a = 1, b = 8, c = 3, d = 5)
)

set.seed(24601)
ind <- sample_n(curves, 10) |> dplyr::filter(y2 > 1.5, y2 < 4) |> mutate(y1 = y1 - 5.5)

p <- ggplot(beads, aes(y1, y2)) +
  geom_pointdensity(size = 0.05) +
  geom_line(data = curves, aes(y1 - 5.5, y2), size = 0.5, colour = "#FDE725FF") +
  geom_segment(y = ind[1,]$y2, yend = ind[1,]$y2, x = -4.5, xend = ind[1,]$y1, col = "white", linetype = "dotted", linewidth = 0.2) +
  geom_segment(y = ind[2,]$y2, yend = ind[2,]$y2, x = -4.5, xend = ind[2,]$y1, col = "white", linetype = "dotted", linewidth = 0.2) +
  geom_segment(y = ind[3,]$y2, yend = ind[3,]$y2, x = -4.5, xend = ind[3,]$y1, col = "white", linetype = "dotted", linewidth = 0.2) +
  geom_segment(y = 1, yend = ind[1,]$y2, x = ind[1,]$y1, xend = ind[1,]$y1, col = "white", linetype = "dotted", linewidth = 0.2) +
  geom_segment(y = 1, yend = ind[2,]$y2, x = ind[2,]$y1, xend = ind[2,]$y1, col = "white", linetype = "dotted", linewidth = 0.2) +
  geom_segment(y = 1, yend = ind[3,]$y2, x = ind[3,]$y1, xend = ind[3,]$y1, col = "white", linetype = "dotted", linewidth = 0.2) +
  geom_point(data = ind, col = "white") +
  coord_cartesian(xlim = c(-5, 6), ylim = c(-5, 6)) +
  scale_colour_viridis_c() +
  theme_void() +
  theme_transparent() +
  theme(legend.position = "none")



sticker(
   p,
   package = "luminary",
   s_width = 1.5,
   s_height = 1.5,
   s_x = 1,
   s_y = 0.6,
   p_size = 20,
   h_fill = "#3B528BFF",
   h_color = "#5DC863FF",
   filename = "inst/figures/luminary.png"
) |> plot()

