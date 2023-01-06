# Título: MapPromptMonday | 2023 | Week 02 | Heatmap
# Script por: Leonardo Dias de Paula
# Última atualização: janeiro de 2023.


# Descrição:


# Preparação ---------------------------------------------------


## Pacotes



## Bibliotecas


library(tidyverse)
library(sf)
library(spData)
library(showtext)
library(NatParksPalettes)



# Importação de dados ------------------------------------------


tech_df <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-07-19/technology.csv')


iso_3166 <- read_csv("ISO_3166.csv") |> 
  janitor::clean_names() |> 
  select(alpha_3, alpha_2, name, intermediate_region)


sa_geom <- world |> 
  filter(subregion == "South America") |> 
  select(iso_a2, geom)


# Faxina de dados ----------------------------------------------


sa_yfv <- 
  tech_df |> 
  select(variable, label, iso3c, year, value) |> 
  filter(variable == "YFV") |> 
  left_join(iso_3166, by = c("iso3c" = "alpha_3")) |>  
  left_join(sa_geom, by = c("alpha_2" = "iso_a2")) |> 
  filter(intermediate_region == "South America") |> 
  select(!c(iso3c, alpha_2, intermediate_region)) |>  
  st_as_sf()


# Visualização -----------------------------------------------------------------



## Paleta de cores -------------------------------------------------------------


bg_col <- "#4B634A"
  

txt_col <- "gray97"



## Fontes ----------------------------------------------------------------

montserrat <- "montserrat"
font_add_google(montserrat)


theme_set(theme_void(base_family = montserrat))

showtext_opts(dpi = 320)
showtext_auto()


## Textos ----------------------------------------------------------------------


títulos <- list(título = "Cobertura vacinal para Febre Amarela na América do Sul",
                subtítulo = "Enfrentar a baixa cobertura vacinal para uma doença endêmica em parte da região ainda é um desafio",
                guide = "% de crianças vacinadas para Febre Amarela",
                crédito = "MapPromptMonday | 2023 | Gráfico por: @depauladiasleo | Dados: NBER")


## Mapa de dois anos, usando como 'facets' -------------------------------



  sa_yfv |> 
  filter(year == 2009 | year == 2019) |> 
  ggplot() +
  geom_sf(aes(fill = value), 
          color = bg_col, 
          size = 0.1) +
  NatParksPalettes::scale_fill_natparks_c("Arches2", -1,
                                          breaks = c(0, 25, 50, 75, 100)) +
  theme_void() +
  theme(
    legend.position = "top",
    plot.background = element_rect(fill = bg_col, 
                                   color = NA),
    plot.margin = margin(2, 2, 2, 2, unit = "cm"),
    plot.title = element_text(size = 24,
                              color = txt_col,
                              face = "bold",
                              lineheight = 1.1,
                              hjust = 0.5),
    plot.subtitle = element_text(size = 14,
                                 color = txt_col,
                                 lineheight = 1.2,
                                 margin = margin(12, 0, 28, unit = "pt"),
                                 hjust = 0.5),
    plot.title.position = "panel",
    plot.caption = element_text(size = 12,
                                color = txt_col,
                                hjust = 0.5,
                                margin = margin(28, 0, 0, 0, "pt")),
    plot.caption.position = "plot",
    panel.spacing = unit(1, "cm"),
    panel.grid = element_blank(),
    legend.title = element_text(size = 10,
                                face = "bold",
                                color = txt_col,
                                margin = margin(12, 0, 6, 0, "pt")),
    legend.text = element_text(size = 9,
                              color = txt_col),
    strip.text = element_text(size = 14, 
                              face = "bold", 
                              color = txt_col,
                              hjust = 0,
                              margin = margin(t = 10, b = 12, unit = "pt"))
  ) +
  guides(
    fill = guide_colorbar(
      barheight = unit(0.15, 'cm'),
      barwidth = unit(15, 'cm'),
      title.position = 'top',
      ticks.colour = "gray95",
      frame.colour = NA,
      direction = 'horizontal')) +
  facet_grid(. ~ year) +
  coord_sf() +
  labs(
    title = títulos$título,
    subtitle = títulos$subtítulo,
    fill = títulos$guide,
    caption = títulos$crédito)



# Exportação ---------------------------------------------------


ggsave("Week_02_Heatmap.png",
       width = 3840, height = 2170,
       dpi = 320, units = "px")

