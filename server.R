#Serveroutput
server <- function(input, output){ #, session) {
    data_input <- reactive({
        GPG_Test[GPG_Test$Year == input$Year,]
    })
    labels <- reactive({
        paste("Land:", " ", data_input()$NAME_LATN, "<p>",
              "Gender Pay Gap:", " ", data_input()$Value, " ", "%",
              sep = "")
    })
    output$mymap <- renderLeaflet({
        leaflet() %>%
            setView(m, lat = 54, lng = 12, zoom = 3) %>% 
            addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
            addProviderTiles(providers$Esri.WorldImagery, group = "ESRI") %>%
            addTiles(group = "OpenStreetMap") %>% 
            addScaleBar(position ="topleft",
                        options = scaleBarOptions(imperial = FALSE)) %>% #Ma?stab
            addMiniMap(
                tiles = providers$Esri.WorldStreetMap,
                toggleDisplay = TRUE) %>% #kleine Karte wo auf der Welt das Gebiet ist
            addPolygons(data = data_input(),
                        fillColor = palGPG(data_input()$Value),
                        weight = 2,
                        opacity = 1,
                        color = "white",
                        dashArray = "3",
                        fillOpacity = 0.7,
                        label = lapply(labels(), HTML),
                        labelOptions = labelOptions(
                            style = list("font-weight" = "normal", padding = "3px 8px"),
                            textsize = "15px",
                            direction = "auto"),
                        highlight = highlightOptions(
                            weight = 5,
                            color = "#8B0A50",
                            dashArray = "",
                            fillOpacity = 0.7,
                            bringToFront = TRUE)) %>%
            addLegend(pal = palGPG,
                      values = data_input()$Value,
                      opacity = 0.7,
                      position = "topright", title = "Gender Pay Gap [%]") %>% #Legende
            addLayersControl(
                baseGroups = c("OpenStreetMap", "Toner", "Satelliten Bild"), position = "topleft")
        
    })
    
    data <- reactive({
        test_year[test_year$Land == input$Land,]
    })
    data_ordered <- reactive({
        data()[order(match(data()$Value, test_year$Value)),]
    })
    output$plot <- renderPlot({
        g <- ggplot(data_ordered(), aes( y = Value, x = Year, group = Land))
        g <- g + geom_point(col = "hotpink4", size=5, shape=16)
        g <- g + labs(y="Gender Pay Gap [%]", x = "Jahr")
        g <- g + theme_minimal(base_size = 30)
        g + geom_line(linetype = "dashed")
        
    })
}
