# Read VSRR_Provisional_Drug_Overdose_Death_Counts.csv file
drug_overdose <- read.csv("../data/VSRR_Provisional_Drug_Overdose_Death_Counts.csv", na.strings = c("", "NA"))

# Load libraries
library(ggplot2)
library(plotly)
library(dplyr)

plot_drug_overdose <- function(drug_overdose){

# Number of drug overdose deaths over the course of 2015 - 2018 by state

drug_overdose_states <- drug_overdose %>%
  select(State.Name, Year, Indicator, Data.Value) %>%
  mutate(State.Name = state.abb[match(State.Name ,state.name)]) %>%
  filter(Indicator == c("Number of Drug Overdose Deaths")) %>%
  group_by(State.Name) %>%
  mutate(count = sum(as.numeric(Data.Value)))

# Hover information

drug_overdose_states$hover <- with(drug_overdose_states, paste(State.Name, "<br>", Indicator, ":", count, "<br>"))

# give state boundaries a white border

l <- list(color = toRGB("white"), width = 2)

# specify some map projection/options

g <- list(
  scope = "usa",
  projection = list(type = "albers usa"),
  showlakes = TRUE,
  lakecolor = toRGB("white")
)

plot_map <- plot_geo(drug_overdose_states, locationmode = "USA-states") %>%
  add_trace(
    z = ~count, text = ~hover, locations = ~State.Name,
    color = ~count, colors = "Blues"
  ) %>%
  colorbar(title = "Death count") %>%
  layout(
    title = "2015 - 2018 Number Of Drug Overdose Deaths By State<br>(Hover for breakdown)",
    geo = g
  )

plot_map

}