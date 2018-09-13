#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

bcl_url<- "http://pub.data.gov.bc.ca/datasets/176284/BC_Liquor_Store_Product_Price_List.csv"
bcl <- read.csv(url(bcl_url), na.strings = c("NA", "", "#DIV0!"))
print(str(bcl))

fluidPage(
    titlePanel("BC Liquor Store prices"),
    sidebarLayout(
        sidebarPanel( sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
                      radioButtons("typeInput", "Product type",
                                   choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                                   selected = "WINE"),
                      selectInput("countryInput", "Country",
                                  choices = c("CANADA", "FRANCE", "ITALY"))),
        mainPanel(
            plotOutput("coolplot"),
            br(), br(),
            tableOutput("results")
            )
    )
)