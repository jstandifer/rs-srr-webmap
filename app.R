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
library('rgeos')


#############DATA############################
#Import data
#############################################

territor <- readOGR("shp/undp_territories_1.shp")
line <-readOGR("shp/line.shp") 
dredging <- readOGR("shp/dredging.shp") 
road <-readOGR("shp/road.shp") 
bridge<-readOGR("shp/bridge10.shp") 
cattle<-readOGR("shp/cattle10.shp") 
dock<-readOGR("shp/dock10.shp") 
dryport<-readOGR("shp/dryport10.shp") 
health<-readOGR("shp/health10.shp") 
land<-readOGR("shp/land10.shp") 
security<-readOGR("shp/security10.shp") 
market<-readOGR("shp/market10.shp") 
truck<- readOGR("shp/truck10.shp") 


territory <- rmapshaper::ms_simplify(territor, keep = 0.05, keep_shapes = TRUE)
#territory_label<- readOGR("shp/UNDP_territories_1.shp")

#road<- rmapshaper::ms_simplify(roa, keep = 0.05, keep_shapes = TRUE)
#roadpal <- colorFactor(viridis(2), road$type)

#############################################
### PREP
#############################################

#############DATA############################
#Icons for the site interventions
#############################################

bridgeicon <-makeIcon("bridge2.png", "bridge2.png", 18, 18)
cattleicon <-makeIcon("cattle2.png", "cattle2.png", 18, 18)
dockicon <-makeIcon("dock2.png", "dock2.png", 18, 18)
dryporticon <-makeIcon("drydock.png", "drydock.png", 18, 18)
healthicon <-makeIcon("health2.png", "health2.png", 18, 18)
landicon <-makeIcon("land2.png", "land2.png", 18, 18)
securityicon <-makeIcon("security2.png", "security2.png", 18, 18)
marketicon <-makeIcon("market2.png", "market2.png", 18, 18)
truckicon <- makeIcon("truck2.png", "truck2.png", 18, 18)

#############DATA############################
#Custom legend with icons
#############################################

html_legend <- "<img src='bridge.png'style='width:20px;height:15px;'> Bridge<br/>
<br/>
<img src='cattle.png'style='width:20px;height:15px;'> Cattle market<br/>
<br/>
<img src='dock.png'style='width:20px;height:15px;'> Dock<br/>
<br/>
<img src='dryport.png'style='width:20px;height:15px;'> Dry port<br/>
<br/>
<img src='health.png'style='width:20px;height:15px;'> Health facility<br/>
<br/>
<img src='land.png'style='width:20px;height:15px;'> Irrigated land<br/>
<br/>
<img src='security.png'style='width:15px;height:15px;'> Security post<br/>
<br/>
<img src='market.png'style='width:20px;height:15px;'> Market<br/>
<br/>
<img src='truck.png'style='width:20px;height:15px;'> Truck park
"
#popup icons

ibridge <-"<img src='bridge2.png'style='width:20px;height:15px;'>"
icattle <-"<img src='cattle2.png'style='width:20px;height:15px;'>"
idock <-"<img src='dock2.png'style='width:20px;height:15px;'>"
idryport<-"img src='drydock.png'style='width:20px;height:15px;'>"
ihealth<-"img src='health2.png'style='width:20px;height:15px;'>"
iland<-"img src='land2.png'style='width:20px;height:15px;'>"  
isecurity<-"img src='security2.png'style='width:20px;height:15px;'>"
imarket<-"img src='market2.png'style='width:20px;height:15px;'>"
itruck<-"img src='truck2.png'style='width:20px;height:15px;'>"
iroad<-

#############################################
#popup labels for the site interventions
#############################################

bridge_label<- paste("<b>",bridge$label,"</b>","<br>",
                     "<i>","Details:",bridge$des,"</i>","<br>",
                     "Estimated Affected Population:", "<b>",bridge$pop,"</b>", "<br>",
                     "MNJTF Sector:","<b>",bridge$mnjtf,"</b>","<br>",
                     "UNDP JAP Location:","<b>",bridge$jap,"</b>","<br>","<br>",
                     "<i>","Nearby infrastructure present","</i>","<br>",
                     "Education facility:","<b>",bridge$education,"</b>","<br>",
                     "Health facility:","<b>",bridge$health,"</b>","<br>",
                     "Market:","<b>",bridge$market,"</b>")

cattle_label<- paste("<b>",cattle$label,"</b>","<br>",
                     "<i>","Details:",cattle$des,"</i>","<br>",
                     "Estimated Affected Population:", "<b>",cattle$pop, "</b>","<br>",
                     "MNJTF Sector:","<b>",cattle$mnjtf,"</b>","<br>",
                     "UNDP JAP Location:","<b>",cattle$jap,"</b>","<br>","<br>",
                     "<i>","Nearby infrastructure present","</i>","<br>",
                     "Education facility:","<b>",cattle$education,"</b>","<br>",
                     "Health facility:","<b>",cattle$health,"</b>","<br>",
                     "Market:","<b>",cattle$market,"</b>")

dock_label<- paste("<b>",dock$label,"</b>","<br>",
                   "<i>","Details:",dock$des,"</i>","<br>",
                   "Estimated Affected Population:", "<b>",dock$pop,"</b>", "<br>",
                   "MNJTF Sector:","<b>",dock$mnjtf,"</b>","<br>",
                   "UNDP JAP Location:","<b>",dock$jap,"</b>","<br>","<br>",
                   "<i>","Nearby infrastructure present","</i>","<br>",
                   "Education facility:","<b>",dock$education,"</b>","<br>",
                   "Health facility:","<b>",dock$health,"</b>","<br>",
                   "Market:","<b>",dock$market,"</b>")

dryport_label<- paste("<b>","Dry port","</b>","<br>",
                      "<i>","Details:",dryport$des,"</i>","<br>",
                      "Estimated Affected Population:", "<b>",dryport$pop,"</b>", "<br>",
                      "MNJTF Sector:","<b>",dryport$mnjtf,"</b>","<br>",
                      "UNDP JAP Location:","<b>",dryport$jap,"</b>","<br>","<br>",
                      "<i>","Nearby infrastructure present","</i>","<br>",
                      "Education facility:","<b>",dryport$education,"</b>","<br>",
                      "Health facility:","<b>",dryport$health,"</b>","<br>",
                      "Market:","<b>",dryport$market,"</b>")

health_label<- paste("<b>",health$label,"</b>","<br>",
                     "<i>","Details:",health$des,"</i>","<br>",
                     "Estimated Affected Population:","<b>", health$pop,"</b>", "<br>",
                     "MNJTF Sector:","<b>",health$mnjtf,"</b>","<br>",
                     "UNDP JAP Location:","<b>",health$jap,"</b>","<br>","<br>",
                     "<i>","Nearby infrastructure present","</i>","<br>",
                     "Education facility:","<b>",health$education,"</b>","<br>",
                     "Health facility:","<b>",health$health,"</b>","<br>",
                     "Market:","<b>",health$market,"</b>")

land_label<- paste("<b>",land$label,"</b>","<br>",
                   "<i>","Details:",land$des,"</i>","<br>",
                   "Estimated Affected Population:","<b>", land$pop,"</b>", "<br>",
                   "MNJTF Sector:","<b>",land$mnjtf,"</b>","<br>",
                   "UNDP JAP Location:","<b>",land$jap,"</b>","<br>","<br>",
                   "<i>","Nearby infrastructure present","</i>","<br>",
                   "Education facility:","<b>",land$education,"</b>","<br>",
                   "Health facility:","<b>",land$health,"</b>","<br>",
                   "Market:","<b>",land$market,"</b>"
                   )

security_label<- paste("<b>",security$label,"</b>","<br>",
                       "<i>","Details:",security$des,"</i>","<br>",
                       "Estimated Affected Population:","<b>", security$pop,"</b>", "<br>",
                       "MNJTF Sector:","<b>",security$mnjtf,"</b>","<br>",
                       "UNDP JAP Location:","<b>",security$jap,"</b>","<br>","<br>",
                       "<i>","Nearby infrastructure present","</i>","<br>",
                       "Education facility:","<b>",security$education,"</b>","<br>",
                       "Health facility:","<b>",security$health,"</b>","<br>",
                       "Market:","<b>",security$market,"</b>")

market_label<- paste("<b>",market$label,"</b>","<br>",
                     "<i>","Details:",market$des,"</i>","<br>",
                     "Estimated Affected Population:", "<b>",market$pop,"</b>", "<br>",
                     "MNJTF Sector:","<b>",market$mnjtf,"</b>","<br>",
                     "UNDP JAP Location:","<b>",market$jap,"</b>","<br>","<br>",
                     "<i>","Nearby infrastructure present","</i>","<br>",
                     "Education facility:","<b>",market$education,"</b>","<br>",
                     "Health facility:","<b>",market$health,"</b>","<br>",
                     "Market:","<b>",market$market,"</b>")

road_label<- paste("<b>",road$label,"</b>","<br>",
                   "<i>","Details:",road$type,"</i>","<br>",
                    "Total Length:","<b>",road$length,"km","</b>","<br>",
                    "Estimated Affected Population:","<b>", road$pop_label,"</b>", "<br>")

dredging_label<- paste("<b>",dredging$label,"</b>","<br>",
                   "<i>","Details:",dredging$type,"</i>","<br>",
                   "Total Length:","<b>",dredging$length,"km","</b>","<br>",
                   "Estimated Affected Population:","<b>", dredging$pop_label,"</b>", "<br>")

truck_label<- paste("<b>",truck$label,"</b>","<br>",
                    "<i>","Details:",truck$des,"</i>","<br>",
                    "Estimated Affected Population:","<b>", truck$pop,"</b>", "<br>",
                    "MNJTF Sector:","<b>",truck$mnjtf,"</b>","<br>",
                    "UNDP JAP Location:","<b>",truck$jap,"</b>","<br>","<br>",
                    "<i>","Nearby infrastructure present","</i>","<br>",
                    "Education facility:","<b>",truck$education,"</b>","<br>",
                    "Health facility:","<b>",truck$health,"</b>","<br>",
                    "Market:","<b>",truck$market,"</b>")

#############################################
#popup labels for TERRITORIES
#############################################


borno_label<-paste("<b>","Borno, Nigeria","</b>","<br>",
                   "<i>","15 Interventions Proposed","</i>","<br>",
                   "<br>",
                   "Including:","<br>",
                   html= "&#8226;","3 bridge proposals","<br>",
                   html= "&#8226;","4 market proposals","<br>",
                   html= "&#8226;","3 security proposals", "<br>",
                   html= "&#8226;","1 health facility proposal","<br>",
                   html= "&#8226;","3 road construction proposals","<br>","<br>",
                   "Total population: 6,594,992 ","<br>",
                   "Total IDPs: 1,633,829")

adamawa_label<-paste("<b>","Adamawa, Nigeria","</b>","<br>",
                     "<i>"," Interventions Proposed","</i>","<br>",
                     "<br>",
                     "Including:","<br>",
                     html= "&#8226;"," bridge proposals","<br>",
                     html= "&#8226;"," market proposals","<br>",
                     html= "&#8226;"," security proposals", "<br>",
                     html= "&#8226;"," health facility proposal","<br>",
                     html= "&#8226;"," road construction proposals","<br>","<br>",
                     "Total population: 4,396,599","<br>",
                     "Total IDPs: 209,322")

yobe_label<-paste("<b>","Adamawa, Nigeria","</b>","<br>",
                  "<i>"," Interventions Proposed","</i>","<br>",
                  "<br>",
                  "Including:","<br>",
                  html= "&#8226;"," bridge proposals","<br>",
                  html= "&#8226;"," market proposals","<br>",
                  html= "&#8226;"," security proposals", "<br>",
                  html= "&#8226;"," health facility proposal","<br>",
                  html= "&#8226;"," road construction proposals","<br>","<br>",
                  "Total population: 3,619,142","<br>",
                  "Total IDPs: 162,394")

north_label<-paste("<b>","North, Cameroon","</b>","<br>",
                   "<i>"," Interventions Proposed","</i>","<br>",
                   "<br>",
                   "Including:","<br>",
                   html= "&#8226;"," bridge proposals","<br>",
                   html= "&#8226;"," market proposals","<br>",
                   html= "&#8226;"," security proposals", "<br>",
                   html= "&#8226;"," health facility proposal","<br>",
                   html= "&#8226;"," road construction proposals","<br>","<br>",
                   "Total population: 3,074,326 ","<br>",
                   "Total refugees: 41,394 ")

far_label<-paste("<b>","Far North, Cameroon","</b>","<br>",
                     "<i>"," Interventions Proposed","</i>","<br>",
                     "<br>",
                     "Including:","<br>",
                     html= "&#8226;"," bridge proposals","<br>",
                     html= "&#8226;"," market proposals","<br>",
                     html= "&#8226;"," security proposals", "<br>",
                     html= "&#8226;"," health facility proposal","<br>",
                     html= "&#8226;"," road construction proposals","<br>","<br>",
                     "Total population: 4,874,303 ","<br>",
                     "Total IDPs: 341,535","<br>",
                     "Total refugees: 48,902")

lac_label<-paste("<b>","Lac, Chad","</b>","<br>",
                 "<i>"," Interventions Proposed","</i>","<br>",
                 "<br>",
                 "Including:","<br>",
                 html= "&#8226;"," bridge proposals","<br>",
                 html= "&#8226;"," market proposals","<br>",
                 html= "&#8226;"," security proposals", "<br>",
                 html= "&#8226;"," health facility proposal","<br>",
                 html= "&#8226;"," road construction proposals","<br>","<br>",
                 "Total population: 657,165 ","<br>",
                 "Total IDPs: 178,928")

hadjer_label<-paste("<b>","Hadjer-Lamis, Chad","</b>","<br>",
                    "<i>"," Interventions Proposed","</i>","<br>",
                    "<br>",
                    "Including:","<br>",
                    html= "&#8226;"," bridge proposals","<br>",
                    html= "&#8226;"," market proposals","<br>",
                    html= "&#8226;"," security proposals", "<br>",
                    html= "&#8226;"," health facility proposal","<br>",
                    html= "&#8226;"," road construction proposals","<br>","<br>",
                    "Total population: 846,045 ","<br>")

diffa_label<-paste("<b>","Diffa, Niger","</b>","<br>",
                   "<i>"," Interventions Proposed","</i>","<br>",
                   "<br>",
                   "Including:","<br>",
                   html= "&#8226;"," bridge proposals","<br>",
                   html= "&#8226;"," market proposals","<br>",
                   html= "&#8226;"," security proposals", "<br>",
                   html= "&#8226;"," health facility proposal","<br>",
                   html= "&#8226;"," road construction proposals","<br>","<br>",
                   "Total population: 788,474 ","<br>",
                   "Total IDPs: 81,464","<br>",
                   "Total refugees: 130,023")

territory_tooltip <- sprintf(
  '<strong><span style="font-size: 15px; color: #e36154;font-family:Helvetica Neue;margin-bottom: 1px;">%s </span><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Total population: %s<br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Total IDPs: %s<br>
  <span style="font-size: 12
  px; color: #58585A;font-family:Helvetica Neue;">Total refugees: %s<br></strong><br>
  <span style="font-size: 15px; color: #58585A;font-family:Helvetica Neue;"><i> <b>%s</b>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Interventions proposed </i><br><br>
  <span style="font-size: 10px; color: #58585A;font-family:Helvetica Neue;"> Including:<br>
  <span style="font-size: 10px; color: #58585A;font-family:Helvetica Neue;">%s Road construction proposals<br>
  <span style="font-size: 10px; color: #58585A;font-family:Helvetica Neue;">%s River dredging proposals<br>
  <span style="font-size: 10px; color: #58585A;font-family:Helvetica Neue;">%s Market proposals<br>
  <span style="font-size: 10px; color: #58585A;font-family:Helvetica Neue;">%s Security post proposals<br>
  <span style="font-size: 10px; color: #58585A;font-family:Helvetica Neue;">%s Bridge construction proposals<br>
  <span style="font-size: 10px; color: #58585A;font-family:Helvetica Neue;">%s Dock proposals<br>
  <span style="font-size: 10px; color: #58585A;font-family:Helvetica Neue;">%s Dryport proposals<br>
  <span style="font-size: 10px; color: #58585A;font-family:Helvetica Neue;">%s Health facility proposals<br>
  <span style="font-size: 10px; color: #58585A;font-family:Helvetica Neue;">%s Cattle market proposals<br>
  <span style="font-size: 10px; color: #58585A;font-family:Helvetica Neue;">%s Truck park proposals<br>
  <span style="font-size: 10px; color: #58585A;font-family:Helvetica Neue;">%s Irrigated land proposals<br><br>
  </span>',
  territory$name_upper,territory$tpop,territory$idp,territory$ref, territory$int,territory$road,territory$dredge,territory$market,territory$security, 
  territory$bridge,territory$dock,territory$dryport,territory$health,territory$cattle,territory$truck,territory$land)%>% 
  lapply(htmltools::HTML)

bridge_tooltip <- sprintf(
  '<strong><span style="font-size: 12px; color: #e36154;font-family:Helvetica Neue;margin-bottom: 1px;">%s </span></strong><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Details: %s</i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Estimated Affected Population:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">MNJTF Sector:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">UNDP JAP Location: <b>%s</b><br><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Nearby infrastructure present </i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Education facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Health facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Market:<b>%s</b><br>
  </span>',
  bridge$label,bridge$des,bridge$pop,bridge$mnjtf,bridge$jap,bridge$education,bridge$health,bridge$market)%>% 
  lapply(htmltools::HTML)

cattle_tooltip <- sprintf(
  '<strong><span style="font-size: 12px; color: #e36154;font-family:Helvetica Neue;margin-bottom: 1px;">%s </span></strong><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Details: %s</i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Estimated Affected Population:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">MNJTF Sector:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">UNDP JAP Location: <b>%s</b><br><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Nearby infrastructure present </i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Education facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Health facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Market:<b>%s</b><br>
  </span>',
  cattle$label,cattle$des,cattle$pop,cattle$mnjtf,cattle$jap,cattle$education,cattle$health,cattle$market)%>% 
  lapply(htmltools::HTML)

dock_tooltip <- sprintf(
  '<strong><span style="font-size: 12px; color: #e36154;font-family:Helvetica Neue;margin-bottom: 1px;">%s </span></strong><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Details: %s</i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Estimated Affected Population:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">MNJTF Sector:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">UNDP JAP Location: <b>%s</b><br><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Nearby infrastructure present </i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Education facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Health facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Market:<b>%s</b><br>
  </span>',
  dock$label,dock$des,dock$pop,dock$mnjtf,dock$jap,dock$education,dock$health,dock$market)%>% 
  lapply(htmltools::HTML)

dryport_tooltip <- sprintf(
  '<strong><span style="font-size: 12px; color: #e36154;font-family:Helvetica Neue;margin-bottom: 1px;">%s </span></strong><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Details: %s</i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Estimated Affected Population:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">MNJTF Sector:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">UNDP JAP Location: <b>%s</b><br><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Nearby infrastructure present </i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Education facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Health facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Market:<b>%s</b><br>
  </span>',
  dryport$label,dryport$des,dryport$pop,dryport$mnjtf,dryport$jap,dryport$education,dryport$health,dryport$market)%>% 
  lapply(htmltools::HTML)

health_tooltip <- sprintf(
  '<strong><span style="font-size: 12px; color: #e36154;font-family:Helvetica Neue;margin-bottom: 1px;">%s </span></strong><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Details: %s</i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Estimated Affected Population:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">MNJTF Sector:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">UNDP JAP Location: <b>%s</b><br><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Nearby infrastructure present </i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Education facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Health facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Market:<b>%s</b><br>
  </span>',
  health$label,health$des,health$pop,health$mnjtf,health$jap,health$education,health$health,health$market)%>% 
  lapply(htmltools::HTML)

land_tooltip <- sprintf(
  '<strong><span style="font-size: 12px; color: #e36154;font-family:Helvetica Neue;margin-bottom: 1px;">%s </span></strong><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Details: %s</i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Estimated Affected Population:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">MNJTF Sector:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">UNDP JAP Location: <b>%s</b><br><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Nearby infrastructure present </i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Education facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Health facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Market:<b>%s</b><br>
  </span>',
  land$label,land$des,land$pop,land$mnjtf,land$jap,land$education,land$health,land$market)%>% 
  lapply(htmltools::HTML)

security_tooltip <- sprintf(
  '<strong><span style="font-size: 12px; color: #e36154;font-family:Helvetica Neue;margin-bottom: 1px;">%s </span></strong><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Details: %s</i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Estimated Affected Population:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">MNJTF Sector:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">UNDP JAP Location: <b>%s</b><br><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Nearby infrastructure present </i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Education facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Health facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Market:<b>%s</b><br>
  </span>',
  security$label,security$des,security$pop,security$mnjtf,security$jap,security$education,security$health,security$market)%>% 
  lapply(htmltools::HTML)

market_tooltip <- sprintf(
  '<strong><span style="font-size: 12px; color: #e36154;font-family:Helvetica Neue;margin-bottom: 1px;">%s </span></strong><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Details: %s</i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Estimated Affected Population:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">MNJTF Sector:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">UNDP JAP Location: <b>%s</b><br><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Nearby infrastructure present </i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Education facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Health facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Market:<b>%s</b><br>
  </span>',
  market$label,market$des,market$pop,market$mnjtf,market$jap,market$education,market$health,market$market)%>% 
  lapply(htmltools::HTML)

truck_tooltip <- sprintf(
  '<strong><span style="font-size: 12px; color: #e36154;font-family:Helvetica Neue;margin-bottom: 1px;">%s </span></strong><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Details: %s</i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Estimated Affected Population:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">MNJTF Sector:<b> %s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">UNDP JAP Location: <b>%s</b><br><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Nearby infrastructure present </i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Education facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Health facility:<b>%s</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Market:<b>%s</b><br>
  </span>',
  truck$label,truck$des,truck$pop,truck$mnjtf,truck$jap,truck$education,truck$health,truck$market)%>% 
  lapply(htmltools::HTML)

road_tooltip <- sprintf(
  '<strong><span style="font-size: 12px; color: #e36154;font-family:Helvetica Neue;margin-bottom: 1px;">%s </span></strong><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Details: %s</i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Total length:<b> %skm</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Estimated Affected Population:<b> %s</b><br>
  </span>',
  road$label,road$type,road$length,road$pop_label)%>% 
  lapply(htmltools::HTML)

dredging_tooltip <- sprintf(
  '<strong><span style="font-size: 12px; color: #e36154;font-family:Helvetica Neue;margin-bottom: 1px;">%s </span></strong><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;"><i>Details: %s</i><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Total length:<b> %skm</b><br>
  <span style="font-size: 12px; color: #58585A;font-family:Helvetica Neue;">Estimated Affected Population:<b> %s</b><br>
  </span>',
  dredging$label,dredging$type,dredging$length,dredging$pop_label)%>% 
  lapply(htmltools::HTML)

#############################################
#SHINY APP
#############################################

ui<- bootstrapPage(
    navbarPage("Lake Chad Basin", theme = shinytheme("simplex"), collapsible = TRUE, id="nav",
               windowTitle = "Cross-Border Interventions Map",
               
               tabPanel("Cross-Border Interventions Map",
                        div(class="outer",
                            tags$head(includeCSS("styles.css")),
                            leafletOutput("mymap", width="100%", height="100%"),
                            
                            absolutePanel(id = "controls", class = "panel panel-default",
                                          top = 75, left = 55, width = 250, fixed=TRUE,
                                          draggable = FALSE, height = "auto",
                                          
                                          span(tags$h4("In the Lake Chad Basin, border communities have played a significant role in the historic trans-Saharan trade routes, building strong local ties with porous borders."),tags$h5("However, due to the intensification of the insurgency in recent years, border communities are facing challenges with market closures, restricted movements, limited access, and notably, increased security threats. 

Insecurity along major trade routes and restricted road access have led many traders to travel further distances along alternative routes, increasing costs of transportation and overall trade. While cross-border trade persists, the volume of movement has decreased compared to pre-crisis trade levels. Today, as populations return to border communities, markets reopen, and security is maintained, it is crucial to invest in community driven cross-border interventions to support long-term resilience in the region."), 
                                               tags$h5("This web map highlights proposed cross-border interventions in the Lake Chad Basin identified in the April 2021 Cross-Border Interventions Workshop held in N’Djamena, Chad."), style="color:#045a8d")
                            ),
                            
                            absolutePanel(id = "logo", class = "card", bottom = 20, left = 60, width = 80, fixed=TRUE, draggable = FALSE, height = "auto",
                                          tags$a(href='https://cblt.org/', tags$img(src='lcbc.png',height='160',width='160')))
                            
                        )
               ),
               
               tabPanel("Methodology & Background",
                        tags$div(
                            tags$h4("Background"), 
                            "While national efforts exist, the Regional Strategy for Stabilization, Recovery and Resilience (RS-SRR) of the Boko Haram affected areas of the Lake Chad Basin recognize that strengthening cross-border and trans-boundary cooperation for mutually beneficial solutions and sub-regional integration is a critical component of stabilising the region for long term recovery and resilience of the populations. This is also reflected as a core objective under Strategic Objective 21 (Improving Cross-Border Cooperation) of Pillar 5, Governance, and the Social Contract of the RS-SRR.",
                            tags$br(),
                            "To complement existing efforts and to increase cooperation, several consultations culminated in the Cross-Border Intervention Workshop in April 2021 bringing together stakeholders from the affected territories to deepen discussions regarding cross-border cooperation and border community needs. From this workshop a series of interventions were proposed, discussed, and selected to be presented in this presentation.",
                            tags$br(),tags$br(),
                            tags$h5("More Informatiohn on the Regional Strategy for the Stabilization, Recovery and Resilience"),
                            "To ensure stabilization of the Lake Chad Basin region, on 30 August 2018, the Council of Ministers of the Lake Chad Basin Commission (LCBC) adopted the Regional Strategy for the Stabilization, Recovery and Resilience (RS-SRR) of the Boko Haram-affected areas of the Lake Basin Region. The RS-SRR was endorsed by the Peace and Security Council (PSC) of the African Union. The strategy elaborates an overarching regional approach in dealing with the deep-rooted causes of under-development and the drivers of violent extremism and conflicts in the Lake Chad region. It is being implemented in eight targeted areas of the four Member States. These are:",
                            tags$br(),"Nigeria:  Borno, Yobe and Adamawa states",
                            tags$br(),"Niger: Diffa Region",
                            tags$br(),"Chad: Region du Lac and Hadjer-Lamis Region; and",
                            tags$br(),"Cameroon: The Far North and North Region ",
                            
                            tags$br(),tags$br(),tags$h4("Methodology"),
                            tags$h5("Population Estimates"),
                            "Population estimates for each intervention were calculated based on the 2020 WorldPop Gridded Population Estimates. Population was calculated at the administrative 3* level where possible; population counts in administrative areas within a 10km radius of the intervention were added together to estimate total affected population.",
                            tags$br(),
                            "*For the affected territories in Chad administrative 2 boundaries were used in lieu of unrecognized administrative 3 boundaries.",
                            tags$br(),tags$h5("Infrastructure Presence"),
                            "Health, education, and security posts were deemed 'present' if locations existed within a 20km range of the intervention site.", 
#                            tags$a(href="https://experience.arcgis.com/experience/685d0ace521648f8a5beeeee1b9125cd", "the WHO,"),
                            tags$br(),tags$br(),tags$h4("Code"),
                            "Code and input data used to generate this Shiny mapping tool are available on ",tags$a(href="https://github.com/jstandifer/rs-srr-webmap", "Github."),
                            tags$br(),tags$br(),tags$h4("Sources & References"),
                            tags$a(href="https://data.humdata.org/", "Humanitarian Data Exchange: "), "Provided necessary administrative boundaries, WorldPop population estimates, as well as infrastructure data including, market, education, and health facility datasets.",
                            tags$br(),tags$a(href="https://grid3.gov.ng/", "GRID3: "), "Provided market datasets for Nigerian territories.",
                            tags$br(),tags$a(href="https://mnjtffmm.org/", "MNJTF: "), "Provided MNJTF sector coverage zones.",
                            tags$br(),tags$a(href="https://www.undp.org/", "UNDP: "), "JAP locations (as of February 2022) were provided by the UNDP Dakar hub.",
                            tags$br(),tags$br(),tags$h4("Authors"),
                            "Participants of the cross-border workshop included representatives from: the Executive Secretary of the Lake Chad Basin Commission; the African Union; Governor’s Offices from the affected territories; MNJTF in the affected territories; CCL; UNDP; IOM; and the RS-SRR Secretariat.",
                            tags$br(),tags$br(),
                            "Technical Support: Jessie Standifer, GIS Consultant, UNDP",tags$br(),
                            tags$br(),tags$h4("Contact"),
                            tags$h5("Chika Charles, Head of Stabilization RS-SRR Secretariat, UNDP Sub-Regional Hub for West and Central Africa"),
                            "ChikaCharles.Aniekwe@undp.org",tags$br(),tags$br(),
                            tags$img(src = "lcbc.png", width = "120px", height = "120px"),
                            tags$img(src = "au.jpg", width = "200px", height = "130px"),
                            tags$img(src = "cameroon.png", width = "100px", height = "100px"),
                            tags$img(src = "blank.png", width = "50px", height = "120px"),
                            tags$img(src = "chad.png", width = "100px", height = "100px"),
                            tags$img(src = "blank.png", width = "50px", height = "120px"),
                            tags$img(src = "niger.png", width = "120px", height = "100px"),
                            tags$img(src = "blank.png", width = "50px", height = "120px"),
                            tags$img(src = "nigeria.png", width = "110px", height = "100px"),
                            tags$img(src = "blank.png", width = "50px", height = "100px"),
                            tags$img(src = "undp.png", width = "55px", height = "100px")
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
            addProviderTiles(providers$CartoDB.PositronNoLabels)%>%
            addPolylines(data=line, weight=2.5, color = "black",
                         group = "Road and dredging network (proposed)")%>%
            addPolylines(data=road, weight=2.2, color = "white",
                         dashArray = "5, 5",
                         label = road_tooltip,
                         highlightOptions = highlightOptions(color = "red", weight = 3,
                                                             bringToFront = TRUE),
                        group = "Road and dredging network (proposed)")%>%
            addPolylines(data=dredging, weight=2.2, color = "#00BFFF",
                         dashArray = "5, 5",
                        label = dredging_tooltip,
                        highlightOptions = highlightOptions(color = "red", weight = 3,
                                                            bringToFront = TRUE),
                         group = "Road and dredging network (proposed)")%>%
            addMarkers(data=dryport,
                       icon = dryporticon,
                       label = dryport_tooltip,
                       group="Dryport (proposed)")%>%
            addMarkers(data=bridge,
                       icon = bridgeicon,
                       label = bridge_tooltip,
                       group="Bridge (proposed)")%>%
            addMarkers(data=cattle,
                       icon = cattleicon,
                       label = cattle_tooltip,
                       group="Cattle market (proposed)")%>%
            addMarkers(data=dock,
                       icon = dockicon,
                       label = dock_tooltip,
                       group="Dock (proposed)")%>%
            addMarkers(data=health,
                       icon = healthicon,
                       label =  health_tooltip,
                       group="Health facility (proposed)")%>%
            addMarkers(data=market,
                       icon = marketicon,
                       label = market_tooltip,
                       group="Market (proposed)")%>%
            addMarkers(data=land,
                       icon = landicon,
                       label = land_tooltip,
                       group="Irrigated land (proposed)")%>%
            addMarkers(data=security,
                       icon = securityicon,
                       label = security_tooltip,
                       group="Security post (proposed)")%>%
            addMarkers(data=truck,
                       icon = truckicon,
                       label = truck_tooltip,
                       group="Truck park (proposed)")%>%
            addPolygons(data=territory, weight = 2, fillColor = '#D3D3D3', color = 'grey',group = "Cross-border territory",
                        label = territory_tooltip,
                        highlightOptions = highlightOptions(fillColor="white",
                                                            fillOpacity = 0.5,
                                                            color="grey",
                                                            weight = 1.4,
                                                            bringToFront = F))%>%
            addSearchOSM()%>%
            addResetMapButton()%>%
            setView(lng = 13.615693, lat=12.001274, zoom = 6
                    )%>%
            addMiniMap(
                tiles = providers$Esri.WorldGrayCanvas,
                toggleDisplay = TRUE)%>%
            addLayersControl(overlayGroups = c("Cross-border territory","Bridge (proposed)","Cattle market (proposed)","Dock (proposed)",
                                               "Dryport (proposed)","Health facility (proposed)","Irrigated land (proposed)",
                                               "Market (proposed)","Road and dredging network (proposed)", 
                                               "Security post (proposed)","Truck park (proposed)"),
                             options = layersControlOptions(collapsed = F))%>%
 #           addLegend(#legend for the line file#
 #              color = "black",
#                labels = "Road Construction",
  #              title = "Proposed Network Intervention",
 #               opacity = 1, 
 #               position = "topright",
 #               group =  "Proposed road and dredging network"
#            )%>%
#            addControl(html = html_legend, position = "topright", layerId = "A" )%>%
        addPolylines(data=territory, weight = 1, color = '#D3D3D3')%>%
        addLabelOnlyMarkers(data = territory,
                            lng = ~xcoord_sum, 
                            lat = ~ycoord_sum, 
                            label = ~name_upper,
                            labelOptions = labelOptions(noHide = T,
                                  direction = 'center',
                                  textOnly = T,
                                  style = list(
 #                                   "color" = "58585A",
                                    "color" = "#FFF",
                                    "font-weight"= "bold",
                                   "padding" = "3px 8px",
                                    "font-family" = "Helvetica Neue",
                                    "text-shadow"="2px 2px 5px #58585A"
                                  )))%>%
            hideGroup("Bridge (proposed)")%>%
        hideGroup("Cattle market (proposed)")%>%
        hideGroup("Dock (proposed)")%>%
        hideGroup("Dryport (proposed)")%>%
        hideGroup("Health facility (proposed)")%>%
        hideGroup("Irrigated land (proposed)")%>%
        hideGroup("Market (proposed)")%>%
        hideGroup("Security post (proposed)")%>%
        hideGroup("Truck park (proposed)")%>%
        hideGroup("Road and dredging network (proposed)")

      
    })
    
}

shinyApp(ui, server)
