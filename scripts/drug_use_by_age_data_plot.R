# Read drug-use-by-age.csv file
drug_age_data <- read.csv("data/drug-use-by-age.csv")

# Load libraries
library(ggplot2)
library(plotly)
library(dplyr)

# Does drug use increase as you get older?

drug_age_plot <- function(drug_age_data){

# Convert percentages from X.use columns to whole numbers to compare

drug_age_data_whole <- drug_age_data %>%
  select(age, n, alcohol.use, marijuana.use, cocaine.use, crack.use, heroin.use, hallucinogen.use, inhalant.use,
         pain.releiver.use, oxycontin.use, tranquilizer.use, stimulant.use, meth.use, sedative.use
  ) %>%   
  rename(Number_of_users = n) %>%
  mutate_at(vars(ends_with(".use")), list(~(./100) * Number_of_users))

# Plot data

plot_drug_age <- ggplot(drug_age_data_whole) +
  geom_col(
    mapping = aes(x = age, y = Number_of_users)
  ) +
  ggtitle("Number of users by age group")

plot(plot_drug_age)
}