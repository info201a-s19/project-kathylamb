library("dplyr")
library("lintr")
library("styler")

# A function that takes in a dataset
# ("Accidental_Drug_Related_Deaths_2012-2018.csv) and returns a list of info
# about it:
get_summary_info <- function(dataset) {
  result <- list()
  
  # the length of the dataset
  result$length <- length(dataset)

  # average of age of accidental drug use death
  average_age <- dataset %>%
    summarise(mean_age = mean(Age, na.rm = TRUE)) %>%
    pull(mean_age)
  result$average_age_of_drug_used_death <- round(average_age)

  # the percentage of male deaths caused by drug use
  male_per <- dataset %>%
    filter(Sex == "Male") %>%
    summarise(male_count = n()) %>%
    pull(male_count)
  result$male_percentage <- round(male_per / nrow(dataset) * 100, 2)

  # the percentage of female deaths caused by drug use
  female_per <- dataset %>%
    filter(Sex == "Female") %>%
    summarise(female_count = n()) %>%
    pull(female_count)
  result$female_percentage <- round(female_per / nrow(dataset) * 100, 2)

  # the race that has the most deaths cause by drug use
  result$most_race <- dataset %>%
    mutate(each_count = 1) %>%
    group_by(Race) %>%
    summarize(race_count = sum(each_count, na.rm = T)) %>%
    filter(race_count == max(race_count, na.rm = T)) %>%
    pull(Race)
  
  # the sex that has the most deaths cause by drug use
  result$most_sex <- dataset %>% 
    mutate(each_count = 1) %>% 
    group_by(Sex) %>% 
    summarize(sex_count = sum(each_count, na.rm = T)) %>% 
    filter(sex_count == max(sex_count, na.rm = T)) %>% 
    pull(Sex)

  return (result)
}
