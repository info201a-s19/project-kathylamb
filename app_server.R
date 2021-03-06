library(shiny)
library(dplyr)
library(lintr)
library(styler)

# Read in the different datasets.
drug_induced_deaths <- read.csv("data/drug_induced_deaths_1999-2015.csv",
  stringsAsFactors = FALSE
)
drug_use_by_age <- read.csv("data/drug-use-by-age.csv",
  stringsAsFactors = FALSE
)
drug_od <- read.csv("data/VSRR_Provisional_Drug_Overdose_Death_Counts.csv",
  stringsAsFactors = FALSE
)

# Data wrangling the data: drug-use-by-age.
drug_age_data <- drug_use_by_age %>%
  select(
    age, marijuana.use, cocaine.use, crack.use, heroin.use,
    hallucinogen.use, inhalant.use, pain.releiver.use, oxycontin.use,
    tranquilizer.use, stimulant.use, meth.use, sedative.use
  )

# Change the column names of the data: drug-use-by-age.
colnames(drug_age_data) <- c(
  "Age", "Marijuana", "Cocaine", "Crack", "Heroin",
  "Hallucinogen", "Inhalant", "Pain_Reliever",
  "Oxytocin", "Tranquilizer", "Stimulant", "Meth",
  "Sedative"
)

# Create server to update and render the different plots.
server <- function(input, output) {
  output$drug_by_age <- renderPlotly({
    title <- paste0(gsub("_", " ", input$drug_var), " Use vs. Age")
    plot_drug_by_age <- ggplot(drug_age_data) +
      geom_col(mapping = aes_string(x = "Age", y = input$drug_var)) +
      labs(
        y = paste0(gsub("_", " ", input$drug_var), " Use (%)"),
        title = title
      )

    return(ggplotly(plot_drug_by_age))
  })

  output$pop_vs_deaths <- renderPlotly({
    drug_induced_deaths_select <- drug_induced_deaths %>%
      filter(State == input$state_var) %>%
      select(State, Year, Deaths, Population, Crude.Rate)

    mytext <- paste0(
      "Year: ", drug_induced_deaths_select$Year, "<br>",
      "Crude Rate: ", drug_induced_deaths_select$Crude.Rate
    )

    plot_pop_vs_deaths <- ggplot(drug_induced_deaths_select) +
      geom_point(mapping = aes(
        x = Deaths, y = Population,
        text = mytext
      )) +
      labs(title = paste0(
        "Population vs. Deaths From Drugs in ",
        input$state_var
      )) +
      geom_smooth(mapping = aes(x = Deaths, y = Population))

    return(ggplotly(plot_pop_vs_deaths))
  })

  output$drug_od_death <- renderPlotly({
    drug_deaths_overdose <- drug_od %>%
      filter(Indicator == "Number of Drug Overdose Deaths" &
        State.Name == input$state_var2 & Year == input$year_var) %>%
      select(State.Name, Year, Month, Data.Value)

    title <- paste0(
      "Drug Overdose Deaths vs. Month in ",
      input$state_var2, " of ", input$year_var
    )

    plot_deaths_month <- ggplot(drug_deaths_overdose) +
      geom_col(mapping = aes(x = Month, y = Data.Value)) +
      labs(y = "Number of Drug Overdose Deaths", title = title) +
      scale_x_discrete(limits = month.name)

    return(ggplotly(plot_deaths_month))
  })

  output$age_drug_trend <- renderTable({
    drug <- input$age_trend_rb
    val <- max(drug_age_data[[drug]])
    age_drug_trend <- drug_age_data %>%
      filter_(paste0(drug, "==", val)) %>%
      select(Age, drug)
    age_drug_trend
  })

  output$overdose_month_summary <- renderTable({
    month_2015_summary <- drug_od %>%
      group_by(State) %>%
      filter(Month == "January" | Month == "February" | Month == "March") %>%
      filter(Year == "2015") %>%
      filter(Indicator == "Number of Drug Overdose Deaths") %>%
      summarise(
        "Drug Overdose Deaths From January to March in 2015" =
          sum(as.integer(Data.Value), na.rm = T)
      )
    month_2018_summary <- drug_od %>%
      group_by(State) %>%
      filter(Month == "January" | Month == "February" | Month == "March") %>%
      filter(Year == "2018") %>%
      filter(Indicator == "Number of Drug Overdose Deaths") %>%
      summarise(
        "Drug Overdose Deaths From January to March in 2018" =
          sum(as.integer(Data.Value), na.rm = T)
      )
    month_summary <- left_join(month_2015_summary, month_2018_summary,
      by = "State"
    )
    month_summary[month_summary == 0] <- NA
    month_summary <- month_summary[complete.cases(month_summary), ]
    month_summary <- month_summary %>%
      head(10)
    month_summary
  })

  output$overdose_pop_graph <- renderPlotly({
    overdose_trend <- drug_induced_deaths %>%
      group_by(Year) %>%
      select(Year, Deaths, Population) %>%
      summarise("Deaths" = sum(Deaths), "Population" = sum(Population))

    od_trend_graph <- ggplot(overdose_trend) +
      geom_point(mapping = aes(x = Year, y = Deaths, color = Population)) +
      geom_line(aes(x = Year, y = Deaths), show.legend = TRUE) +
      ggtitle("Trend of Overdose Deaths and Population from 1999-2015")

    return(ggplotly(od_trend_graph))
  })

  output$legal_table_1 <- renderTable({
    state_1 <- c(
      "Alabama", "Alaska", "Arizona", "Arkansas", "California",
      "Colorado", "Connecticut", "Delaware",
      "District of Columbia", "Florida", "Georgia", "Hawaii",
      "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky",
      "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan",
      "Minnesota", "Mississippi", "Missouri"
    )
    legal_status_1 <- c(
      "Fully Illegal", "Fully Legal", "Mixed", "Mixed",
      "Fully Legal", "Fully Legal", "Mixed", "Mixed",
      "Fully Legal", "Mixed", "Mixed", "Mixed",
      "Fully Illegal", "Mixed", "Mixed", "Mixed",
      "Fully Illegal", "Fully Illegal", "Mixed",
      "Fully Legal", "Mixed", "Fully Legal", "Fully Legal",
      "Mixed", "Fully Illegal", "Mixed"
    )
    df_1 <- data.frame("State" = state_1, "Status" = legal_status_1)
    df_1
  })

  output$legality_map <- renderPlotly({
    drug_induced_deaths_select_map <- drug_induced_deaths %>%
      mutate(Abbreviation = state.abb[match(State, state.name)]) %>%
      group_by(State) %>%
      select(State, Year, Deaths, Population, Crude.Rate, Abbreviation) %>%
      mutate(Legality = case_when(
        State %in% c(
          "Alabama", "Idaho", "Kansas", "Kentucky", "Mississippi",
          "Nebraska", "North Carolina", "South Carolina",
          "South Dakota", "Tennessee",
          "Wisconsin", "Wyoming"
        ) ~ "Fully Illegal",

        State %in% c(
          "Arizona", "Arkansas", "Connecticut", "Delaware",
          "Florida", "Georgia", "Hawaii", "Illinois", "Indiana",
          "Iowa", "Louisiana", "Maryland", "Minnesota", "Missouri",
          "Montana", "New Hampshire", "New Jersey", "New Mexico",
          "New York", "North Dakota", "Ohio", "Oklahoma",
          "Pennsylvania", "Rhode Island", "Texas", "Utah",
          "Virginia", "West Virginia"
        ) ~ "Mixed",

        State %in% c(
          "Alaska", "California", "Colorado", "District of Columbia",
          "Maine", "Massachusetts", "Michigan", "Nevada", "Oregon",
          "Vermont", "Washington"
        ) ~ "Fully Legal"
      ))

    drug_induced_deaths_select_map$hover <- with(
      drug_induced_deaths_select_map,
      paste(
        State, "<br>",
        "Legality:", Legality
      )
    )

    g <- list(
      scope = "usa",
      projection = list(type = "albers usa"),
      showlakes = TRUE,
      lakecolor = toRGB("white")
    )

    p <- plot_geo(drug_induced_deaths_select_map,
      locationmode =
        "USA-states"
    ) %>%
      add_trace(
        text = ~hover, locations = ~Abbreviation,
        color = ~Legality, colors = "Dark2"
      ) %>%
      layout(
        title = "Legality Of Marijuana In Each State",
        geo = g
      )
    return(p)
  })
}
