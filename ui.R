#5. Shiny App
library(shiny)
library(shinydashboard)
library(readr)
library(leaflet)
library(rgdal)
library(htmltools)
library(htmlwidgets)
library(tidyverse)
library(lubridate)
library(RColorBrewer)
library(tigris)
library(shiny)
library(viridis)
library(viridisLite)
library(sp)
library(raster)
library(rgeos)
library(sf)
library(stringr)
library(DT)
library(data.table)
library(geojsonsf)
library(jqr)
library(stringr)

#Einladen
GPG_Test=readOGR("C:/Users/LenaD/OneDrive/Desktop/Master 19/WS2/Geoinformationen kommunizieren/Datenbeschaffung/Geschlechterunterschiede/Bundesländer/GPG_Leaftime_Jahr2.shp", use_iconv=TRUE, encoding="UTF-8")

#Daten einlesen
hauptPfad <- "C:/Users/LenaD/OneDrive/Desktop/Master 19/WS2/Geoinformationen kommunizieren/"
GPG <- paste0(hauptPfad, "Datenbeschaffung/Geschlechterunterschiede/GenderPayGap.csv")

GenderPayGap <- read_delim(GPG, 
                           ";", escape_double = FALSE, col_types = cols(`2009` = col_number(), 
                                                                        `2010` = col_number(), `2011` = col_number(), 
                                                                        `2012` = col_number(), `2013` = col_number(), 
                                                                        `2014` = col_number(), `2015` = col_number(), 
                                                                        `2016` = col_number(), `2017` = col_number(), 
                                                                        `2018` = col_number()), na = "NA", 
                           trim_ws = TRUE)
#Datenmanipulation
test_year <- GenderPayGap %>%
    gather(Year, Value, -c(1, 12))
test_year[test_year == "Deutschland (bis 1990 früheres Gebiet der BRD)"] <- "Deutschland"

m <- leaflet()

#Farbpalette Karte
palettePink <- c("hotpink1", "indianred2", "deeppink4")
palGPG <- colorBin(palette = palettePink, domain = c(0, 30), na.color = "#808080")

#Benutzeroberfläche
ui <- fluidPage(    
    titlePanel("Wie entwickelt sich der Gender Pay Gap in Europa?"),
    sidebarLayout(      
        sidebarPanel(
            selectInput("Year", "Wähle ein Jahr:", 
                        choices = unique(GPG_Test$Year),
                        selected = 2018),
            hr(),
            selectInput(inputId = "Land",
                        label = "Wähle ein Land:",
                        choices = unique(test_year$Land),
                        selected = "Deutschland"),
            helpText("Datenquelle: ...")
        ),
        mainPanel(
            leafletOutput(outputId = "mymap"),
            plotOutput("plot")
        )
    )
)
