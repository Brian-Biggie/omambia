library(shiny)
library(RPostgreSQL)
library(leaflet)
library(plumber)
library(RPostgres)
library(sf)
library(geojsonsf)
library(DBI)
library(geojsonio)
library(geojsonlint)

 
db_host <- 'localhost'
db_name <- 'postgres'
db_user <- 'postgres'
db_password <- '199725'
table_name <- 'ukadm3'
# Define UI
ui <- fluidPage(
  titlePanel("Web Map Application"),
  leafletOutput("map")
)
server <- function(input, output) {
  
  # Establish the database connection
  
con <- dbConnect(Postgres(),
                 dbname = "postgres",
                 host = "localhost",
                 port = 5432,
                 user = "postgres",
                 password = "199725")

# SQL query
query <- paste("SELECT id_2, latitude, longitude",
               "FROM public.", table_name, ";")

# Execute the query and retrieve the data
data <- dbGetQuery(con, query)

# Close the database connection
dbDisconnect(con)

# Create leaflet map
output$map <- renderLeaflet({
  leaflet() %>%
    addTiles() %>%
    addMarkers(data = data, lng = ~longitude, lat = ~latitude, popup = ~id_2)
})
}

# Run the Shiny app
shinyApp(ui, server)

