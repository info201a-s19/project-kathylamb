# Read VSRR_Provisional_Drug_Overdose_Death_Counts.csv file
drug_overdose <- read.csv("data/VSRR_Provisional_Drug_Overdose_Death_Counts.csv", na.strings = c("", "NA"))

# Load libraries
library(ggplot2)
library(plotly)
library(dplyr)
  
plot_drug_overdose <- function(drug_overdose){

  # Number of drug overdose deaths over the course of 2015 - 2018 by state
  
  drug_overdose <- drug_overdose %>%
    select(Indicator, Data.Value) %>%
    filter(!Indicator %in% c("Number of Deaths", "Number of Drug Overdose Deaths", "Percent with drugs specified")) %>%
    group_by(Indicator) %>%
    mutate(count = sum(as.numeric(Data.Value))) %>%
    distinct(Indicator, .keep_all = TRUE)
  
  # Create data for the graph, only select top 10 of count.
  x <-  head(drug_overdose$count, 9)
  labels <-  c("Cocaine (T40.5)", "Heroin (T40.1)", "Methadone (T40.3)", "Natural & semi-synthetic opioids (T40.2)",
               "Natural & semi-synthetic opioids, incl. methadone (T40.2, T40.3) ", "Natural, semi-synthetic, & synthetic opioids, incl. methadone (T40.2-T40.4)",
               "Opioids (T40.0-T40.4,T40.6)", "Psychostimulants with abuse potential (T43.6)", "Synthetic opioids, excl. methadone (T40.4)"
               )
  
  # Set percentages for labels
  piepercent <- round(100 * x / sum(x), 1)
  
  # Plot the chart.
  drug_pie <- pie(x, labels = piepercent, main = "9 deadliest drugs from 2015 - 2018", col = rainbow(length(x)), radius = 0.3)
  legend("top", labels, cex = 0.6, fill = rainbow(length(x)))
 
  drug_pie 
}