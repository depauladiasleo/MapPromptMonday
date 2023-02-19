# Título:
# Script por:
# Última atualização:


# Descrição:


# Preparação -------------------------------------------------------------------



## Bibliotecas -----------------------------------------------------------------


library(biscale)
library(geobr)
library(readxl)
library(sf)
library(showtext)
library(tidyverse)


# Importação de dados ----------------------------------------------------------


pecuária_focos <- read_xlsx("df_pecuária_focos.xlsx") |> 
                janitor::clean_names()


uf <- geobr::read_state(code_state = "all", year = 2017, simplified = FALSE)


# Faxina de dados --------------------------------------------------------------


df_tidy <- 
  uf |> 
  select(name_state, geom) |> 
  left_join(pecuária_focos, by = c("name_state" = "unidade_da_federacao")) |> 
  select(name_state:focos_de_calor_total, geom) |> 
  bi_class(numero_de_cabecas, focos_de_calor_total, style = "equal", dim = 4)



# Visualização -----------------------------------------------------------------


## Texto -----------------------------------------------------------------------

títulos = list(título = "uso do solo e focos de calor no Brasil (2016−2017)",
               subtítulo = "análise da atividade pecuária (número de cabeças)",
               leg = "Map Prompt Monday | 2023 | Week 07 | Bivariate | map by: @depauladiasleo | data from: IBGE & Inpe")

## Paleta de cores -------------------------------------------------------------


title_col <- "gray10"

txt_col <- "gray30"


## Fontes ----------------------------------------------------------------------

open_sans <- "open sans"
font_add_google(open_sans)


theme_set(theme_void(base_family = open_sans))


showtext_opts(dpi = 300)
showtext_auto()



## Gráfico ---------------------------------------------------------------------


mapa <-
  df_tidy |> 
  ggplot() +
  geom_sf(aes(fill = bi_class),
          color = "gray90",
          linewidth = 0.2) +
  bi_scale_fill(pal = "GrPink2", dim = 4, 
                flip_axes = TRUE, 
                rotate = FALSE) +
  theme_void() +
  theme(legend.position = "none",
         plot.margin = margin(2, 2, 2, 2, "cm"),
        plot.title = element_text(size = 24,
                                  color = title_col,
                                  face = "bold",
                                  hjust = 0.5),
        plot.subtitle = element_text(size = 18,
                                     color = txt_col,
                                     margin = margin(10, 0, 26, 0, "pt"),
                                     hjust = 0.5),
        plot.title.position = "plot",
        plot.caption = element_text(size = 12,
                                    color = txt_col,
                                    margin = margin(36, 0, 0, 0, "pt"),
                                    hjust = 0.5),
        plot.caption.position = "plot") +
  labs(title = títulos$título,
       subtitle = títulos$subtítulo,
       caption = títulos$leg)


### Legenda --------------------------------------------------------------------


legenda <- bi_legend(pal = "GrPink2",
                    dim = 4,
                    xlab = "número de cabeças",
                    ylab = "número de focos de calor",
                    flip_axes = TRUE,
                    size = 9)



### Versão final ---------------------------------------------------------------
### Combinar mapa e legenda


mapa_final <- 
  cowplot::ggdraw() + 
  cowplot::draw_plot(mapa, 0, 0, 1, 1) +
  cowplot::draw_plot(legenda, 0.15, 0.15, 0.2, 0.2)


# Exportação -------------------------------------------------------------------


ggsave("Week_07_Bivariate.png", 
       plot = mapa_final,
       unit = "px", 
       bg = "gray99",
       height = 4100,
       width = 5500,
       dpi = 300)
