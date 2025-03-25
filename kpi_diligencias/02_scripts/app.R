# Shiny KPIS diligencia MC

# Setup -----------------------------------------------------------------------------------------------------------

pacman::p_load(
  tidyverse,
  shiny,
  shinydashboard
  )

# App -------------------------------------------------------------------------------------------------------------

ui <- dashboardPage(
  dashboardHeader(title = "KPI Dirigencias Locales"),
  dashboardSidebar(),
  dashboardBody()
)

server <- function(input, output) { }

shinyApp(ui, server)