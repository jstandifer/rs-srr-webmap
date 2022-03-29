library('leaflet')
library('shiny')
library('leaflet.extras')
library('shinythemes')
library('rgdal')
library('sp')
library('htmltools')
library('viridis')
library('dplyr')
library('rmapshaper')

#Import data
territor <- readOGR("shp/UNDP_territories.shp")
roa <-readOGR("shp/line.shp") 


bridge<-readOGR("shp/bridge3.shp") 
cattle<-readOGR("shp/cattle.shp") 
dock<-readOGR("shp/dock.shp") 
dryport<-readOGR("shp/dryport.shp") 
health<-readOGR("shp/health.shp") 
land<-readOGR("shp/land.shp") 
security<-readOGR("shp/security.shp") 
market<-readOGR("shp/market.shp") 

territory <- rmapshaper::ms_simplify(territor, keep = 0.05, keep_shapes = TRUE)
road<- rmapshaper::ms_simplify(roa, keep = 0.05, keep_shapes = TRUE)
#roadpal <- colorFactor(viridis(2), road$type)


#Icons for the site interventions
bridgeicon <-makeIcon("bridge2.png", "bridge2.png", 14, 14)
cattleicon <-makeIcon("cattle2.png", "cattle2.png", 14, 14)
dockicon <-makeIcon("dock2.png", "dock2.png", 14, 14)
dryporticon <-makeIcon("dryport2.png", "dryport2.png", 14, 14)
healthicon <-makeIcon("health2.png", "health2.png", 14, 14)
landicon <-makeIcon("land2.png", "land2.png", 14, 14)
securityicon <-makeIcon("security2.png", "security2.png", 14, 14)
marketicon <-makeIcon("market2.png", "market2.png", 14, 14)

#Custom legend for the site icons
html_legend <- "<img src='bridge.png'style='width:20px;height:15px;'> Bridge<br/>
<br/>
<img src='cattle.png'style='width:20px;height:15px;'> Cattle market<br/>
<br/>
<img src='dock.png'style='width:20px;height:15px;'> Dock<br/>
<br/>
<img src='dryport.png'style='width:20px;height:15px;'> Dryport<br/>
<br/>
<img src='health.png'style='width:20px;height:15px;'> Health facility<br/>
<br/>
<img src='land.png'style='width:20px;height:15px;'> Arable land<br/>
<br/>
<img src='security.png'style='width:15px;height:15px;'> Security post<br/>
<br/>
<img src='market.png'style='width:20px;height:15px;'> Market
"
#popup icons
#check <-"<img src='bridge.png'style='width:20px;height:15px;'>"
#cross <-"<img src='cattle.png'style='width:20px;height:15px;'>"

#popup labels for the site interventions
bridge_label<- paste("<b>",bridge$label,"</b>","<br>",
"Details:","<br>",
"Estimated Affected Population:", bridge$pop, "<br>",
"MNJTF Sector:",bridge$mnjtf,"<br>",
"UNDP JAP Location:",bridge$jap,"<br>",
"<b>","Nearby infrastructure present","</b>","<br>",
"Education facility:",bridge$education,"<br>",
"Health facility:",bridge$health,"<br>",
"Market:",bridge$market)

cattle_label<- paste("<b>",cattle$label,"</b>","<br>",
                     "Details:","<br>",
                     "Estimated Affected Population:", cattle$pop, "<br>",
                     "MNJTF Sector:",cattle$mnjtf,"<br>",
                     "UNDP JAP Location:",cattle$jap,"<br>",
                     "<b>","Nearby infrastructure present","</b>","<br>",
                     "Education facility:",cattle$education,"<br>",
                     "Health facility:",cattle$health,"<br>",
                     "Market:",cattle$market)

dock_label<- paste("<b>",dock$label,"</b>","<br>",
                     "Details:","<br>",
                     "Estimated Affected Population:", dock$pop, "<br>",
                     "MNJTF Sector:",dock$mnjtf,"<br>",
                     "UNDP JAP Location:",dock$jap,"<br>",
                     "<b>","Nearby infrastructure present","</b>","<br>",
                     "Education facility:",dock$education,"<br>",
                     "Health facility:",dock$health,"<br>",
                     "Market:",dock$market)

dryport_label<- paste("<b>",dryport$label,"</b>","<br>",
                   "Details:","<br>",
                   "Estimated Affected Population:", dryport$pop, "<br>",
                   "MNJTF Sector:",dryport$mnjtf,"<br>",
                   "UNDP JAP Location:",dryport$jap,"<br>",
                   "<b>","Nearby infrastructure present","</b>","<br>",
                   "Education facility:",dryport$education,"<br>",
                   "Health facility:",dryport$health,"<br>",
                   "Market:",dryport$market)

health_label<- paste("<b>",health$label,"</b>","<br>",
                      "Details:","<br>",
                      "Estimated Affected Population:", health$pop, "<br>",
                      "MNJTF Sector:",health$mnjtf,"<br>",
                      "UNDP JAP Location:",health$jap,"<br>",
                      "<b>","Nearby infrastructure present","</b>","<br>",
                      "Education facility:",health$education,"<br>",
                      "Health facility:",health$health,"<br>",
                      "Market:",health$market)

land_label<- paste("<b>",land$label,"</b>","<br>",
                     "Details:","<br>",
                     "Estimated Affected Population:", land$pop, "<br>",
                     "MNJTF Sector:",land$mnjtf,"<br>",
                     "UNDP JAP Location:",land$jap,"<br>",
                     "<b>","Nearby infrastructure present","</b>","<br>",
                     "Education facility:",land$education,"<br>",
                     "Health facility:",land$health,"<br>",
                     "Market:",land$market)

security_label<- paste("<b>",security$label,"</b>","<br>",
                   "Details:","<br>",
                   "Estimated Affected Population:", security$pop, "<br>",
                   "MNJTF Sector:",security$mnjtf,"<br>",
                   "UNDP JAP Location:",security$jap,"<br>",
                   "<b>","Nearby infrastructure present","</b>","<br>",
                   "Education facility:",security$education,"<br>",
                   "Health facility:",security$health,"<br>",
                   "Market:",security$market)

market_label<- paste("<b>",market$label,"</b>","<br>",
                       "Details:","<br>",
                       "Estimated Affected Population:", market$pop, "<br>",
                       "MNJTF Sector:",market$mnjtf,"<br>",
                       "UNDP JAP Location:",market$jap,"<br>",
                       "<b>","Nearby infrastructure present","</b>","<br>",
                       "Education facility:",market$education,"<br>",
                       "Health facility:",market$health,"<br>",
                       "Market:",market$market)

#Shiny App
ui<- bootstrapPage(
  navbarPage("Lake Chad Basin", theme = shinytheme("simplex"), collapsible = TRUE, id="nav",
             windowTitle = "Lake Chad Basin",
             
             tabPanel("Cross-border Interventions Map",
                      div(class="outer",
                          tags$head(includeCSS("styles.css")),
                          leafletOutput("mymap", width="100%", height="100%"),
                          
                          absolutePanel(id = "controls", class = "panel panel-default",
                                        top = 75, left = 55, width = 250, fixed=TRUE,
                                        draggable = TRUE, height = "auto",
                                        
                                        span(tags$i(h4("")),tags$i(h5("This web map highlights needed cross-border interventions in the Lake Chad Basin identified in the April 2021 Cross-Border Interventions Workshop held in N’Djamena, Chad. equuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetue magnam minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariaturt perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam  quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pari" )), style="color:#045a8d")
                          ),
                          
                          absolutePanel(id = "logo", class = "card", bottom = 20, left = 60, width = 80, fixed=TRUE, draggable = FALSE, height = "auto",
                                        tags$a(href='https://cblt.org/', tags$img(src='logo.png',height='80',width='225')))
                          
                      )
             ),
             
             tabPanel("Methodology & Background",
                      tags$div(
                        tags$h4("Background"), 
                        "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
                        tags$br(),tags$br(),
                        "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
                        
                        tags$br(),tags$br(),tags$h4("Methodology"),
                        tags$h5("Population Estimates"),
                        "To measure each cross-border intervention’s estimated affected population, spatial analysis was conducted using admin 2 administrative boundaries and the WorldPop gridded population estimates. Firstly, population was calculated using the latest 2021 population estimates in the 8 territories by administrative zones (admin 2). Once population was calculated, a 10km buffer around each intervention site was created; the population sum from the administrative 2 zones within the buffer region were used as the final estimated affected population by intervention.",
                        tags$br(),tags$h5("Cost Calculation Estimates"),
                        "Based on xxx project conducted in 20xx the average cost per km of road equaled xx USD. This  average cost was used as the cost per km, total estimates include the cost per km x total km.",
                        tags$br(),tags$h5("Infrastructure Presence"),
                        "The presence of health, education, and secuity posts were deemed “present” if locations existed within a 25km range.", 
                        tags$a(href="https://experience.arcgis.com/experience/685d0ace521648f8a5beeeee1b9125cd", "the WHO,"),
                        tags$a(href="https://gisanddata.maps.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6", "Johns Hopkins University,"),"and",
                        tags$a(href="https://ourworldindata.org/coronavirus-data-explorer?zoomToSelection=true&time=2020-03-01..latest&country=IND~USA~GBR~CAN~DEU~FRA&region=World&casesMetric=true&interval=smoothed&perCapita=true&smoothing=7&pickerMetric=total_cases&pickerSort=desc", "Our World in Data."),
                        "Our aim is to complement these resources with several interactive features, including the timeline function and the ability to overlay past outbreaks.",
                        
                        tags$br(),tags$br(),tags$h4("Code"),
                        "Code and input data used to generate this Shiny mapping tool are available on ",tags$a(href="", "Github."),
                        tags$br(),tags$br(),tags$h4("Sources & References"),
                        tags$b("Population: "), tags$a(href="https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series", "Johns Hopkins Center for Systems Science and Engineering github page,")," with additional information from the ",tags$a(href="https://www.who.int/emergencies/diseases/novel-coronavirus-2019/situation-reports", "WHO's COVID-19 situation reports."),
                        " In previous versions of this site (up to 17th March 2020), updates were based solely on the WHO's situation reports.",tags$br(),
                        tags$b("Humdata: "), tags$a(href="https://github.com/nytimes/covid-19-data", "New York Times github page"),
                        tags$br(),tags$br(),tags$h4("Authors"),
                        "Participants of the Cross-Border Interventions Workshop",
                        tags$br(),
                        "Technical Support: Jessie Standifer, GIS Consultant, UNDP",tags$br(),
                        tags$br(),tags$h4("Contact"),
                        tags$h5("Chika Charles, Head of Stabilization RSS Secretariat, UNDP Sub-Regional Hub for West and Central Africa"),
                        "ChikaCharles.Aniekwe@undp.org",tags$br(),tags$br(),
                        tags$img(src = "logo.png", width = "285px", height = "100px")
                      )
             )
             
             
  )          
)

server <- function(input, output, session) {
  
  points <- eventReactive(input$recalc, {
    cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
  }, ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron)%>%
      addPolylines(data=road, weight=2, color = "black",
                   dashArray = "5, 5",
                   popup = paste("<b>",road$label,"</b>","<br>",
                                 "Total Length:",road$length,"km","<br>",
                                 "Estimated Affected Population:", road$pop_label, "<br>"),
                   highlightOptions = highlightOptions(color = "red", weight = 3,
                                                       bringToFront = TRUE),
                   group = "Proposed road and dredging network")%>%
      addMarkers(data=bridge,
                 icon = bridgeicon,
                 popup = paste(bridge_label),
                 group="Proposed bridge location")%>%
      addMarkers(data=cattle,
                 icon = cattleicon,
                 popup = paste(cattle_label),
                 group="Proposed cattle market location")%>%
      addMarkers(data=dock,
                 icon = dockicon,
                 popup = paste(dock_label),
                 group="Proposed dock location")%>%
      addMarkers(data=dryport,
                 icon = dryporticon,
                 popup = paste(dryport_label),
                 group="Proposed drydock location")%>%
      addMarkers(data=health,
                 icon = healthicon,
                 popup = paste(health_label),
                 group="Proposed health facility")%>%
      addMarkers(data=market,
                 icon = marketicon,
                 popup = paste(market_label),
                 group="Proposed market location")%>%
      addMarkers(data=land,
                 icon = landicon,
                 popup = paste(land_label),
                 group="Proposed irrigated land")%>%
      addMarkers(data=security,
                 icon = securityicon,
                 popup = paste(security_label),
                 group="Proposed security post")%>%
      addPolygons(data=territory, weight = 2, fillColor = 'grey', color = 'grey',group = "Cross-border territory")%>%
      addSearchOSM()%>%
      addResetMapButton()%>%
      setView(lng = 9.347159962006943, lat=11.1611720400214, zoom = 6)%>%
      addMiniMap(
        tiles = providers$Esri.WorldGrayCanvas,
        toggleDisplay = TRUE)%>%
      addLayersControl(overlayGroups = c("Cross-border territory","Proposed road and dredging network", "Proposed site interventions"))%>%
    addLegend(#legend for the line file#
      color = "black",
      labels = "Road Construction",
      title = "Proposed Network Intervention",
      opacity = 1, 
      position = "topright",
      group =  "Proposed road and dredging network"
    )%>%
#      addControl(html = html_legend, position = "topright", layerId = "A" )%>%
      hideGroup("Proposed road and dredging network")%>%
      hideGroup("Proposed bridge location")%>%
      hideGroup("Proposed dock location")%>%
      hideGroup("Proposed drydock location")%>%
      hideGroup("Proposed health facility")%>%
      hideGroup("Proposed market location")%>%
      hideGroup("Proposed irrigated land")
  })
  
}

shinyApp(ui, server)


library(rsconnect)
rsconnect::deployApp('/Users/jessie/Documents/GitHub/rss-shiny/rss.R')
