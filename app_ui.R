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
  p("This chart is helping us answer the question if drug use increases as
    age increases by comparing the percent drug use of different drugs to
    the age groups.")
)

# Create a tab panel for the data: drug-use-by-age.
age_panel <- tabPanel(
  "Drug Use vs. Age",
  sidebarLayout(
    age_sidebar_content,
    age_main_content
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
  plotlyOutput("pop_vs_deaths"),
  p("This chart is helping us understand if there is a correlation between
    the increase in population growth every year with the number of deaths due
    to drug overdoses by looking at different states.")
)

# Create a tab panel for the data: drug_induced_deaths_1999-2015.
induced_deaths_panel <- tabPanel(
  "Population vs. Deaths",
  sidebarLayout(
    induced_deaths_sidebar_content,
    induced_deaths_main_content
  )
)

# Create a sidebar panel for the data: drug_overdose_death.
overdose_sidebar_content <- sidebarPanel(
  selectInput(
    "state_var2",
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
  ),
  radioButtons(
    "year_var",
    label = "Choose a Year",
    choices = list("2015" = "2015", "2016" = "2016", "2017" = "2017", 
                   "2018" = "2018"),
    selected = "2015"
  )
)

# Create a main panel for the data: drug_overdose_death.
overdose_main_content <- mainPanel(
  plotlyOutput("drug_od_death"),
  p("This chart is helping us understand the correlation between the number of 
    drug overdose deaths and the months by looking at a specific state and
    year.")
)

# Create a tab panel for the data: drug_overdose_death.
overdose_panel <- tabPanel(
  "Drug Overdose Death",
  sidebarLayout(
    overdose_sidebar_content,
    overdose_main_content
  )
)

# Create a tab panel for the summary.
summary_content <- fluidPage(
  h1("Summary Takeaways"),
  tags$section(
    list(
      p("From the 'Drug Use vs. Age' bar chart, it is clear that the ages of 
        most use of drugs is from 16 to 20. We can also see a general decline in 
        drug use as the age increases. This could possibly explain why certain 
        people die at a young age due to the use of drugs."),
      fluidRow(
        column(6, selectInput(inputId = "age_trend_rb", label = "Select Drug:",
                  choices = list("Marijuana"= "Marijuana", "Cocaine" = "Cocaine", "Crack" = "Crack", "Heroin" = "Heroin",
                              "Hallucinogen" = "Hallucinogen", "Inhalant" = "Inhalant", "Pain_Reliever" = "Pain_Reliever", 
                              "Oxytocin" = "Oxytocin", "Tranquilizer" = "Tranquilizer", "Stimulant" = "Stimulant", "Meth" = "Meth",
                              "Sedative" = "Sedative"))),
        column(6, tableOutput("age_drug_trend"))
      ),
      p("From the 'Population vs. Deaths' scatter plot, it shows that there is a 
        positive correlation between the population growth of a state and the 
        deaths due to drug overdose every year. In all 50 states included in the 
        dataset, we generally see deaths caused by drug overdose increases as 
        the population grows. Yet, there could be other factors that could be 
        in play such as drug laws."),
      p("From the 'Population vs. Deaths' bar chart, we can see that most deaths 
        of drug overdose occur at the end of the years (October, November, 
        December), and least of them occur at the beginning of the years
        (January, February, March). However, from 2015 to 2018, we can see an 
        increase in the least drug overdose deaths months. For example, drug 
        overdose deaths have increased from a total of 378 to 413 deaths in the 
        first three months of the years in Alabama; drug overdose deaths have 
        also increased from a total of 2171 to 2365 deaths in the first three 
        months of the years in Alabama. This pattern can be seen throughout all 
        53 states included in the dataset. Below is an table of 10 example 
        states from the dataset that shows this pattern."),
      fluidRow(
        tableOutput("overdose_month_summary")
      ),
      p("To answer our general question: 'Does drug use increases as age 
        increases? Have the number of deaths increased over the years for 
        the younger generation?' Drug use decreases as age increases. The 
        number of drug overdose deaths peeked in 2017 and decreased in 2018.")
      )
  )
)

summary_panel <- tabPanel(
  "Summary Takeaways",
  summary_content
)

# Create a navigation bar that allows you to navigate through multiple pages.
ui <- navbarPage(
  "Death Caused By Drug Use",
  overview_panel,
  age_panel,
  induced_deaths_panel,
  overdose_panel,
  summary_panel
)