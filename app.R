# Prep -----------------
library(tidyverse)
# library(readr)
# library(dplyr)
library(leaflet)
library(shiny)

listings <- read_csv("listings.csv")

pal <- colorFactor(palette = topo.colors(3), domain = listings$room_type)

# UI -------------------
# Define UI for application that draws a histogram
ui <- fluidPage(
  title = "Airbnb Boston",
  titlePanel("Airbnb Boston"),
  tabsetPanel(
    tabPanel("Map", leafletOutput("map")),
    tabPanel("Data", dataTableOutput("table"))
  ),
  hr(),
  fluidRow(
    column(4,
           h3("Filter by Price"),
           column(6,
                  numericInput("minPrice", label = "Minimum Price:", value = 1)
           ),
           column(6,
                  numericInput("maxPrice", label = "Maximum Price:", value = 4000)
           )
    ),
    column(4,
           h3("Filter by Rating"),
           sliderInput("ratingFilter", label = "Rating:",
                       min = 1, max = 100, value = c(1,100))
    ),
    column(4,
           h3("Filter by Bedrooms"),
           checkboxGroupInput("bedroomFilter", label="Bedrooms:", 
                              choices = c("5" =5, "4"=4, "3"=3, "2"=1, "1"=1, "0"=0),
                              selected = c("5" =5, "4"=4, "3"=3, "2"=1, "1"=1, "0"=0))
    )
  ),
  hr(), #horizontal row
  p("Data from", a("Inside Airbnb", href= "http://www.insideairbnb.com", target = "_blank"))
)

# Server ------------------------
# Define server logic required to draw a histogram
server <- function(input, output) {
  
  df <- reactive({
    df <- listings %>%
      filter((price >= input$minPrice & price <= input$maxPrice) &
               (review_scores_rating >= input$ratingFilter[1] & review_scores_rating <= input$ratingFilter[2]) &
               (bedrooms %in% input$bedroomFilter)) #within the checkbox numeric values
    return(df)
  })
  
  # RenderLeaflet ----------------
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = df(), 
                       weight = 1, 
                       color = "black",
                       fillColor = ~pal(room_type),
                       fillOpacity = 1,
                       radius = 5,
                       popup = ~paste0("<img src='", thumbnail_url, "'></img>",
                                       "</br><a href='", listing_url,"' target='_blank'>", name, "</a>",
                                       "</br>Host: ", host_name,
                                       "</br>Bedrooms: ", bedrooms,
                                       "</br>Bathrooms: ", bathrooms,
                                       "</br>Price: ", price,
                                       "</br>Rating: ", review_scores_rating)
      ) %>%
      addLegend("bottomleft", 
                pal = pal, 
                values = df()$room_type, 
                opacity = 1)
  })
  
  # Data Table --------------------
  output$table <- renderDataTable({df()})
  
}

# Run the app -------------------------
# Run the application 
shinyApp(ui = ui, server = server)



# Run the application 
shinyApp(ui = ui, server = server)
