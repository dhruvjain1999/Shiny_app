library(tidyverse)
library(shiny)
library(datasets)
library(shinyWidgets)
library(DT)
xfun::session_info('DT')



# problem 1 

diamonds%>%
  select(carat,price,x,y,z) -> diamonds1
diamonds1
datatable(diamonds1)

ui <- fluidPage(
  titlePanel("Frequency plot"),
      selectInput("DVvar", "Diamond Variables",
                  choices=colnames(diamonds1)),
    mainPanel(
      plotOutput("plot")
    )
  )


server <- function(input, output){
  output$plot <- renderPlot({
    ggplot(diamonds, mapping = aes(x = .data[[input$DVvar]], color = cut )) +
      geom_freqpoly(binwidth = 0.1)+
      ggtitle("Frequency polygon")
  })  
}
shinyApp(ui = ui, server = server)





# problem 2 
cut = diamonds$cut 
carat =  diamonds$carat  

ui <- fluidPage(
  titlePanel("Frequency plot"),
  selectInput("Dv", "Diamond variable", choices = names(diamonds1)),
  plotOutput("plot"),
  plotOutput("plot2"),
  DT::dataTableOutput("mytable")

)

server <- function(input, output,session){
    output$plot <- renderPlot({
    ggplot(diamonds, mapping = aes(x = .data[[input$Dv]], color = cut )) +
      geom_freqpoly(binwidth = 0.1)+
      ggtitle("Frequency polygon")
  })
    output$plot2 <- renderPlot({
    ggplot(diamonds, aes(x=cut, y=.data[[input$Dv]])) +
      geom_boxplot(fill='purple', color="black")+
      ggtitle("Box plot")
  })
    output$mytable <- DT::renderDataTable(diamonds1)
    }
shinyApp(ui = ui, server = server)



# problem 3 

# Now produce your Problem 2 app using tabs as demonstrated in class and use 
#background color or color scheme of your choice (other than white).



ui <- fluidPage(
  setBackgroundColor(
    color = c("#F7FBFF", "#2171B5"),
    gradient = "linear",
    direction = c("top", "right")
  ),
  titlePanel("Frequency Plots, Box Plots, and a Table"),
  sidebarLayout(
    sidebarPanel(
      selectInput("DVvar", "Diamond Variables",
                  choices=colnames(diamonds1))
    ),
    mainPanel(
      tabsetPanel(type = "tab",
                  tabPanel("Plot1", plotOutput("freqplot")),
                  tabPanel("Plot2", plotOutput("boxplot")),
                  tabPanel("Table", dataTableOutput("mytable"))
      )
    )
  )
)

server <- function(input, output) {
  output$freqplot <- renderPlot({
    ggplot(diamonds, mapping = aes(x = .data[[input$DVvar]], color = cut)) +
      geom_freqpoly(binwidth = 0.1) +
      ggtitle("frequency polygons")
  })
  output$boxplot <- renderPlot({
    ggplot(diamonds, aes(y = .data[[input$DVvar]], x=cut)) +
      geom_boxplot(fill = "purple") +
      ggtitle("boxplot")
  })
  output$mytable <- renderDataTable(diamonds1)
}

shinyApp(ui = ui, server = server)







