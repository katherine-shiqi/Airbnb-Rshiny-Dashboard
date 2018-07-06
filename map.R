library(tidyverse)
library(leaflet)

leaflet() %>%
  addTiles() #color global map

leaflet() %>%
  addProviderTiles("Stamen.Toner")  #black white global map

leaflet() %>%
  addProviderTiles("CartoDB.Positron") 

leaflet() %>%
  addProviderTiles("Esri.WorldShadedRelief") %>% 
  addProviderTiles("Stamen.TonerLabels") 

listings <- read_csv("http://dartgo.org/spring_parker_data")
listings$price <- as.numeric(gsub("[$,]", "", listings$price))
# 把listings$price的 $以及， 去掉(""), 然后变为numeric
leaflet() %>%
  addTiles() %>%
  addMarkers(data = listings)

pal <- colorFactor(palette = topo.colors(3), domain= listings$room_type) 

leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = listings, 
                   weight=1, 
                   color="black",
                   fillColor = ~pal(room_type),
                   fillOpacity = 1,
                   radius =5,
                   popup = ~paste0("<img src='", thumbnail_url, "'>",
                                   "</br><a href='", listing_url,"' target='_blank'>", name, "</a>",
                                   "</br>Host: ", host_name,
                                   "</br>Bedrooms: ", bedrooms,
                                   "</br>Bathrooms: ", bathrooms,
                                   "</br>Price: ", price,
                                   "</br>Rating: ", review_scores_rating)) %>%
                    #thumbnail_url是表中的一列
  addLegend("bottomleft", pal = pal, values = listings$room_type, opacity=1)

paste(1,2,3)
paste0(1,2,3)
