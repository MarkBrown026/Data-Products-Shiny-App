#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


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

