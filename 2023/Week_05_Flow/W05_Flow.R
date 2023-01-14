# Título: Map Prompt Monday | 2023 | Week 05 | Flow
# Script por: @depauladiasleo
# Última atualização: janeiro de 2023


# Descrição:


# Preparação -------------------------------------------------------------------



## Bibliotecas -----------------------------------------------------------------


library(osmdata)
library(sf)
library(tidyverse)
library(showtext)


# Importação de dados ----------------------------------------------------------


streets <- 
  getbb("Castanhal") |> 
  opq() |> 
  add_osm_feature(key = "highway", 
                  value = c("motorway", "primary", 
                            "secondary", "tertiary")) |> 
  osmdata_sf()


small_streets <- 
  getbb("Castanhal") |> 
  opq() |> 
  add_osm_feature(key = "highway", 
                  value = c("residential", "living_street",
                            #"unclassified",
                            "service", "footway")) |> 
  osmdata_sf()


water <- 
  getbb("Castanhal") |> 
  opq() |> 
  add_osm_feature(key = "water",
                  value = c("river", "oxbow",
                            "canal", "ditch",
                            "lock", "fish_pass",
                            "lake", "reservoir",
                            "pond", "basin", "lagoon",
                            "stream_pool", "reflecting_pool",
                            "moat")) |> 
  osmdata_sf()


# Faxina de dados --------------------------------------------------------------





# Visualização -----------------------------------------------------------------


## Texto -----------------------------------------------------------------------


títulos <- list(título = "The most important city in the whole wide world",
                subtítulo = "Castanhal, the hometown of the love of my life",
                legenda = "Map Prompt Monday | 2023 | Week 05 | Flow | Chart by: @depauladiasleo | Data from: Open Street Map")


## Paleta de cores -------------------------------------------------------------


bg_col <- "#484A47"
  
rua_col <- "#F6E8EA"

av_col <- "#EF626C"
  
water_col <- "#84DCCF"

txt_col <- "gray97"


## Fontes ----------------------------------------------------------------------


montserrat <- "montserrat"
font_add_google(montserrat)


theme_set(theme_void(base_family = montserrat))


showtext_opts(dpi = 320)
showtext_auto()


## Gráfico ---------------------------------------------------------------------


ggplot() +
  geom_sf(data = small_streets$osm_lines,
          color = rua_col,
          linewidth = 0.15) +
  geom_sf(data = streets$osm_lines,
          color = av_col,
          linewidth = 0.5) +
  geom_sf(data = water$osm_polygons,
          color = water_col,
          fill = water_col,
          linewidth = 0.5) +
  theme_void() +
  theme(plot.background = element_rect(fill = bg_col,
                                       color = bg_col),
        plot.title = element_text(size = 24,
                                  face = "bold",
                                  color = txt_col),
        plot.subtitle = element_text(size = 18,
                                     color = txt_col,
                                     margin = margin(6, 0, 24, 0, "pt")),
        plot.title.position = "plot",
        plot.caption = element_text(size = 16,
                                    #face = "bold",
                                    color = txt_col,
                                    margin = margin(20, 0, 0, 0, "pt"),
                                    hjust = 0.5),
        plot.caption.position = "plot",
        plot.margin = margin(2, 2, 2, 2, "cm")) +
  labs(title = títulos$título,
       subtitle = títulos$subtítulo,
       caption = títulos$legenda)




# Exportação -------------------------------------------------------------------


ggsave("W05_Flow.png",
       height = 3840,
       width = 3840,
       unit = "px",
       dpi = 320)
