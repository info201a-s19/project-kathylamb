library(shiny)
library(plotly)

# Create a page for the Overview tab.
overview_content <- fluidPage(
  includeCSS("styles.css"),
  h1("Overview"),
  tags$section(
    list(
      p("This project is looking to see if there is a correlation between
             drug use and deaths. Some questions we are asking are if drug use
             increases as age increases or if the number of deaths have
             increased over the years for the younger generation. The data
             that we are using comes from",
             a(href = "https://data.world/fivethirtyeight/drug-use-by-age",
                    "Data World"), ",",  
             a(href = paste0("https://catalog.data.gov/dataset/accidental",
                                 "-drug-related-deaths-january-2012-sept-2015"),
                   "Data.gov"), ", and ",
             a(href = paste0("https://data.world/health/drug-induced-deaths"),
                    "Data World"), 
            ". One of the datasets gives information about each age group and
             each column gives the frequency and use of a different drug. 
             We have another dataset that gives information about the number 
             of drug overdose deaths or gives the number of deaths from a 
             specifc drug in a specific state from 2015-2018. The last dataset
             that we are using gives information about drug induced deaths in
             all of the states from 1999-2015."),
      # Citation: Toxicoman-Substance Abuse. 2018. Image. 
      # https://commons.wikimedia.org/wiki/File:Toxicoman_-_Substance_
      # abuse.jpg.
      img(src = paste0("https://upload.wikimedia.org/wikipedia/commons/",
                       "thumb/8/8e/Toxicoman_-_Substance_abuse.jpg/640px",
                       "-Toxicoman_-_Substance_abuse.jpg"))
    )
  )
)

# Create an Overview tab.
overview_panel <- tabPanel(
  "Overview",
  overview_content
)

# Create a sidebar panel for the data: drug-use-by-age.
age_sidebar_content <- sidebarPanel(
  selectInput(
    "drug_var",
    label = "Choose Drug",
    choice = list("Marijuana" = "Marijuana", "Cocaine" = "Cocaine",
                  "Crack" = "Crack", "Heroin" = "Heroin",
                  "Hallucinogen" = "Hallucinogen", "Inhalant" = "Inhalant",
                  "Pain Reliever" = "Pain_Reliever", "Oxytocin" = "Oxytocin",
                  "Tranquilizer" = "Tranquilizer", "Stimulant" = "Stimulant",
                  "Meth" = "Meth", "Sedative" = "Sedative"
                  ),
    selected = "Inhalant"
  )
)

# Create a main panel for the data: drug-use-by-age.
age_main_content <- mainPanel(
  plotlyOutput("drug_by_age"), 
  p("The question we are looking to understand is to see if the use of
         drugs increases with age. From this chart, it shows the percentage of
         drug use for each age group based on the selected drug. We are able to
         analyze which drugs are used more by which age group which could give
         us an idea of why certain people die at a certain age due to drugs.
         By looking at the percent use of the drug and the age, it could let us
         know if age and the type of drug used could be correlated to death by 
         drug use.")
)

# Create a tab panel for the data: drug-use-by-age.
age_panel <- tabPanel(
  "Drug Use vs. Age",
  sidebarLayout(
    age_sidebar_content,
    age_main_content
  )
)

# Create a tab panel for the data: drug_overdose_death.
overdose_panel <- tabPanel(
  "Drug Overdose Death",
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        inputId = "overdose",
        label = "Choose an option",
        choices = c("Indicator", "Month")
      )
    ),
    mainPanel(
      plotOutput("overdose")
    )
  )
)

# Create a sidebar panel for the data: drug_induced_deaths_1999-2015.
induced_deaths_sidebar_content <- sidebarPanel(
  selectInput(
    "state_var",
    label = "Choose State",
    choice = list("Alabama" = "Alabama", "Alaska" = "Alaska",
                  "Arizona" = "Arizona", "California" = "California",
                  "Colorado" = "Colorado", "Connecticut" = "Connecticut",
                  "Delaware" = "Delaware", "District of Columbia" = 
                  "District of Columbia", "Florida" = "Florida", "Georgia" = 
                  "Georgia", "Hawaii" = "Hawaii", "Idaho" = "Idaho",
                  "Illinois" = "Illinois", "Indiana" = "Indiana", "Iowa" =
                  "Iowa", "Kansas" = "Kansas", "Kentucky" = "Kentucky", 
                  "Louisiana" = "Louisiana", "Maine" = "Maine", "Maryland" =
                  "Maryland", "Massachusetts" = "Massachusetts", "Michigan" = 
                  "Michigan", "Minnesota" = "Minnesota", "Mississippi" = 
                  "Mississippi", "Missouri" = "Missouri", 
                  "Montana" = "Montana", "Nebraska" = "Nebraska", "Nevada" =
                  "Nevada", "New Hampshire" = "New Hampshire", "New Jersey" =
                  "New Jersey", "New Mexico" = "New Mexico", "New York" = 
                  "New York", "North Carolina" = "North Carolina",
                  "North Dakota" = "North Dakota", "Ohio" = "Ohio",
                  "Oklahoma" = "Oklahoma", "Oregon" = "Oregon",
                  "Pennsylvania" = "Pennsylvania", "Rhode Island" =
                  "Rhode Island", "South Carolina" = "South Carolina",
                  "South Dakota" = "South Dakota", "Tennessee" = "Tennessee",
                  "Texas" = "Texas", "Utah" = "Utah", "Vermont" = "Vermont",
                  "Virginia" = "Virginia", "Washington" = "Washington", 
                  "West Virginia" = "West Virginia", "Wisconsin" = "Wisconsin",
                  "Wyoming" = "Wyoming"),
    selected = "Alabama"
  )
)

# Create a main panel for the data: drug_induced_deaths_1999-2015.
induced_deaths_main_content <- mainPanel(
  plotlyOutput("pop_vs_deaths")
)

# Create a tab panel for the data: drug_induced_deaths_1999-2015.
induced_deaths_panel <- tabPanel(
  "Population vs. Deaths",
  sidebarLayout(
    induced_deaths_sidebar_content,
    induced_deaths_main_content
  )
)

# Create a navigation bar that allows you to navigate through multiple pages.
ui <- navbarPage(
  "Death Caused By Drug Use",
  overview_panel,
  age_panel,
  induced_deaths_panel,
  overdose_panel
)