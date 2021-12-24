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
url <- "https://www.marinetraffic.com/en/data/?asset_type=expected_arrivals&columns=fleet,shipname,recognized_next_port,reported_eta,arrived,show_on_live_map,dwt,ship_type,flag,imo,eni,mmsi,photo,current_port,area_global,area,reported_destination,draught,current_port_unlocode,navigational_status,year_of_build,length,width,callsign,current_port_country&recognized_next_port_in|begins|GRESIK|recognized_next_port_in=2454&arrival_time_gte|gte|arrival_time_gte=43200,43200"
driver$navigate(url)

# Sesuaikan dengan variabel yang akan anda kumpulkan
vessel_name <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(2) > div")
destination_port <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(3) > div")
my_fleets <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(1) > div")
reported_eta <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(4) > div")
arrived_at <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(5) > div > div")
capacity_dwt <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(7) > div")
vessel_type_generic <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(8) > div > div > img")
flag <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(9) > div > div > div")
imo <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(10) > div > div")
eni <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(11) > div")
mmsi <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(12) > div > div")
current_port <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(14) > div")
global_area <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(15) > div")
local_area <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(16) > div")
reported_destination <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(17) > div")
draught <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(18) > div")
current_port_unlocode <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(19) > div > div")
navigational_status <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(20) > div > div")
build <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(21) > div > div")
length <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(22) > div > div")
width <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(23) > div > div")
callsign <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(24) > div > div")
current_port_country <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(25) > div > div")

vessel_name <- unlist(lapply(vessel_name, function(x) x$getElementText()))
destination_port <- unlist(lapply(destination_port, function(x) x$getElementText()))
my_fleets <- unlist(lapply(my_fleets, function(x) x$getElementText()))
reported_eta <- unlist(lapply(reported_eta, function(x) x$getElementText()))
arrived_at <- unlist(lapply(arrived_at, function(x) x$getElementText()))
capacity_dwt <- unlist(lapply(capacity_dwt, function(x) x$getElementText()))
vessel_type_generic <- unlist(lapply(vessel_type_generic, function(x) x$getElementAttribute("title")))
flag <- unlist(lapply(flag, function(x) x$getElementAttribute("title")))
imo <- unlist(lapply(imo, function(x) x$getElementText()))
eni <- unlist(lapply(eni, function(x) x$getElementText()))
mmsi <- unlist(lapply(mmsi, function(x) x$getElementText()))
current_port <- unlist(lapply(current_port, function(x) x$getElementText()))
global_area <- unlist(lapply(global_area, function(x) x$getElementText()))
local_area <- unlist(lapply(local_area, function(x) x$getElementText()))
reported_destination <- unlist(lapply(reported_destination, function(x) x$getElementText()))
draught <- unlist(lapply(draught, function(x) x$getElementText()))
current_port_unlocode <- unlist(lapply(current_port_unlocode, function(x) x$getElementText()))
navigational_status <- unlist(lapply(navigational_status, function(x) x$getElementText()))
build <- unlist(lapply(build, function(x) x$getElementText()))
length <- unlist(lapply(length, function(x) x$getElementText()))
width <- unlist(lapply(width, function(x) x$getElementText()))
callsign <- unlist(lapply(callsign, function(x) x$getElementText()))
current_port_country <- unlist(lapply(current_port_country, function(x) x$getElementText()))

# Membuat tabel untuk diekspor ke dalambentuk excel
table <- cbind(vessel_name, destination_port, my_fleets, reported_eta, arrived_at, capacity_dwt, vessel_type_generic, flag, imo, eni, mmsi, current_port, global_area, local_area, reported_destination, draught, current_port_unlocode, navigational_status, build, length, width, callsign, current_port_country)
table <- as.data.frame(table)
view(table)

# Ekspor data ke dalam bentuk excel
write_xlsx(table, "E:\\Expected Arrivals.xlsx")

# Mematikan rselenium (browser otomatis)
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)