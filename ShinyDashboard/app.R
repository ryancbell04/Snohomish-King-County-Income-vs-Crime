library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

# Load dataset
data <- read.csv("merged_crime_income_data.csv")

# UI
iu <- fluidPage(
  titlePanel("Crime & Income Analysis in Northern Seattle Counties"),
  sidebarLayout(
    sidebarPanel(
      selectInput("county", "Select County:", choices = unique(data$County)),
      sliderInput("yearRange", "Select Year Range:",
                  min = min(data$Year), max = max(data$Year),
                  value = c(min(data$Year), max(data$Year)), sep = "")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Time-Series", plotOutput("crime_trend"), plotOutput("income_trend")),
        tabPanel("Correlation", plotOutput("scatter_plot")),
        tabPanel("Data Table", DTOutput("data_table"))
      )
    )
  )
)

# Server
server <- function(input, output) {
  filtered_data <- reactive({
    data %>%
      filter(County == input$county, Year >= input$yearRange[1], Year <= input$yearRange[2])
  })
  
  output$crime_trend <- renderPlot({
    ggplot(filtered_data(), aes(x = Year, y = Crime_Rate)) +
      geom_line(color = "red") +
      geom_point() +
      labs(title = "Crime Rate Over Time", x = "Year", y = "Crime Rate")
  })
  
  output$income_trend <- renderPlot({
    ggplot(filtered_data(), aes(x = Year, y = Median_Income)) +
      geom_line(color = "blue") +
      geom_point() +
      labs(title = "Median Income Over Time", x = "Year", y = "Median Income")
  })
  
  output$scatter_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = Median_Income, y = Crime_Rate)) +
      geom_point() +
      geom_smooth(method = "lm", color = "darkgreen") +
      labs(title = "Income vs. Crime Rate", x = "Median Income", y = "Crime Rate")
  })
  
  output$data_table <- renderDT({
    datatable(filtered_data())
  })
}

# Run the app
shinyApp(ui = iu, server = server)
