library(hexSticker)
library(showtext)

# Load Google font.
#
font_add_google("Roboto Slab", "roboto_slab")
showtext_auto()

SWIDTH = 800
FWIDTH = 950

sticker(here::here("inst/hex/binance-icon.png"),
        # Image
        s_x = 1.0,
        s_y = 1.0,
        s_width = SWIDTH / FWIDTH,
        asp = 0.85,
        # Package name
        package = "binance",
        p_size = 24,
        p_x = 1.450,
        p_y = 0.550,
        p_color = "#f0b90b",
        p_family = "roboto_slab",
        # Hex
        h_fill = "#222222",
        h_color = "#000000",
        # Output
        filename = here::here("man/figures/binance-hex.png"),
        dpi = 600,
        angle = 45
)

# p_color = "#000000",
# p_family = "Roboto",
# # Hex
# h_fill = "#E4EAEE",
# h_size = 1.5,
# h_color = "#03a9f4",
# # Output
# filename = here::here("man/figures/clockify-hex.png"),
# asp = 0.85,
# dpi = 600
