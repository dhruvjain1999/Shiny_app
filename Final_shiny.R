library(shiny)
library(shinyWidgets)
library(tidyverse)
library(datasets)
library(dbplyr)
library(ggplot2)
library(dplyr)
library(tibble)
library(data.table)
library(ggmosaic)
library(ggforce)
library(ggmap)
library(ggthemes)
library(purrr)
library(keep)
library(readr)
library(maps)
library(mapproj)
library(tmap)
library(leaflet)
library(sf)
data('World')
library(DT)
library(geometries)




# 6 

ui <- fluidPage(
  setBackgroundColor(color = c("yellow")),
  h1("Dhruv Jain", align = "left", style = "color:blue"),
  h2("FINAL EXAM Shiny App Iris Data ", align = "left", style = "color:red"),
  selectInput("Dv", "Iris Variable", choices = names(iris)),
  mainPanel(plotOutput("plot"),plotOutput("plot2"),verbatimTextOutput("summary"))
)

server <- function(input, output){
  output$plot <- renderPlot({
    ggplot(data = iris, aes(x = .data[[input$Dv]] )) +
      geom_histogram(bins = 30,fill='blue', color="red")
  })
  output$plot2 <- renderPlot({
    ggplot(iris, aes( x=.data[[input$Dv]])) +
      geom_boxplot(fill='red', color="blue")
  })
  output$summary <- renderPrint({
    summary(iris)
  })
}
shinyApp(ui = ui, server = server)
