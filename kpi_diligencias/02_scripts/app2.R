# Load required packages
library(shiny)
library(bs4Dash) # For dashboard layout components (Bootstrap 4 theme)
library(ggplot2) # For sample plots (using ggplot2 for simplicity)
# library(plotly)    # (Optional) For interactive charts instead of ggplot2
# library(DT)       # (Optional) For interactive tables if needed

# UI: Define the dashboard layout and appearance
ui <- bs4DashPage(
  title = "Enterprise Demo",
  # Browser tab title
  header = bs4DashNavbar(
    title = "Enterprise Demo",
    skin = "dark",
    status = "primary",
    border = TRUE,
    sidebarIcon = "bars",
    controlbarIcon = NULL,
    rightUi = tags$li(class = "nav-item dropdown", tags$a(
      href = "#", icon("user"), class = "nav-link"
    ))
  ),
  sidebar = bs4DashSidebar(
    skin = "light",
    status = "primary",
    title = "Demo Menu",
    bs4SidebarMenu(
      bs4SidebarMenuItem(
        "Dashboard",
        tabName = "dashboard",
        icon = icon("tachometer-alt"),
        selected = TRUE
      )
      # You can add more menu items here with different tabName values
    )
  ),
  body = bs4DashBody(
    bs4TabItems(
      # Main Dashboard content
      bs4TabItem(
        tabName = "dashboard",
        # Row 1: KPI value boxes
        fluidRow(
          valueBox(
            "15,234",
            "Total Sales",
            icon = icon("dollar-sign"),
            color = "success",
            width = 3
          ),
          valueBox(
            "423",
            "New Orders",
            icon = icon("shopping-cart"),
            color = "info",
            width = 3
          ),
          valueBox(
            "32%",
            "Growth Rate",
            icon = icon("chart-line"),
            color = "primary",
            width = 3
          ),
          valueBox(
            "7.4",
            "Customer Rating",
            icon = icon("star"),
            color = "warning",
            width = 3
          )
        ),
        # Row 2: Two charts side by side
        fluidRow(
          box(
            title = "Sales by Group",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            collapsible = TRUE,
            selectInput("group_var", "Group by:", choices = c("Category", "Region")),
            plotOutput("plot_sales", height = "250px")
          ),
          box(
            title = "Revenue Over Time",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            collapsible = TRUE,
            plotOutput("plot_trend", height = "250px") # placeholder for a line chart
          )
        ),
        # Row 3: Full-width chart (e.g., regional performance)
        fluidRow(
          box(
            title = "Regional Performance",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            collapsible = TRUE,
            plotOutput("plot_regions", height = "300px") # placeholder for a full-width chart
          )
        )
      )
    )
  )
  # We omit bs4DashControlbar and bs4DashFooter for simplicity in this example
)

# Server: Define reactive expressions and output rendering
server <- function(input, output, session) {
  # Mock data for plots (in a real app, this could come from reactive data sources or database)

  # Bar chart data (e.g., sales by category)
  sales_data <- data.frame(
    Category = c("Product A", "Product B", "Product C"),
    Sales = c(120, 90, 65)
  )
  # Line chart data (e.g., revenue over time)
  set.seed(123) # for reproducibility
  days <- 30
  trend_data <- data.frame(
    Day = 1:days,
    Revenue = cumsum(rnorm(days, mean = 100, sd = 20)) # random cumulative revenue
  )
  # Horizontal bar chart data (e.g., regional performance)
  region_data <- data.frame(
    Region = c("North", "South", "East", "West"),
    Performance = c(85, 72, 90, 60)
  )

  # Render Plot 1: Sales by Category (bar chart)
  output$plot_sales <- renderPlot({
    ggplot(sales_data, aes(x = Category, y = Sales, fill = Category)) +
      geom_col(show.legend = FALSE) +
      labs(y = "Sales", x = NULL) +
      theme_minimal()
  })

  # Render Plot 2: Revenue Over Time (line chart)
  output$plot_trend <- renderPlot({
    ggplot(trend_data, aes(x = Day, y = Revenue)) +
      geom_line(color = "steelblue", size = 1) +
      geom_point(color = "steelblue") +
      labs(x = "Day", y = "Revenue") +
      theme_minimal()
  })

  # Render Plot 3: Regional Performance (horizontal bar chart)
  output$plot_regions <- renderPlot({
    ggplot(region_data, aes(x = Performance, y = reorder(Region, Performance))) +
      geom_col(fill = "orange") +
      labs(x = "Performance Score", y = NULL) +
      theme_minimal()
  })
}

# Run the Shiny app
shinyApp(ui, server)
