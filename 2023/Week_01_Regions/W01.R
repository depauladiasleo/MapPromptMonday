# Título:
# Script por:
# Última atualização:


# Descrição:


# Preparação -------------------------------------------------------------------



## Bibliotecas -----------------------------------------------------------------


library(ggtext)
library(showtext)
library(tidyverse)
library(geobr)
library(sf)


# Importação de dados ----------------------------------------------------------


amazon <- read_amazon()

br <- read_country()

indígena <- geobr::read_indigenous_land()


# Faxina de dados --------------------------------------------------------------





# Visualização -----------------------------------------------------------------


## Texto -----------------------------------------------------------------------



títulos <- list(título = "<span style='color:#650d08'>Pindorama</span>",
                subtítulo = "O Brasil é terra indígena",
                legenda = "Map prompt Monday | 2023 | Week 1 | Regions | Plot by @depauladiasleo | Data from: IPEA")


## Paleta de cores -------------------------------------------------------------


brasil_col <- "#650d08"


bg_col <- "#3e5d4f" #242b33"


terra_indígena <- "#b2180f"


txt_col <- "gray99"



## Fontes ----------------------------------------------------------------------


montserrat <- "montserrat"
font_add_google(montserrat)


theme_set(theme_void(base_family = montserrat))


showtext_opts(dpi = 320)
showtext_auto()



## Gráfico ---------------------------------------------------------------------


ggplot() +
  geom_sf(data = br, fill = brasil_col,
          color = brasil_col) +
  geom_sf(data = indígena, fill = terra_indígena,
            color = terra_indígena) +
  theme_void() +
  theme(
    plot.margin = margin(2, 2, 2, 2, "cm"),
    plot.background = element_rect(fill = bg_col,
                                   color = bg_col),
    plot.title = element_markdown(size = 24,
                                  face = "bold",
                                  color = txt_col),
    plot.subtitle = element_markdown(size = 18,
                                     color = txt_col,
                                     margin = margin(6, 0, 24, 0, "pt")),
    plot.title.position = "plot",
    plot.caption = element_text(size = 12,
                                color = txt_col,
                                hjust = 0.5),
    plot.caption.position = "plot"
  ) +
  labs(title = títulos$título,
       subtitle = títulos$subtítulo,
       caption = títulos$legenda)
  

# Exportação -------------------------------------------------------------------


ggsave("W01.png",
       height = 2560,
       width = 2560,
       dpi = 320,
       unit = "px")
