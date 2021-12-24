# Import libraries
library("RSelenium")
library("tidyverse")
library("writexl")
library("dplyr")

# Bahasa yang akan digunakan oleh sistem
Sys.setenv("LANG" = "en")

# Sesuaikan dengan browser dan versi dari browser yang anda pakai
client_server <- RSelenium::rsDriver(browser=c("chrome"), 
                                     chromever="96.0.4664.45", 
                                     port=4545L, 
                                     verbose=F)

# Memulai rselenium (browser otomatis) untuk mengumpulkan data
driver <- client_server[["client"]]

# Menuju laman yang akan dilakukan scraping
url <- "https://www.marinetraffic.com/en/data/?asset_type=vessels&columns=reported_eta:desc,flag,shipname,photo,recognized_next_port,reported_destination,current_port,imo,mmsi,ship_type,show_on_live_map,time_of_latest_position,area,area_local,lat_of_latest_position,lon_of_latest_position,fleet,status,eni,speed,course,draught,navigational_status,year_of_build,length,width,dwt,current_port_unlocode,current_port_country,callsign,notes&current_port_in|begins|GRESIK|current_port_in=2454&time_of_latest_position_between|gte|time_of_latest_position_between=525600,525600"
driver$navigate(url)

# Sesuaikan dengan variabel yang akan anda kumpulkan
flag <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(1) > div > div > div")
vessel_name <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(2) > div")
destination_port <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(4) > div")
reported_eta <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(5) > div > div")
reported_destination <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(6) > div > div")
current_port <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(7) > div > div")
imo <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(8) > div")
mmsi <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(9) > div > div")
vessel_type_generic <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(10) > div > div > img")
time_of_latest_position <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(12) > div > div")
global_area <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(13) > div > div")
local_area <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(14) > div > div")
latitude <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(15) > div > div")
longitude <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(16) > div > div")
my_fleets <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(17) > div")
status <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(18) > div > div")
eni <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(19) > div")
speed <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(20) > div > div")
course <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(21) > div > div")
draught <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(22) > div > div")
navigational_status <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(23) > div > div")
built <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(24) > div > div")
length <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(25) > div > div")
width <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(26) > div > div")
capacity_dwt <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div> div:nth-child(27) > div > div")
current_port_unlocode <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(28) > div > div")
current_port_country <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(29) > div > div")
callsign <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(30) > div > div")

flag <- unlist(lapply(flag, function(x) x$getElementAttribute("title")))
vessel_name <- unlist(lapply(vessel_name, function(x) x$getElementText()))
destination_port <- unlist(lapply(destination_port, function(x) x$getElementText()))
reported_eta <- unlist(lapply(reported_eta, function(x) x$getElementText()))
reported_destination <- unlist(lapply(reported_destination, function(x) x$getElementText()))
current_port <- unlist(lapply(current_port, function(x) x$getElementText()))
imo <- unlist(lapply(imo, function(x) x$getElementText()))
mmsi <- unlist(lapply(mmsi, function(x) x$getElementText()))
vessel_type_generic <- unlist(lapply(vessel_type_generic, function(x) x$getElementAttribute("title")))
time_of_latest_position <- unlist(lapply(time_of_latest_position, function(x) x$getElementText()))
global_area <- unlist(lapply(global_area, function(x) x$getElementText()))
local_area <- unlist(lapply(local_area, function(x) x$getElementText()))
latitude <- unlist(lapply(latitude, function(x) x$getElementText()))
longitude <- unlist(lapply(longitude, function(x) x$getElementText()))
my_fleets <- unlist(lapply(my_fleets, function(x) x$getElementText()))
status <- unlist(lapply(status, function(x) x$getElementText()))
eni <- unlist(lapply(eni, function(x) x$getElementText()))
speed <- unlist(lapply(speed, function(x) x$getElementText()))
course <- unlist(lapply(course, function(x) x$getElementText()))
draught <- unlist(lapply(draught, function(x) x$getElementText()))
navigational_status <- unlist(lapply(navigational_status, function(x) x$getElementText()))
built <- unlist(lapply(built, function(x) x$getElementText()))
length <- unlist(lapply(length, function(x) x$getElementText()))
width <- unlist(lapply(width, function(x) x$getElementText()))
capacity_dwt <- unlist(lapply(capacity_dwt, function(x) x$getElementText()))
current_port_unlocode <- unlist(lapply(current_port_unlocode, function(x) x$getElementText()))
current_port_country <- unlist(lapply(current_port_country, function(x) x$getElementText()))
callsign <- unlist(lapply(callsign, function(x) x$getElementText()))

# Membuat tabel untuk diekspor ke dalambentuk excel
table <- cbind(flag, vessel_name, destination_port, reported_eta, reported_destination, current_port, imo, mmsi, vessel_type_generic, time_of_latest_position, global_area, local_area, latitude, longitude, my_fleets, status, eni, speed, course, draught, navigational_status, built, length, width, capacity_dwt, current_port_unlocode, current_port_country, callsign)
table <- as.data.frame(table)
view(table)

# Ekspor data ke dalam bentuk excel
write_xlsx(table, "E:\\Vessel Database.xlsx")

# Mematikan rselenium (browser otomatis)
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)

