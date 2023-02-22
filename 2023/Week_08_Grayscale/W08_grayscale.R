# Título: Map Prompt Monday | 2023 | Week 08 | Grayscale
# Script por: @depauladiasleo
# Última atualização: fevereiro de 2023


# Descrição:


# Preparação -------------------------------------------------------------------



## Bibliotecas -----------------------------------------------------------------


library(geobr)
library(sf)
library(showtext)
library(tidyverse)


# Importação de dados ----------------------------------------------------------


ti <- geobr::read_indigenous_land() |> 
      filter(abbrev_state %in% c("AC","AP", "AM", "MT",
                                  "PA", "RO", "RR", "TO", "MA"))


amazon <- geobr::read_amazon() 


# Faxina de dados --------------------------------------------------------------





# Visualização -----------------------------------------------------------------


## Texto -----------------------------------------------------------------------


títulos <- list(título = "Terras indígenas na Amazônia Legal",
                legenda = "Map Prompt Monday | 2023 | Week 08 | Grayscale | elaborado por: @depauladiasleo | dados: Ipea")


## Paleta de cores -------------------------------------------------------------


bg <- "gray95"


dark_gray <- "#263238"


## Fontes ----------------------------------------------------------------------


montserrat <- "montserrat"
font_add_google(montserrat)


showtext_opts(dpi = 320)
showtext_auto()


theme_set(theme_void(base_family = montserrat))



## Gráfico ---------------------------------------------------------------------


amazon |> 
  ggplot() +
  geom_sf(fill = "#779fb2") +
  geom_sf(data = ti,
          fill = dark_gray) +
  theme_void() +
  theme(plot.background = element_rect(fill = bg,
                                       color = bg),
        plot.margin = margin(2, 2, 2, 2, "cm"),
        plot.title = element_text(size = 24,
                                  color = dark_gray,
                                  face = "bold",
                                  margin = margin(0 ,0, 24, 0, "pt")),
        plot.title.position = "plot",
        plot.caption = element_text(size = 12,
                                    color = dark_gray,
                                    hjust = 0.5,
                                    margin = margin(24, 0, 0, 0, "pt"))) +
  labs(title = títulos$título,
       caption = títulos$legenda)


# Exportação -------------------------------------------------------------------


ggsave("W08_Grayscale.png",
       dpi = 320,
       unit = "px",
       height = 4104,
       width = 4104)
