# Título: Map Prompt Monday | 2023 | Week 04 | Film/TV
# Script por: @depauladiasleo
# Última atualização: janeiro de 2023


# Descrição:


# Preparação -------------------------------------------------------------------



## Bibliotecas -----------------------------------------------------------------


library(ggtext)
library(osmdata)
library(sf)
library(tidyverse)
library(showtext)


# Importação de dados ----------------------------------------------------------


city <- "Pittsburgh"

streets <- 
  getbb(city) |> 
  opq() |> 
  add_osm_feature(key = "highway", 
                  value = c("motorway", "primary", 
                            "secondary", "tertiary")) |> 
  osmdata_sf()


small_streets <- 
  getbb(city) |> 
  opq() |> 
  add_osm_feature(key = "highway", 
                  value = c("residential", "living_street",
                            #"unclassified",
                            "service", "footway")) |> 
  osmdata_sf()


water <- 
  getbb(city) |> 
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


títulos <- list(título = "Pittsburgh, where the story of the Pearson family starts",
                subtítulo = "This is <b>Us</b> (NBC)",
                legenda = "Map Prompt Monday | 2023 | Week 04 | Film/TV | Chart by: @depauladiasleo | Data from: Open Street Map")


## Paleta de cores -------------------------------------------------------------


bg_col <- "#001E33"
  
rua_col <- "#F6E8EA"
  
av_col <- "#e2a726"
  
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
          linewidth = 0.1) +
  geom_sf(data = streets$osm_lines,
          color = av_col,
          linewidth = 0.25) +
  geom_sf(data = water$osm_polygons,
          color = water_col,
          fill = water_col,
          linewidth = 0.5) +
  geom_sf(data = water$osm_multipolygons,
          color = water_col,
          fill = water_col) +
  theme_void() +
  theme(plot.background = element_rect(fill = bg_col,
                                       color = bg_col),
        plot.title = element_text(size = 24,
                                  face = "bold",
                                  color = txt_col),
        plot.subtitle = element_markdown(size = 18,
                                     color = av_col,
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
       caption = títulos$legenda) +
  coord_sf(xlim = c(-80.095517, -79.865728), ylim = c(40.36152, 40.5012021))


# Exportação -------------------------------------------------------------------


ggsave("W05_Flow.png",
       height = 3840,
       width = 3840,
       unit = "px",
       dpi = 320)

