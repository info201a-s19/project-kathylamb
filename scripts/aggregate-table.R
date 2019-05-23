# Aggregate Table Script
# 
# Load neccessary libraries
library(ggplot2)
library(dplyr)
library(knitr)

# Drug Overdose Dataframe
drug_od_df <- read.csv("data/VSRR_Provisional_Drug_Overdose_Death_Counts.csv", 
                       stringsAsFactors = FALSE)


# Take out commas to later modify as.numeric
drug_od_df$Data.Value <- gsub(",", "", drug_od_df$Data.Value)
  
# Modify dataframe down to 2018 and by chronological month
death_month <- drug_od_df %>% 
  group_by(Year) %>%
  select(Year, Month, Indicator, Data.Value) %>% 
  filter(Month == unique(Month))  %>%
  filter(Year == 2018) %>% 
  arrange(Year, factor(Month, level = month.name), Indicator, Data.Value)

# Modify dataframe to x # of months; number of deaths and respective indicator
death_by_year <- death_month %>% 
  group_by(Month) %>% 
  filter(Indicator != "Number of Deaths") %>%
  filter(Indicator != "Number of Drug Overdose Deaths") %>% 
  filter(Indicator != "Percent with Drugs Specified") %>% 
  mutate(Data.Value = as.numeric(as.character(Data.Value))) %>% 
  filter(Data.Value == max(Data.Value)) %>% 
  filter(Month == unique(Month))

# Function to call for aggregate table: "VSSR Provisional Drug Overdose"
#
# This graph answers the question of:
# What is the monthly breakdown of type of drug use by most number of deaths?
drug_od_table <- function(dataframe) {
  kable(dataframe)
}



