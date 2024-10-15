## Author: Edo Danilyan
## Webpage: https://edodanilyan.com
# R version 4.4.1 (2024-06-14)
# Platform: aarch64-apple-darwin20
# Running under: macOS 15.1
# https://github.com/danilyanedo7/shinyapp_species_distribution.git

library(shiny)
library(leaflet)
library(dplyr)
library(readr)
library(bslib)

# Generate dummy data
generate_dummy_data <- function() {
  species <- c("Javan Rhino",
               "Javan Hawk-Eagle",
               "Javan Leopard",
               "Javan Langur",
               "Javan Slow Loris")
  sites <- c(
    "Ujung Kulon National Park",
    "Mount Gede Pangrango",
    "Meru Betiri National Park",
    "Baluran National Park",
    "Gunung Halimun National Park"
  )
  
  dummy_data <- data.frame(
    Species = rep(species, each = 10),
    Site = rep(rep(sites, each = 2), 5),
    Observation = rep(1:2, 25),
    Abundance = sample(3:10, 50, replace = TRUE),
    stringsAsFactors = FALSE
  )
  
  set.seed(123)
  dummy_data$lat <- rep(c(-6.78, -6.78, -8.39, -7.85, -6.71),
                        each = 2,
                        times = 5) + runif(nrow(dummy_data), -0.01, 0.01)
  dummy_data$lon <- rep(c(105.38, 106.95, 113.73, 114.37, 106.46),
                        each = 2,
                        times = 5) + runif(nrow(dummy_data), -0.01, 0.01)
  
  dummy_data$Conservation_Status <- c(
    rep("Critically Endangered", 10),
    rep("Endangered", 10),
    rep("Vulnerable", 10),
    rep("Near Threatened", 10),
    rep("Endangered", 10)
  )
  
  dummy_data$Habitat_Type <- rep(
    c(
      "Tropical Rainforest",
      "Montane Forest",
      "Coastal Forest",
      "Savanna",
      "Cloud Forest"
    ),
    each = 2,
    times = 5
  )
  
  dummy_data$Endangered_Indicator <- ifelse(dummy_data$Conservation_Status == "Critically Endangered",
                                            1,
                                            0)
  return(dummy_data)
}

ui <- page_sidebar(
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  title = "Species Distribution Map",
  sidebar = sidebar(
    fileInput(
      "species_file",
      "Upload Species Data CSV",
      accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")
    ),
    checkboxInput("use_dummy_data", "Use Dummy Data", value = TRUE),
    numericInput(
      "center_lat",
      "Center Latitude",
      value = -7.0,
      min = -90,
      max = 90
    ),
    numericInput(
      "center_lon",
      "Center Longitude",
      value = 110.0,
      min = -180,
      max = 180
    ),
    actionButton("update_map", "Update Map", class = "btn-primary")
  ),
  leafletOutput("map"),
  # Footer with attribution
  tags$footer(
    p(
      "This Shiny app was created by Edo Danilyan at edodanilyan.com. Please provide attribution if you use or modify it."
    ),
    style = "text-align: center; padding: 8px; background-color: #f8f9fa; font-size: 0.6em;"
  )
)

server <- function(input, output, session) {
  # Reactive values for center coordinates
  center_coords <- reactiveVal(c(-7.833, 114.367))
  
  # Reactive value for species data
  species_data <- reactive({
    if (input$use_dummy_data) {
      generate_dummy_data()
    } else {
      req(input$species_file)
      tryCatch(
        read_csv(input$species_file$datapath),
        error = function(e) {
          showNotification("Error reading CSV file. Please check the file format.",
                           type = "error")
          NULL
        }
      )
    }
  })
  
  # Update center coordinates when button is clicked
  observeEvent(input$update_map, {
    center_coords(c(input$center_lat, input$center_lon))
  })
  
  # Create the map
  output$map <- renderLeaflet({
    req(species_data())
    data <- species_data()
    
    leaflet() %>%
      addProviderTiles("Esri.WorldStreetMap") %>%
      setView(lng = center_coords()[2],
              lat = center_coords()[1],
              zoom = 6) %>%
      addCircles(
        data = data,
        lat = ~ lat,
        lng = ~ lon,
        color = "#F60D1D",
        fillColor = "#F60D1D",
        fillOpacity = 0.25,
        popup = ~ paste0(
          "<strong>Species: </strong>",
          Species,
          "<br>",
          "<strong>Site: </strong>",
          Site,
          "<br>",
          "<strong>Abundance: </strong>",
          Abundance,
          "<br>",
          "<strong>Conservation Status: </strong>",
          Conservation_Status,
          "<br>",
          "<strong>Habitat Type: </strong>",
          Habitat_Type
        )
      )
  })
  
  # Update map view when center coordinates change
  observe({
    leafletProxy("map") %>%
      setView(lng = center_coords()[2],
              lat = center_coords()[1],
              zoom = 6)
  })
}

shinyApp(ui, server)
