# standardize data for ERDDAP and integrated Data Collection
library(here)
library(tidyverse)

drifter_1  <- read_csv(here("original_data", "2022_Argos_Drifters_NRT_a61d_2e9c_40b6.csv"))
drifter_2 <- read_csv(here("original_data", "2022_Argos_Drifters_NRT_df43_4065_ff64.csv"))

# Determine polygon of measurement area
drifter <- bind_rows(drifter_1, drifter_2) |> 
  rename(lat = "latitude (degrees_north)",
         lon = "longitude (degrees_east)") |> 
  drop_na(lat, lon) 


polygon_coords <- function(df) {
  df <- df %>% tidyr::drop_na(lat, lon) %>% 
    dplyr::mutate(lon = dplyr::if_else(lon < 0, 360 + lon, lon))
  ch <- chull(df)
  coords <- df[c(ch, ch[1]), ]
  coords <- paste(coords$lat, coords$lon, sep = ",", collapse = " ")
  coords
}
#copy output from console into metadata intake form polygon coordinates  
polygon_coords(drifter)
