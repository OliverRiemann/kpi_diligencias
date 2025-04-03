# Shiny KPIS diligencia MC

# Setup -----------------------------------------------------------------------------------------------------------

pacman::p_load(
  tidyverse,
  shiny,
  shinydashboard
)

# App -------------------------------------------------------------------------------------------------------------

ui <- dashboardPage(
  dashboardHeader(
    title = "KPI Dirigencias Locales",
    dropdownMenuOutput("messageMenu")
    ),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "Resultados Electorales", 
        tabName = "dashboard", 
        icon = icon("dashboard")
        ),
      menuItem(
        " Estructura del patrido", 
        tabName = "widgets",
        icon = icon("th")
        ),
      menuItem(
        "Control de trabajo",
        tabName = "control",
        icon = icon("briefcase")
      ),
      menuItem(
        "Métricas de Interés",
        tabName = "metricas",
        icon = icon("chart-simple")
      )
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(
        tabName = "dashboard",
        fluidRow(
          box(
            plotOutput("plot1", height = 250)
            ),
          box(
            title = "Controls",
            sliderInput("slider", "Number of observations:", 1, 100, 50)
          )
        ),
        fluidRow(
          box(
            plotOutput("plot1", height = 250)
          ),
          box(
            title = "Controls",
            sliderInput("slider", "Number of observations:", 1, 100, 50)
          )
        )
      ),
      # Second tab content
      tabItem(
        tabName = "widgets",
        h2("Widgets tab content")
      )
    )
  )
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)

  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

shinyApp(ui, server)
