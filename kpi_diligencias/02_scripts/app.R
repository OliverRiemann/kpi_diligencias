# Shiny KPIS diligencia MC

# Setup -----------------------------------------------------------------------------------------------------------

pacman::p_load(
  tidyverse,
  shiny,
  shinydashboard
)

# App -------------------------------------------------------------------------------------------------------------

ui <- dashboardPage(
  skin = "yellow",
  dashboardHeader(
    title = "KPI Dirigencias Locales",
    titleWidth = NULL
  ),
  dashboardSidebar(
    sidebarMenu(
      id = "sidebarid",
      menuItem(
        "Resultados Electorales",
        tabName = "dashboard",
        icon = icon("dashboard")
      ),
      menuItem(
        "Estructura del patrido",
        tabName = "partido",
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
      ),
      # Paneles condicionales a la selección en la sidebar
    conditionalPanel(
        'input.sidebarid == "dashboard"',
        selectizeInput(
          "tipo_eleccion", "Tipo de elección: ", 
          choices = c("Presidente", "Senadores", "Diputados Federales", "Gubernatura", "Ayuntamiento", "Diputados Locales")
          ),
        selectizeInput(
          "tipo_voto", "Tipo de voto: ", 
          choices = c("Por candidato", "Por partido", "Por marca")
          ),
        selectizeInput(
          "municipio", "Municipio: ",
          choices = c("Durango", "Zapopan", "Jalisco", "Monterrey")
        )
      ),
    conditionalPanel(
      'input.sidebarid == "partido"',
      selectizeInput(
        "estado", "Estado: ", 
        choices = c("Nuevo León", "Jalisco", "Ciudad de México")
      ),
      selectizeInput(
        "puesto", "Puesto: ", 
        choices = c("Gobernador", "Alcalde", "Diputado Local")
      ),
      selectizeInput(
        "comparacion", "Comparar con: ",
        choices = c("Año pasado", "Año antepasado")
      )
    ),
    conditionalPanel(
      'input.sidebarid == "control"',
      selectizeInput(
        "estado", "Estado: ", 
        choices = c("Nuevo León", "Jalisco", "Ciudad de México", "Municipio")
      ),
      # Solo aparece si dentro del sidebar control seleccionamos "Municipio"
      conditionalPanel(
      'input.estado == "Municipio"',
      selectizeInput(
        "municipio", "Municipio: ",
        choices = c("Monterrey", "Guadalajara")
      ),
      selectizeInput(
        "diligencia", "Diligencia: ",
        choices = c("1", "2", "3")
      ),
      )
    ),
    conditionalPanel(
      'input.sidebarid == "metricas"',
      selectizeInput(
        "estado", "Estado: ", 
        choices = c("Nuevo León", "Jalisco", "Ciudad de México")
      ),
      selectizeInput(
        "metrica", "Métrica: ", 
        choices = c("Personas sin acceso a los servicios de salud", "Métrica 2")
      )
    )
    )
    
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(
        tabName = "dashboard",
        fluidRow(
          valueBoxOutput("rate"),
          valueBoxOutput("count"),
          valueBoxOutput("users")
        ),
        fluidRow(
          box(
            plotOutput("plot1", height = 250),
            status = "warning"
          ),
          box(
            title = "Controls",
            sliderInput("slider", "Number of observations:", 1, 100, 50),
            footer = "footer 1",
            status = "warning",
            solidHeader = FALSE,
            background = NULL,
            width = 6,
            collapsible = TRUE
          )
        ),
        tabItem(
          "rawdata",
          numericInput("maxrows", "Rows to show", 25),
          verbatimTextOutput("rawtable"),
          downloadButton("downloadCsv", "Download as CSV")
        )
      ),
      # Second tab content
      tabItem(
        tabName = "partido",
        h2("Widgets tab content"),
        fluidRow(
          # A static infoBox
          infoBox("New Orders", 10 * 2, icon = icon("credit-card")),
          # Dynamic infoBoxes
          infoBoxOutput("progressBox"),
          infoBoxOutput("approvalBox")
        ),
        
        # infoBoxes with fill=TRUE
        fluidRow(
          infoBox("New Orders", 10 * 2, icon = icon("credit-card"), fill = TRUE),
          infoBoxOutput("progressBox2"),
          infoBoxOutput("approvalBox2")
        ),
        
        fluidRow(
          # Clicking this will increment the progress amount
          box(width = 4, actionButton("count", "Increment progress"))
        )
      )
    )
  )
)

server <- function(input, output) {
  
  # Record the time that the session started.
  startTime <- as.numeric(Sys.time())
  output$rate <- renderValueBox({
    # The downloadRate is the number of rows in pkgData since
    # either startTime or maxAgeSecs ago, whichever is later.
    elapsed <- startTime
    
    valueBox(
      value = formatC(elapsed, digits = 1, format = "f"),
      subtitle = "Downloads per sec (last 5 min)",
      icon = icon("area-chart"),
      color = "yellow"
    )
  })
  
  set.seed(122)
  histdata <- rnorm(500)

  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
  output$progressBox <- renderInfoBox({
    infoBox(
      "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
      color = "purple"
    )
  })
  output$approvalBox <- renderInfoBox({
    infoBox(
      "Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  # Same as above, but with fill=TRUE
  output$progressBox2 <- renderInfoBox({
    infoBox(
      "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
      color = "purple", fill = TRUE
    )
  })
  output$approvalBox2 <- renderInfoBox({
    infoBox(
      "Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow", fill = TRUE
    )
  })
}

shinyApp(ui, server)
