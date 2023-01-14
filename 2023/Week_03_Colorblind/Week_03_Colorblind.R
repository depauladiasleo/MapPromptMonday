# Título: Map Prompt Monday | Week 03 | Colorblind
# Script por: @depauladiasleo
# Última atualização: janeiro de 2023.


# Descrição:


# Preparação -------------------------------------------------------------------



## Bibliotecas -----------------------------------------------------------------


library(geobr)
library(readxl)
library(showtext)
library(sf)
library(tidyverse)


# Importação de dados ----------------------------------------------------------


conservation <- geobr::read_conservation_units()


deforesting <- read_xlsx("DesmatamentoUC.xlsx")


# Faxina de dados --------------------------------------------------------------


conservation_tidy <- 
  conservation |> 
  select(name_conservation_unit, creation_year, geom)


deforesting_tidy <- 
  deforesting |> 
  select(NomeUC, AreaKm2, Floresta:Incremento2021) |> 
  mutate(NomeUC = str_to_upper(NomeUC),
    Floresta = as.numeric(Floresta))


brasil <- read_country()


## Mesclagem ---------------------------------------------------------------


df <- 
  deforesting_tidy |> 
  left_join(conservation_tidy, by = c("NomeUC" = "name_conservation_unit"))
  

# Visualização -----------------------------------------------------------------


## Texto -----------------------------------------------------------------------


títulos <- list(título = "Unidades federais de conservação no Brasil",
                legenda = "Map Prompt Monday | Semana 03 | Daltonismo | Gráfico por: @depauladiasleo | Dados: Inpe")


## Paleta de cores -------------------------------------------------------------


bg_col <- "#114747"


## Fontes ----------------------------------------------------------------------


montserrat <- "montserrat"
font_add_google(montserrat)


theme_set(theme_void(base_family = montserrat))


showtext_opts(dpi = 320)
showtext_auto()


## Gráfico ---------------------------------------------------------------------



df |>
  ggplot() +
  geom_sf(
    data = brasil,
    aes(geometry = geom),
    fill = "gray90",
    color = "gray99",
    linewidth = 0.05,
    alpha = 0.25
  ) +
  geom_sf(aes(geometry = geom, fill = Floresta),
          color = "gray99",
          linewidth = 0.05) +
  scale_fill_distiller(
    palette = "YlGn",
    direction = 1,
    label = scales::label_number()
  ) +
  theme_void() +
  theme(
    plot.background = element_rect(fill = bg_col,
                                   color = bg_col),
    plot.margin = margin(2, 2, 2, 2, "cm"),
    plot.title = element_text(size = 24,
                            face = "bold",
                            color = "gray99",
                            hjust = 0.5,
                            margin = margin(0, 0, 24, 0, "pt")),
    plot.title.position = "plot",
    plot.caption = element_text(size = 12,
                                color = "gray99",
                                hjust = 0.5,
                                margin = margin(24, 0, 0, 0, "pt")),
    plot.caption.position = "plot",
    legend.position = "top",
    legend.title = element_text(
      size = 12,
      face = "bold",
      color = "gray97"
    ),
    legend.text = element_text(size = 10,
                               color = "gray97")
  ) +
  guides(
    fill = guide_colorbar(
      title = "Área coberta por floresta (Km2)",
      barheight = unit(0.15, 'cm'),
      barwidth = unit(8, 'cm'),
      title.position = 'top',
      ticks.colour = "gray95",
      frame.colour = NA,
      direction = 'horizontal'
    )
  ) +
  labs(title = títulos$título,
       caption = títulos$legenda)


#Exportação -------------------------------------------------------------------


ggsave("Week_03_ColorBlind.png",
       height = 3840,
       width = 3840,
       unit = "px",
       dpi = 320)
