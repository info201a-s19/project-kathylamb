# Read Accidental_Drug_Related_Deaths_2012-2018.csv file
accident_drug <- read.csv("../data/Accidental_Drug_Related_Deaths_2012-2018.csv", na.strings = c("", "NA"), stringsAsFactors = FALSE)

# Load libraries
library(leaflet)
library(dplyr)

# Focus on places of death within CT and how race, sex, and COD (cause of death) relate

plot_accident_drug <- function(accident_drug){

# Manipulate data to get rid of NA values and show longitude and latitude for map

accident_drug <- accident_drug %>%
  select(DeathCityGeo, DateType, COD, Sex, Race) %>%
  filter(DateType == "DateofDeath") %>%
  group_by(DateType) %>%
  na.omit() %>%
  mutate(count = n()) %>%
  mutate(longitude = sub(".*\\([^,]+,\\s*(-?\\d+(?:\\.\\d+)?).*", "\\1", DeathCityGeo)) %>%
  mutate(latitude = sub(".*\\((-?\\d+(?:\\.\\d+)?).*", "\\1", DeathCityGeo))

# Create a new map

locations <- accident_drug

# Pop up information when circle is clicked on map

content <- paste(sep = "<br/>",
                 accident_drug$Sex, accident_drug$Race, accident_drug$COD)
# Color palette

palette_fn <- colorFactor(palette = "Set3", domain = accident_drug$Race)

# Plot map with information from data frame

plot_map <- leaflet(data = locations) %>%
  addProviderTiles("CartoDB.Positron") %>%
  setView(lng = -72.7, lat = 41.6, zoom = 10) %>%
  addCircles(
    lat = ~as.numeric(latitude),
    lng = ~as.numeric(longitude),
    stroke = FALSE,
    popup = ~content,
    radius = 1200,
    color = ~palette_fn(Race),
    fillOpacity = 3
  ) %>%
  addLegend(
    position = "bottomright",
    title = "Drug deaths based on race",
    pal = palette_fn,
    values = ~Race,
    opacity = 1
  )

plot_map

}