# Aggregate Table Script
#
# Load neccessary libraries
library(ggplot2)
library(dplyr)
library(knitr)
library(lintr)
library(styler)

# Drug Overdose Dataframe
drug_od_df <- read.csv("data/VSRR_Provisional_Drug_Overdose_Death_Counts.csv",
  stringsAsFactors = FALSE
)

# Function to call for aggregate table: "VSSR Provisional Drug Overdose"
#
# This table answers the question of:
# What is the monthly breakdown of type of drug use by most number of deaths?
# (dataframe should be 'drug_od_df')
drug_od_table <- function(dataframe) {

  # Take out commas to later modify as.numeric
  dataframe$Data.Value <- gsub(",", "", dataframe$Data.Value)

  # Modify dataframe down to 2018 and by chronological month
  dataframe <- dataframe %>%
    group_by(Year) %>%
    select(Year, Month, "Drug" = Indicator, "Deaths" = Data.Value) %>%
    filter(Month == unique(Month)) %>%
    filter(Year == 2018) %>%
    arrange(Year, factor(Month, level = month.name), Drug, Deaths)

  # Modify dataframe to x # of months; number of deaths and respective indicator
  dataframe <- dataframe %>%
    group_by(Month) %>%
    filter(Drug != "Number of Deaths") %>%
    filter(Drug != "Number of Drug Overdose Deaths") %>%
    filter(Drug != "Percent with Drugs Specified") %>%
    mutate(Deaths = as.numeric(as.character(Deaths))) %>%
    filter(Deaths == max(Deaths)) %>%
    filter(Month == unique(Month))

  kable(dataframe)
}
