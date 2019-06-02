library(shiny)
library(dplyr)


# Read in the different datasets.
drug_induced_deaths <- read.csv("data/drug_induced_deaths_1999-2015.csv", 
                           stringsAsFactors = FALSE)
drug_use_by_age <- read.csv("data/drug-use-by-age.csv", 
                            stringsAsFactors = FALSE)
drug_od <- read.csv("data/VSRR_Provisional_Drug_Overdose_Death_Counts.csv", 
                    stringsAsFactors = FALSE)

# Data wrangling the data: drug-use-by-age.
drug_age_data <- drug_use_by_age %>% 
  select(age, marijuana.use, cocaine.use, crack.use, heroin.use, 
         hallucinogen.use, inhalant.use, pain.releiver.use, oxycontin.use, 
         tranquilizer.use, stimulant.use, meth.use, sedative.use)

# Change the column names of the data: drug-use-by-age.
colnames(drug_age_data) <- c("Age", "Marijuana", "Cocaine", "Crack", "Heroin",
                             "Hallucinogen", "Inhalant", "Pain_Reliever",
                             "Oxytocin", "Tranquilizer", "Stimulant", "Meth",
                             "Sedative")

# Data wrangling the data: drug_overdose_death.
drug_od_year_data <- drug_od %>%
  select(Year, Indicator, Data.Value) %>%
  filter(Indicator != "Percent with drugs specified") %>%
  filter(Indicator != "Number of Deaths") %>%
  group_by(Indicator, Year) %>%
  mutate(Data.Value =  as.numeric(gsub(",","", Data.Value))) %>%
  mutate(count = sum(as.numeric(Data.Value))) %>%
  distinct(Indicator, .keep_all = TRUE) %>%
  select(Year, Indicator, count) 

drug_od_month_data <- drug_od %>%
  select(Month, Indicator, Data.Value) %>%
  filter(Indicator != "Percent with drugs specified") %>%
  filter(Indicator != "Number of Deaths") %>%
  group_by(Indicator, Month) %>%
  mutate(Data.Value =  as.numeric(gsub(",","", Data.Value))) %>%
  mutate(count = sum(as.numeric(Data.Value))) %>%
  distinct(Indicator, .keep_all = TRUE) %>%
  select(Indicator, count) 

# Create server to update and render the different plots.
server <- function(input, output) {
  
  output$drug_by_age <- renderPlotly({
    title <- paste0(gsub("_", " ",input$drug_var), " Use vs. Age")
    plot_drug_by_age <- ggplot(drug_age_data) +
      geom_col(mapping = aes_string(x = "Age", y = input$drug_var )) +
      labs(y = paste0(gsub("_", " ",input$drug_var), " Use (%)"), 
           title = title)
    
    return(ggplotly(plot_drug_by_age))
  })
  
  output$pop_vs_deaths <- renderPlotly({
    drug_induced_deaths_select <- drug_induced_deaths %>% 
      filter(State == input$state_var) %>% 
      select(State, Year, Deaths, Population, Crude.Rate)
    
    mytext <- paste0("Year: ", drug_induced_deaths_select$Year, "<br>", 
                     "Crude Rate: ", drug_induced_deaths_select$Crude.Rate)
    
    plot_pop_vs_deaths <- ggplot(drug_induced_deaths_select) +
      geom_point(mapping = aes(x = Deaths, y = Population, 
                               text = mytext)) + 
      labs(title = paste0("Population vs. Deaths From Drugs in ", 
                          input$state_var)) +
      geom_smooth(mapping = aes(x = Deaths, y = Population))
      
  })
  
  output$overdose <- renderPlot({
    
    if(input$overdose == "Indicator") {
      title <- "Drug Overdose Deaths"
      plot_overdose <- ggplot(drug_od_year_data) +
        geom_col(mapping = aes_string(x = names(drug_od_year_data)[1], y = names(drug_od_year_data)[3], fill = input$overdose ), position = "dodge")
      
      return(plot_overdose)
    } 
    if(input$overdose == "Month") {
      plot_overdose <- ggplot(drug_od_month_data) +
        geom_col(mapping = aes_string(x = names(drug_od_month_data)[1], y = names(drug_od_month_data)[3], fill = names(drug_od_month_data)[2] )) +
        facet_wrap(~Indicator) +
        coord_flip()
      
      return(plot_overdose)
    }
  })
  
}