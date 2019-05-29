library(shiny)

# Create a page for the Overview tab.
overview_content <- fluidPage(
  includeCSS("styles.css"),
  tags$h1("Overview"),
  tags$section(
    list(
      tags$p("This project is looking to see if there is a correlation between
             drug use and deaths. Some questions we are asking are if drug use
             increases as age increases or if the number of deaths have
             increased over the years for the younger generation. The data
             that we are using comes from",
             tags$a(href = "https://data.world/fivethirtyeight/drug-use-by-age",
                    "Data World"), ",",  
             tags$a(href = paste0("https://catalog.data.gov/dataset/accidental",
                                 "-drug-related-deaths-january-2012-sept-2015"),
                   "Data.gov"),", and the",
             tags$a(href = paste0("https://www.cdc.gov/nchs/nvss/vsrr/drug",
                                 "-overdose-data.htm"),"CDC"), ". One of the 
             datasets gives information about each age group and
             each column gives the frequency and use of a different drug. 
             We have another dataset that gives information about the number 
             of drug overdose deaths or gives the number of deaths from a 
             specifc drug in a specific state from 2015-2018."),
      # Citation: Toxicoman-Substance Abuse. 2018. Image. 
      # https://commons.wikimedia.org/wiki/File:Toxicoman_-_Substance_
      # abuse.jpg.
      tags$img(src = paste0("https://upload.wikimedia.org/wikipedia/commons/",
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

ui <- navbarPage(
  "Death Caused By Drug Use",
  overview_panel
)