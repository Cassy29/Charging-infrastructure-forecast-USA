library(ggmap)
library(ggplot2)



chargers <- read.csv("CAL_Charger_stations.csv", header = TRUE, stringsAsFactors = FALSE)
nycharger <- read.csv("NY_charger_stations.csv", header = TRUE, stringsAsFactors = FALSE) 
CS_US <- read.csv("US_Base file stations_all.csv", header = TRUE, stringsAsFactors = FALSE)
library(sp)
#change the CALIFORNIA charger data into a SpatialPointsDataFrame
qmap('California')

qmap('California', zoom=5)
coords <- cbind(Longitude = as.numeric(as.character(chargers$Longitude)), Latitude = as.numeric(as.character(chargers$Latitude)))
charger.pts <- SpatialPointsDataFrame(coords, chargers[, -(5:6)], proj4string = CRS("+init=epsg:4326"))

#plot charger station points only
plot(charger.pts, pch = ".", col = "darkred")

#plot map
map <- qmap('California', zoom=6)
#plot the charger points with map
map + geom_point(data = chargers, aes(x = Longitude, y = Latitude), color="red", size=0.5, alpha=0.5)

#in depth look Los Angeles metropolitan area
map <- qmap('Los Angeles', zoom=9)
#plot the charger points with map
map + geom_point(data = chargers, aes(x = Longitude, y = Latitude), color="red", size=0.5, alpha=0.5)


#NEW YORK CHARGERS
#change the NY charger data into a SpatialPointsDataFrame
coords <- cbind(Longitude = as.numeric(as.character(nycharger$Longitude)), Latitude = as.numeric(as.character(nycharger$Latitude)))
nycharger.pts <- SpatialPointsDataFrame(coords, nycharger[, -(5:6)], proj4string = CRS("+init=epsg:4326"))

#New York charger stations
map <- qmap('New York', zoom=6)
#plot the charger points with map
map + geom_point(data = nycharger, aes(x = Longitude, y = Latitude), color="red", size=0.5, alpha=0.5)

#US_map
coords <- cbind(Longitude = as.numeric(as.character(CS_US$Longitude)), Latitude = as.numeric(as.character(CS_US$Latitude)))
nycharger.pts <- SpatialPointsDataFrame(coords, CS_US[, -(5:6)], proj4string = CRS("+init=epsg:4326"))

map <- qmap('USA', zoom=3)
#plot the charger points with map
map + geom_point(data = CS_US, aes(x = Longitude, y = Latitude), color="red", size=0.2, alpha=0.5)


#plot the roads Google Maps basemap
map <- qmap('USA', zoom = 4, maptype = 'roadmap')
#plot the density map
map + stat_density2d(
  aes(x = Longitude, y = Latitude, fill = ..level.., alpha = ..level..*2), 
  size = 2, bins = 5, data = CS_US, geom = "polygon") +
  scale_fill_gradient(low = "black", high = "red")



#temperature California
temp1 <- read.csv("cal_map.csv", header = TRUE, stringsAsFactors = FALSE)
select(temp1, dx90)
data <- fortify(temp1)
map <- qmap('California', zoom = 4, maptype = 'roadmap')


# subset climate
climate<- subset(temp1,
                           +   dx32 != "dx32" & dx90 != "dx90")

Cal_map <- qmap("California", zoom = 6, legend = "topleft")
Cal_map +
  geom_point(aes(x = Longitude, y = Latitude, colour = dx32, size = dx32),
             data = climate)
#CAL dx32 map
Cal_map <- qmap("California", zoom = 6, legend = "topright")
Cal_map +
  geom_point(aes(x = Longitude, y = Latitude, size = dx32), alpha = 0.5, color = "dodgerblue", data = climate) + 
  scale_fill_gradient(low = "dodgerblue", high = "dodgerblue3") +
  ggtitle("California - days with 32˚ Fahrenheit")

#CAL dx90 map
Cal_map <- qmap("California", zoom = 6, legend = "topright")
Cal_map +
  geom_point(aes(x = Longitude, y = Latitude, size = dx90), alpha = 0.5, color = "brown3", data = climate) + 
  scale_fill_gradient(low = "bisque2", high = "brown1") +
  ggtitle("California - days with 90˚ Fahrenheit")

#temperature New York
temp_ny <- read.csv("NY_map.csv", header = TRUE, stringsAsFactors = FALSE)
select(temp_ny, dx90)
data <- fortify(temp_ny)
map <- qmap('California', zoom = 4, maptype = 'roadmap')


# subset climate
climate_ny<- subset(temp_ny,
                 +   dx32 != "dx32" & dx90 != "dx90")

NY_map <- qmap("New York", zoom = 6, legend = "topright")
NY_map +
  geom_point(aes(x = Longitude, y = Latitude, colour = dx32, size = dx32),
             data = climate_ny)
#NY dx32 map
NY_map <- qmap("New York", zoom = 6, legend = "topright")
NY_map
NY_map +
  geom_point(aes(x = Longitude, y = Latitude, size = dx32), alpha = 0.5, color = "dodgerblue", data = climate_ny) + 
  scale_fill_gradient(low = "dodgerblue", high = "dodgerblue3") +
  ggtitle("New York - days with 32˚ Fahrenheit")


#Ny dx90 map
NY_map <- qmap("New York", zoom = 6, legend = "topright")
NY_map +
  geom_point(aes(x = Longitude, y = Latitude, size = dx90), alpha = 0.5, color = "brown3", data = climate_ny) + 
  scale_fill_gradient(low = "bisque2", high = "brown1") +
  ggtitle("New York - days with 90˚ Fahrenheit")



CAL_county <- qmap("los angeles county")
CAL_county

library(usmap)
library(ggplot2)

#US population
USMAP <-plot_usmap(
  data = countypop, values = "pop_2015", include = c("CA"), lines = "red"
) + 
  scale_fill_continuous(
    low = "white", high = "darkred", name = "Population (2018)", label = scales::comma
  ) + 
  labs(title = "California Population by county") +
  theme(legend.position = "right")
----------------------------------------------------------
  
#choropleth maps 
#source package: https://github.com/wmurphyrd/fiftystater

#plot the density map
map + stat_density2d(
  aes(x = Longitude, y = Latitude, fill = ..level.., alpha = ..level..*2), 
  size = 2, bins = 5, data = data, geom = "polygon") +
  scale_fill_gradient(low = "black", high = "red")

# install.packages("devtools")
devtools::install_github("wmurphyrd/fiftystater")
devtools::install_github("wmurphyrd/colorplaner")

library(ggplot2)
library(fiftystater)
library(colorplaner)
library(viridis)
library(varhandle)
library(rgdal)
library(RColorBrewer)
library(leaflet)


#MY MAP
#load data

chargers <- read.csv("charger_state.csv", header = TRUE, stringsAsFactors = FALSE)

#trial df 1
df <- data.frame(chargers)
chargers$statelower <- tolower(chargers$State) 


dput(df)                       


#set color codes
low_color='#ccdbe5' 
high_color="#114365"
#trial 3 - colors, breaks, bins
low_color='#FFCC99' 
high_color="#330000"
mybreaks <- c(0, 100, 500, 1000, 2000, 3000, 4000, 5000, Inf)
bins <- c(0, 500, 1000, 2000, 3000, 4000, 5000, Inf)
pal <- colorBin("YlOrRd", domain = chargers$Stations, bins = bins)

#map for charging stations
p3 <- ggplot(df, aes(map_id = chargers$statelower)) +
  geom_map(aes(fill = chargers$Stations ),color="#ffffff",size=0.15, map = fifty_states) + 
  expand_limits(x = fifty_states$long, y = fifty_states$lat) +
  coord_map() +
  labs(x = "", y = "") +
  scale_x_continuous(breaks = NULL) + 
  scale_y_continuous(breaks = NULL) +
  scale_fill_continuous(low = low_color, high= high_color, guide = guide_colorbar(title = "Charger values"), breaks = c(100, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000)) + # creates shading pattern
  theme(#legend.position = "bottom", 
    panel.background = element_blank()) + 
  fifty_states_inset_boxes() +
  ggtitle('EV Charger Stations per State', subtitle = 'California has the most charger stations')

p3

p3 + scale_fill_distiller(palette = "Paired", breaks = pretty_breaks(n = 10))


-----------------
  
#Density plots

library(spatstat)
library(sp)
library(rgdal)
library(maptools)
library(ggmap)
library(RColorBrewer)
#get api key
library(googleway)
AIzaSyD0cFBANK_SEy94v35QY7k9RxjuScP9N4I
set_key( "AIzaSyCW7aHvfeUH8C73T-9U4eKwqh4MEadw7sQ", api = "default")
google_keys()

register_google(key = "AIzaSyCW7aHvfeUH8C73T-9U4eKwqh4MEadw7sQ")
has_google_key()

# Loading all the data
datas=read.csv("public_fuel_stations (Jun 15 2019).csv",stringsAsFactors = FALSE)

# Summary
summary(datas)

# Check if Latitude and Longitude data are NAs or not
table(is.na(datas$Latitude))# No NAs


# subset data for CHADEMO
data_Chademo = datas[datas$EV.Connector.Types=="CHADEMO",]
# Number of records for data_Chademo
nrow(data_Chademo)

# subset data for J1772
data_J1772 = datas[datas$EV.Connector.Types=="J1772",]
# Number of records for data_Chademo
nrow(data_J1772)

# subset for TESLA
data_TESLA = datas[datas$EV.Connector.Types=="TESLA",]
# Number of records for TESLA
nrow(data_TESLA)

# subset for J1772COMBO
data_J1772COMBO = datas[datas$EV.Connector.Types=="J1772COMBO",]
# Number of records for TESLA
nrow(data_J1772COMBO)



library("ggmap")

bbox <- c(left = -170, bottom = 18, right = -65, top = 65)

us <- get_stamenmap(bbox = bbox, zoom = 4,maptype = 'terrain-background')
ggmap(us)

##test map
bbox <- c(left = -170, bottom = 18, right = -65, top = 65)

us <- get_stamenmap(bbox = bbox, zoom = 4,maptype = 'terrain')
ggmap(us)

outlets=read.csv("Public charging stations_outlets_state.csv", header = TRUE, stringsAsFactors = FALSE)


## Total Number of Charging Stations
graph1<- ggmap(us, extent = "panel") + 
  geom_point(data = datas, aes(x = datas$Longitude, y = datas$Latitude), 
             alpha = 0.05, color = "red") +
  ggtitle("Total Number of Charging Stations")
graph1
ggsave("graph_allstations.png",width = 5, height = 5)

## Density Map of all the Charging Stations
graph3<- ggmap(us, extent = "panel")  +
  stat_density_2d(data = datas,
                  aes(x = Longitude,y = Latitude,fill = stat(level)),
                  alpha = .1,bins = 50,
                  geom = "polygon") +
  scale_fill_gradientn(colors = brewer.pal(7, "YlOrRd"))+
  ggtitle("Density Plot of all the charging Stations")
graph3
ggsave("graph3.png",width = 4, height = 4)



## Density Map of all the Charging Stations
graph4<- ggmap(us, extent = "panel")  +
  stat_density_2d(data = datas,
                  aes(x = Longitude,y = Latitude,fill = stat(level)),
                  alpha = .1,bins = 50,
                  geom = "polygon") +
  scale_fill_gradientn(colors = brewer.pal(7, "YlOrRd"))+
  ggtitle("Density Plot of all Charging Stations")
graph4
ggsave("CS_all.png",width = 4, height = 4)


## Density Map of all the Charging Stations - Chademo
graph5<- ggmap(us, extent = "panel")  +
  stat_density_2d(data = data_Chademo,
                  aes(x = Longitude,y = Latitude,fill = stat(level)),
                  alpha = .1,bins = 50,
                  geom = "polygon") +
  scale_fill_gradientn(colors = brewer.pal(7, "YlOrRd"))+
  ggtitle("Density Plot of Chademo Charging Stations")
graph5
ggsave("graph5.png",width = 4, height = 4)


## Density Map of J1772COMBO type Charging Stations 
graph6<- ggmap(us, extent = "panel")  +
  stat_density_2d(data = data_J1772COMBO,
                  aes(x = Longitude,y = Latitude,fill = stat(level)),
                  alpha = .1,bins = 50,
                  geom = "polygon") +
  scale_fill_gradientn(colors = brewer.pal(7, "YlOrRd"))+
  ggtitle("Density Plot of J1772COMBO Charging Stations")
graph6
ggsave("graph6.png",width = 4, height = 4)



## Density Map of J1772 type Charging Stations 
graph7<- ggmap(us, extent = "panel")  +
  stat_density_2d(data = data_TESLA,
                  aes(x = Longitude,y = Latitude,fill = stat(level)),
                  alpha = .25, bins = 30,
                  geom = "polygon") +
  scale_fill_gradientn(colors = brewer.pal(7, "YlOrRd"))+
  ggtitle("Density Plot of TESLA Charging Stations")
graph7
ggsave("graph7.png",width = 4, height = 4)

#spatstat denisty plot
id.chull <- convexhull.xy(x =df.spp.sp$Easting, y = df.spp.sp$Northing)

plot(x = df.spp.sp$Easting, y = df.spp.sp$Northing)

id.ppp <- ppp(x = df.spp.sp$Easting, y = df.spp.sp$Northing, window = id.chull)

unitname(id.ppp) <- c("meter", "meters")  ##Assign names to units

persp(density(id.ppp, 1000))
#rotate by adjusting theta
jpeg("plot8.jpg", width = 850, height = 850)
persp(density(id.ppp, 1000), theta = 240, phi = 15)  
dev.off()
