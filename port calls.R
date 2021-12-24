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
url <- "https://www.marinetraffic.com/en/data/?asset_type=arrivals_departures&columns=shipname,move_type,port_type,port_name,ata_atd,origin_port_name,leg_start_port,intransit,mmsi,imo,origin_port_atd,ship_type,dwt,fleet&port_in|begins|GRESIK|port_in=2454"
driver$navigate(url)

# Sesuaikan dengan variabel yang akan anda kumpulkan
vessel_name <- driver$findElements("css", "div.ag-body > div.ag-pinned-left-cols-viewport > div > div > div.ag-cell.ag-cell-not-inline-editing.ag-cell-no-focus.ag-cell-last-left-pinned.mt-grid-cell-orientation.ag-cell-value > div")
port_call_type <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(1) > div")
port_type <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(2) > div > div > div")
port_at_call <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(3) > div > div")
ata_atd <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(4) > div > div")
voyage_origin_port <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(5) > div > div")
leg_start_port_anch <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(6) > div > div")
in_transit_port_calls <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(7) > div > div > div")
mmsi <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(8) > div > div > div")
imo <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(9) > div > div > div")
voyage_origin_port_atd <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(10) > div > div")
vessel_type_generic <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(11) > div > div > img")
capacity_dwt <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div> div:nth-child(12) > div > div")
my_fleets <- driver$findElements("css", "div.ag-body > div.ag-body-viewport-wrapper > div > div > div > div:nth-child(13) > div > div > div")

vessel_name <- unlist(lapply(vessel_name, function(x) x$getElementText()))
port_call_type <- unlist(lapply(port_call_type, function(x) x$getElementText()))
port_type <- unlist(lapply(port_type, function(x) x$getElementText()))
port_at_call <- unlist(lapply(port_at_call, function(x) x$getElementText()))
ata_atd <- unlist(lapply(ata_atd, function(x) x$getElementText()))
voyage_origin_port <- unlist(lapply(voyage_origin_port, function(x) x$getElementText()))
leg_start_port_anch <- unlist(lapply(leg_start_port_anch, function(x) x$getElementText()))
in_transit_port_calls <- unlist(lapply(in_transit_port_calls, function(x) x$getElementText()))
mmsi <- unlist(lapply(mmsi, function(x) x$getElementText()))
imo <- unlist(lapply(imo, function(x) x$getElementText()))
voyage_origin_port_atd <- unlist(lapply(voyage_origin_port_atd, function(x) x$getElementText()))
vessel_type_generic <- unlist(lapply(vessel_type_generic, function(x) x$getElementAttribute("title")))
capacity_dwt <- unlist(lapply(capacity_dwt, function(x) x$getElementText()))
my_fleets <- unlist(lapply(my_fleets, function(x) x$getElementText()))

# Membuat tabel untuk diekspor ke dalambentuk excel
table <- cbind(vessel_name, port_call_type, port_type, port_at_call, ata_atd, voyage_origin_port, leg_start_port_anch, in_transit_port_calls, mmsi, imo, voyage_origin_port_atd, vessel_type_generic, capacity_dwt, my_fleets)
table <- as.data.frame(table)
view(table)

# Ekspor data ke dalam bentuk excel
write_xlsx(table, "E:\\Port Calls.xlsx")

# Mematikan rselenium (browser otomatis)
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)

