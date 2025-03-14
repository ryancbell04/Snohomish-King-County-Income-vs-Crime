library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

# Load dataset
# ADD MORE DATA SETS SHINY IS MISSING CRIME DATA
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
        tabPanel("Data Table", DTOutput("data_table")),
        tabPanel("About", 
                 h2("About Crime & Income Analysis in Northern Seattle Counties"),
                 p("This Shiny application provides an interactive analysis of the relationship between crime rates and median income levels across Northern Seattle counties. The app allows users to explore historical trends, examine correlations, and view filtered datasets based on user-selected parameters."),
                 h3("Features"),
                 tags$ul(
                   tags$li("Time-Series Analysis: Visualizes trends in crime rates and median income over selected years."),
                   tags$li("Correlation Analysis: Displays scatter plots to examine potential relationships between income levels and crime rates."),
                   tags$li("Interactive Data Table: Enables users to explore and filter raw data dynamically.")
                 ),
                 h3("Data Sources"),
                 p("The application utilizes a dataset titled merged_crime_income_data.csv, which integrates crime statistics and median income data across various counties."),
                 h3("User Guide"),
                 tags$ol(
                   tags$li("Select a County: Use the dropdown menu to choose a county for analysis."),
                   tags$li("Adjust Year Range: Use the slider to specify a range of years to focus on."),
                   tags$li("Navigate Tabs: View time-series graphs, correlation plots, and data tables.")
                 ),
                 h3("Future Enhancements"),
                 tags$ul(
                   tags$li("Incorporation of additional datasets to provide more comprehensive crime statistics."),
                   tags$li("Enhanced filtering options, including crime type and demographic factors."),
                   tags$li("More advanced statistical models to analyze relationships between crime and socioeconomic factors.")
                 ),
                 h3("Technical Details"),
                 tags$ul(
                   tags$li("Built with R Shiny for interactive visualization."),
                   tags$li("Uses ggplot2 for data visualization."),
                   tags$li("Employs dplyr for efficient data manipulation."),
                   tags$li("Integrates DT for rendering interactive tables.")
                 ),
                 h3("Contact"),
                 p("For any suggestions or inquiries, please reach out to the development team."),
                 p("Connect with me on: ",
                   tags$a(href = "https://www.linkedin.com/in/ryan-bell-9715422b6/", "LinkedIn"), " | ",
                   tags$a(href = "https://github.com/ryancbell04/Snohomish-King-County-Income-vs-Crime", "GitHub")
                 )
        )
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

