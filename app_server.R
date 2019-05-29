library(shiny)
library(dplyr)


# Read in the different datasets.
accidental_drug <- read.csv("data/Accidental_Drug_Related_Deaths_2012-2018.csv"
                            , stringsAsFactors = FALSE)
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

# Create server to update and render the different plots.
server <- function(input, output) {
  
  output$histogram <- renderPlotly({
    title <- paste0(gsub("_", " ",input$drug_var), " Use vs. Age")
    plot_histogram <- ggplot(drug_age_data) +
      geom_col(mapping = aes_string(x = "Age", y = input$drug_var )) +
      labs(y = paste0(gsub("_", " ",input$drug_var), " Use (%)"), 
           title = title)
    
    return(ggplotly(plot_histogram))
  })
  
}