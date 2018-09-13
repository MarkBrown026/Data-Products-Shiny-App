


library(shiny)
library(tidyverse)

bcl_url<- "http://pub.data.gov.bc.ca/datasets/176284/BC_Liquor_Store_Product_Price_List.csv"
bcl <- read.csv(url(bcl_url), na.strings = c("NA", "", "#DIV0!"))
head(bcl)


ui <- fluidPage(
    titlePanel("BC Liquor Store prices"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
            radioButtons("typeInput", "Product type",
                         choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                         selected = "WINE"),
            uiOutput("countryOutput")
        ),
        mainPanel(
            plotOutput("coolplot"),
            br(), br(),
            tableOutput("results")
        )
    )
)

server <- function(input, output) {
    output$countryOutput <- renderUI({
        selectInput("countryInput", "Country",
                    sort(unique(bcl$PRODUCT_COUNTRY_ORIGIN_NAME)),
                    selected = "CANADA")
    })  
    
    filtered <- reactive({
        if (is.null(input$countryInput)) {
            return(NULL)
        }    
        
        bcl %>%
            filter(CURRENT_DISPLAY_PRICE >= input$priceInput[1],
                   CURRENT_DISPLAY_PRICE <= input$priceInput[2],
                   PRODUCT_CLASS_NAME == input$typeInput,
                   PRODUCT_COUNTRY_ORIGIN_NAME == input$countryInput
            )
    })
    
    output$coolplot <- renderPlot({
        if (is.null(filtered())) {
            return()
        }
        ggplot(filtered(), aes(PRODUCT_ALCOHOL_PERCENT)) +
            geom_histogram()
    })
    
    output$results <- renderTable({
        filtered()
    })
}

shinyApp(ui = ui, server = server)