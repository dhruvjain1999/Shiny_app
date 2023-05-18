# Hola fellows!
# Give me credit for my code
# calling all the library in loop 
for(pkg in c("shiny","shinyWidgets","tidyverse","scatterplot3d",
             "datasets","dbplyr","ggplot2","dplyr","tibble","data.table",
             "ggmosaic","ggforce","ggmap",  "ggthemes",  "purrr",
             "keep","readr","maps","mapproj","tmap","leaflet","sf",
             "tidyr","DT","rnaturalearth","rnaturalearthdata","lwgeom",
             "geos","ggspatial","plotly","shinydashboard","htmlwidgets",
             "wordcloud2","ggplot2","MASS","htmlwidgets")){
  library(pkg, character.only = TRUE)
}


# credit goes to: Dhruv Jain
# important link:
# source link: 
# https://www.kaggle.com/datasets/ucsusa/active-satellites?datasetId=744

#------------------------------------------------------------------------------
# Data calling in R studio  
# -----------------------------------------------------------------------------

data=read_csv('Active_Satellites_in_Orbit_Around_Earth.csv')
head(data)
str(data)
nrow(data)

#------------------------------------------------------------------------------
# Data cleaning 
# -----------------------------------------------------------------------------

na_counts <- satellite %>% 
  summarise_all(~ sum(is.na(.)))%>%
  gather()
# View the results
head(na_counts,18)

# replacing NA values with unknown 
satellite$`Type of Orbit` <- ifelse(is.na(satellite$`Type of Orbit`), "unknown", satellite$`Type of Orbit`)

# Remove non-numeric characters from the value column
satellite$`Dry Mass (Kilograms)` <- as.numeric(gsub("[^0-9]", "", satellite$`Dry Mass (Kilograms)`))

# Replacing values by mean or median ?
hist(satellite$`Launch Mass (Kilograms)`)
# the graph is skewed to right so we will use median approach 
hist(satellite$`Dry Mass (Kilograms)`)
# the graph is skewed to right so we will use median approach 

# Calculate the median of the non-missing values
# the median value is 1178.  
median_mass <- median(satellite$`Launch Mass (Kilograms)`, na.rm = TRUE)
# Impute the missing values with the median
satellite$`Launch Mass (Kilograms)`[is.na(satellite$`Launch Mass (Kilograms)`)] <- median_mass
# another variable 
median_mass <- median(satellite$`Dry Mass (Kilograms)`, na.rm = TRUE)
# the median value is 980.  
# Impute the missing values with the median
satellite$`Dry Mass (Kilograms)`[is.na(satellite$`Dry Mass (Kilograms)`)] <- median_mass

# mean 

satellite$`Expected Lifetime (Years)` <- as.numeric(gsub("[^0-9]", "", satellite$`Expected Lifetime (Years)`))
mean_mass <- mean(satellite$`Expected Lifetime (Years)`, na.rm = TRUE)
satellite$`Expected Lifetime (Years)`[is.na(satellite$`Expected Lifetime (Years)`)] <- mean_mass

# omitting rest all values form data
satellite <- na.omit(satellite)

# Separate date string into day, month, and year columns
satellite <- separate(satellite, col = `Date of Launch`, into = c("month", "day", "year"), sep = "/")

# COUNT 
unique(satellite$`Country of Contractor`)
table(satellite$`Country of Contractor`)
satellite$year = as.numeric(satellite$year)
satellite$Users = as.factor(satellite$Users)


# -----------------------------------------------------------------------------
# Data cleaning completed 
#------------------------------------------------------------------------------

# Calculating Na values in data set after cleaning 
na_counts <- satellite %>% 
  summarise_all(~ sum(is.na(.)))%>%
  gather()
# View the results
head(na_counts,18)

# number of rows 
nrow(satellite)
# number of colums 
ncol(satellite)
# name of colums 
colnames(satellite)


view(satellite)
view(data)


# ---------------------------------------------------------------------
# 1 # sPECIFIYIBG MY data chart
#-----------------------------------------------------------------------

ab_1 <- satellite%>%
  dplyr::select(`Country of Contractor`, Users, year)%>%
  group_by(`Country of Contractor`, Users, year)%>%
  summarize(count = n())
ab_1

max_counts <- ab_1 %>%
  group_by(`Country of Contractor`) %>%
  summarize(max_count = max(count))%>%
  arrange(desc(max_count))
max_counts


# -------------------------------------------------------------------------
# Shiny App   
# -------------------------------------------------------------------------

  
  # Define UI
  ui <- fluidPage(
    h1("Dhruv Jain", align = "left", style = "color:blue"),
    h2("Shiny app", align = "left", style = "color:red"),
    selectInput("Dv", "Iris Variable", choices = names(satellite)),
    mainPanel(
      tabsetPanel(
        tabPanel("Plot 1", plotOutput("plot")),
        tabPanel("Plot 2", plotlyOutput("plot2")),
        tabPanel("Plot 3", plotlyOutput("plot3")),
        tabPanel("Plot 4", plotlyOutput("plot4")),
        tabPanel("Summary", verbatimTextOutput("summary"))
      )
    )
    
  )
  
  # Define server
  server <- function(input, output) {
    output$plot <- renderPlot({
      ggplot(max_counts, aes(x = "", y = max_count, fill = `Country of Contractor`)) +
        geom_bar(stat = "identity", width = 10, color = "black") +
        coord_polar("y") +
        theme_void() +
        theme() +
        labs(title = "60 countries have satellite")
    })
    
    output$plot2 <- renderPlotly({
      ab_1 <- satellite %>%
        dplyr::select(`Country of Contractor`, Users, year) %>%
        group_by(`Country of Contractor`, Users, year) %>%
        summarize(count = n())
      
      india_df <- ab_1 %>%
        filter(`Country of Contractor` == "India") %>%
        dplyr::select(Users, count)
      
      text_label <- paste(india_df$Users, ": ", india_df$count)
      
      plot_ly(india_df, labels = ~Users, values = ~count, type = 'pie', text = text_label) %>%
        layout(
          title = "Count of Users in India",
          annotations = list(text = "Hover over pie slices for details", showarrow = FALSE, x = 0.5, y = 1.1),
          hoverlabel = list(bgcolor = "white", font = list(family = "Arial", size = 14)),
          legend = list(
            x = 0.8, y = 0.5,
            bgcolor = "white",
            font = list(family = "Arial", size = 14),
            bordercolor = "black",
            borderwidth = 1
          )
        )
    })
    
    output$plot3 <- renderPlotly({
      ggplot(data = satellite, aes(x = year, y = Users, color = `Country of Contractor`)) +
        geom_col() +
        theme_bw() +
        theme_minimal() +
        theme(legend.position = "none") -> p
      
      # Convert ggplot object to interactive plot using ggplotly
      ggplotly(p) 
      # layout(title = "Count of Users by Country and Year",
      #        xaxis = list(title = "Country of Contractor"),
      #        yaxis = list(title = "Year"),
      #        legend = list(title = "Users", font = list(size = 12))) 
      
    })
    
    output$plot4 <- renderPlotly({
      # Pick 10 random data points from the 'Perigee (Kilometers)' column
      random_indices <- sample(1:nrow(satellite), 250)
      # Subset the original dataset with the random indices
      random_data <- satellite[random_indices, ]
      
      # Create the plot with the random data
      ggplot(data = random_data, aes(x = `Perigee (Kilometers)`,
                                     y = `Apogee (Kilometers)`,
                                     z = `Expected Lifetime (Years)`,
                                     fill = `Official Name of Satellite`,
                                     color = `Country of Contractor`)) +
        geom_point() +
        theme_bw() +
        theme_minimal() +
        theme(legend.position = "left") -> p
      
      # Display the plot
      ggplotly(p)
    })
    
    output$summary <- renderPrint({
      head(satellite, 10)
      summary(satellite)
    })
  }
  
  # Run the app
  shinyApp(ui = ui, server = server)
  
