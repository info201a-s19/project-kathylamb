library(shiny)

# Using source to execute the other R files. This will define the ui value
# and server function.
source("app_ui.R")
source("app_server.R")

# Create a new shiny app is used to load the "ui" and "server" variables.
shinyApp(ui = ui, server = server)