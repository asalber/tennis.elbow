library(shiny)
library(shinyjs)
library(shinythemes)
library(DT)

ui <- fluidPage(theme = shinytheme("cerulean"),
    useShinyjs(), 
    # Application title
    tags$h1("Tennis elbow data generation"),
    tags$p("Enter the last 8 digits of your identity card number without letters (fill with zeros to the left if you have less than 8 digits)"),
    numericInput(inputId = "id", label = "Id card number", value='00000000', min = 0, max = 99999999, width = 120),
    actionButton(inputId = "generateData", "Generate data", icon("paper-plane")),
    br(), br(),
    dataTableOutput(outputId = "table"),
    hidden(downloadButton("downloadData", "Download", class = "btn-primary"))
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    newdata <- eventReactive(input$generateData, {
        load("data/tennis.elbow.RData")
        set.seed(paste0(input$id, '1'))
        tennis.elbow$Age <- tennis.elbow$Age + round(rnorm(length(tennis.elbow$Pain.Relief.Max), 0, 1))
        tennis.elbow$Pain.Relief.Max <- tennis.elbow$Pain.Relief.Max + round(rnorm(length(tennis.elbow$Pain.Relief.Max), 0, 0.25))
        tennis.elbow$Pain.Relief.12h <- tennis.elbow$Pain.Relief.12h + round(rnorm(length(tennis.elbow$Pain.Relief.12h), 0, 0.25))
        tennis.elbow$Pain.Relief.24h <- tennis.elbow$Pain.Relief.24h + round(rnorm(length(tennis.elbow$Pain.Relief.24h), 0, 0.25))
        tennis.elbow$Pain.Relief.Global <- tennis.elbow$Pain.Relief.Global + round(rnorm(length(tennis.elbow$Pain.Relief.Global), 0, 0.25))
        bound <- function(x, lowlim, upplim){
            if (x < lowlim) x <- lowlim
            if (x > upplim) x <- upplim
            return(x)
        }
        fun <- function(x) bound(x, 1, 6)
        tennis.elbow$Pain.Relief.Max <- sapply(tennis.elbow$Pain.Relief.Max, fun)
        tennis.elbow$Pain.Relief.12h <- sapply(tennis.elbow$Pain.Relief.12h, fun)
        tennis.elbow$Pain.Relief.24h <- sapply(tennis.elbow$Pain.Relief.24h, fun)
        tennis.elbow$Pain.Relief.Global <- sapply(tennis.elbow$Pain.Relief.Global, fun)
        tennis.elbow
    })
    # Render data table
    output$table <- renderDataTable(newdata())
    # Downdoad data
    output$downloadData <- downloadHandler(
        filename = "tennis.elbow.csv",
        content = function(file) {
            write.csv(newdata(), file, row.names = F)
        }
    )
    # Show download button
    observeEvent(input$generateData, {
        show("downloadData")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
