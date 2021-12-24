#load all libraries
library(methods)
library(base)
library(stats)
library(datasets)
library(readxl)

library(shiny)
library(ggplot2)
library(readr)
library(dplyr)
library(broom)
library(gganimate)
library(transformr)
library(gifski)
library(shinybusy)
library(DT)

#load full data untuk ditampilkan dalam bentuk tabel
myfile <- "https://raw.githubusercontent.com/Xeryus01/data/main/full.csv"
full <- read_csv(myfile)
full$`Ata/atd` <- as.Date(full$`Ata/atd`, "%Y-%m-%d")

#load data jumlah kapal harian
myfile <- "https://raw.githubusercontent.com/Xeryus01/data/main/jumlah_kapal.csv"
per_day <- read_csv(myfile)
per_day$time <- as.Date(per_day$time, "%Y-%m-%d")

#load data kapal berdasarkan status perjalanan
myfile <- "https://raw.githubusercontent.com/Xeryus01/data/main/status_kapal.csv"
status <- read_csv(myfile)
status$date <- as.Date(status$date, "%Y-%m-%d")

#load data kapal berdasarkan jenis kapal
myfile <- "https://raw.githubusercontent.com/Xeryus01/data/main/jenis_kapal.csv"
data_jenis_kapal <- read_csv(myfile)
data_jenis_kapal$time <- as.Date(data_jenis_kapal$date, "%Y-%m-%d")
data_jenis_kapal$betterTime <- format(as.Date(data_jenis_kapal$time), '%d %B %Y')

#load data kapal berdasarkan asal negara kapal
myfile <- "https://raw.githubusercontent.com/Xeryus01/data/main/negara_kapal.csv"
data_asal_kapal <- read_csv(myfile)
data_asal_kapal$time <- as.Date(data_asal_kapal$date, "%Y-%m-%d")
data_asal_kapal$betterTime <- format(as.Date(data_asal_kapal$time), '%d %B %Y')

#all server function
function(input, output){
  
  #render grafik dinamis jenis kapal (bar chart race)
  observeEvent(input$race, {
    output$bar_race <- renderImage({
      show_modal_spinner()
      
      outfile <- tempfile(fileext='.gif')
      data <- data_jenis_kapal %>%
        filter(time >= input$dateFrom & time <= input$dateTo)
      
      for (i in 1:10) {
        data$cumulative[i] = data$value[i]
      }
      
      for (i in 11:NROW(data$value)) {
        data$cumulative[i] = data$value[i] + data$cumulative[i-10]
      }
      
      gdp_formatted <- data %>%
        group_by(betterTime) %>%
        mutate(rank = rank(-cumulative),
               Value_rel = cumulative/cumulative[rank==1],
               Value_lbl = paste0(" ",cumulative)
        ) %>%
        group_by(vessel_type) %>% 
        filter(rank <= 4) %>%
        ungroup()
      
      anim <- ggplot(gdp_formatted, aes(rank, group = vessel_type, 
                                        fill = as.factor(vessel_type), color = as.factor(vessel_type))) +
        geom_tile(aes(y = cumulative/2,
                      height = cumulative,
                      width = 0.9), alpha = 0.8, color = NA) +
        geom_text(aes(y = 0, label = paste(vessel_type, " ")), vjust = 0.2, hjust = 1) +
        geom_text(aes(y=cumulative,label = Value_lbl, hjust=0)) +
        coord_flip(clip = "off", expand = FALSE) +
        scale_y_continuous(labels = scales::comma) +
        scale_x_reverse() +
        guides(color = FALSE, fill = FALSE) +
        theme(axis.line=element_blank(),
              axis.text.x=element_blank(),
              axis.text.y=element_blank(),
              axis.ticks=element_blank(),
              axis.title.x=element_blank(),
              axis.title.y=element_blank(),
              legend.position="none",
              panel.background=element_blank(),
              panel.border=element_blank(),
              panel.grid.major=element_blank(),
              panel.grid.minor=element_blank(),
              panel.grid.major.x = element_line( size=.1, color="grey" ),
              panel.grid.minor.x = element_line( size=.1, color="grey" ),
              plot.title=element_text(size=25, hjust=0.5, face="bold", colour="grey", vjust=-1),
              plot.subtitle=element_text(size=18, hjust=0.5, face="italic", color="grey"),
              plot.caption =element_text(size=8, hjust=0.5, face="italic", color="grey"),
              plot.background=element_blank(),
              plot.margin = margin(2,2, 2, 4, "cm")) +
        transition_states(gdp_formatted$time, transition_length = 4, state_length = 1, wrap = FALSE) +
        view_follow(fixed_x = TRUE) +
        labs(title = 'Jumlah Kapal Berdasarkan Jenis Kapal : {format(as.Date(closest_state), "%d %B %Y")}',  
             subtitle  = "{format(as.Date(input$dateFrom), '%d %B %Y')} sampai {format(as.Date(input$dateTo), '%d %B %Y')}",
             caption  = "Data Source: https://www.marinetraffic.com/") 
      
      anim_save("outfile.gif", animate(anim, 200, fps = 15,  width = 1200, height = 1000, 
                                       renderer = gifski_renderer(), end_pause = 15, start_pause =  15))
      
      remove_modal_spinner()
      
      return(list(src = "outfile.gif",
                  contentType = 'image/gif',
                  height = 720, 
                  width = 1080,
                  alt = "This is alternate text"
      ))
    }, deleteFile = TRUE)
  })
  
  #render grafik dinamis asal negara kapal (bar chart race)
  observeEvent(input$flag, {
    output$bar_race <- renderImage({
      show_modal_spinner()
      
      outfile <- tempfile(fileext='.gif')
      data <- data_asal_kapal %>%
        filter(time >= input$dateFrom & time <= input$dateTo)
      
      for (i in 1:11) {
        data$cumulative[i] = data$value[i]
      }
      
      for (i in 12:NROW(data$value)) {
        data$cumulative[i] = data$value[i] + data$cumulative[i-11]
      }
      
      gdp_formatted <- data %>%
        group_by(betterTime) %>%
        mutate(rank = rank(-cumulative),
               Value_rel = cumulative/cumulative[rank==1],
               Value_lbl = paste0(" ",cumulative)
        ) %>%
        group_by(flag) %>% 
        filter(rank <= 3) %>%
        ungroup()
      
      anim <- ggplot(gdp_formatted, aes(rank, group = flag, 
                                        fill = as.factor(flag), color = as.factor(flag))) +
        geom_tile(aes(y = cumulative/2,
                      height = cumulative,
                      width = 0.9), alpha = 0.8, color = NA) +
        geom_text(aes(y = 0, label = paste(flag, " ")), vjust = 0.2, hjust = 1) +
        geom_text(aes(y=cumulative,label = Value_lbl, hjust=0)) +
        coord_flip(clip = "off", expand = FALSE) +
        scale_y_continuous(labels = scales::comma) +
        scale_x_reverse() +
        guides(color = FALSE, fill = FALSE) +
        theme(axis.line=element_blank(),
              axis.text.x=element_blank(),
              axis.text.y=element_blank(),
              axis.ticks=element_blank(),
              axis.title.x=element_blank(),
              axis.title.y=element_blank(),
              legend.position="none",
              panel.background=element_blank(),
              panel.border=element_blank(),
              panel.grid.major=element_blank(),
              panel.grid.minor=element_blank(),
              panel.grid.major.x = element_line( size=.1, color="grey" ),
              panel.grid.minor.x = element_line( size=.1, color="grey" ),
              plot.title=element_text(size=25, hjust=0.5, face="bold", colour="grey", vjust=-1),
              plot.subtitle=element_text(size=18, hjust=0.5, face="italic", color="grey"),
              plot.caption =element_text(size=8, hjust=0.5, face="italic", color="grey"),
              plot.background=element_blank(),
              plot.margin = margin(2,2, 2, 4, "cm")) +
        transition_states(gdp_formatted$time, transition_length = 4, state_length = 1, wrap = FALSE) +
        view_follow(fixed_x = TRUE) +
        labs(title = 'Jumlah Kapal Berdasarkan Asal Negara : {format(as.Date(closest_state), "%d %B %Y")}',  
             subtitle  = "{format(as.Date(input$dateFrom), '%d %B %Y')} sampai {format(as.Date(input$dateTo), '%d %B %Y')}",
             caption  = "Data Source: https://www.marinetraffic.com/") 
      
      anim_save("outfile.gif", animate(anim, 200, fps = 15,  width = 1200, height = 1000, 
                                       renderer = gifski_renderer(), end_pause = 15, start_pause =  15))
      
      remove_modal_spinner()
      
      return(list(src = "outfile.gif",
                  contentType = 'image/gif',
                  height = 720, 
                  width = 1080,
                  alt = "This is alternate text"
      ))
    }, deleteFile = TRUE)
  })
  
  #render plot data jumlah kapal harian
  output$per_day <- renderPlot({
    label <- paste('Periode', 
                   format(as.Date(input$dateFrom), "%d %B %Y"),
                   'sampai',
                   format(as.Date(input$dateTo), "%d %B %Y"))
    
    per_day %>%
      filter(time >= input$dateFrom & time <= input$dateTo) %>%
      ggplot(aes(x = time, y = value)) +
      geom_line(aes(y = value, color = "Nilai Impor"), size = 1.2) +
      labs(title = label,
           x = "Tanggal",
           y = "Jumlah kapal",
           color = "Keterangan") 
  })
  
  #render plot data jumlah kapal berdasarkan status per hari
  output$status <- renderPlot({
    label <- paste('Periode', 
                   format(as.Date(input$dateFrom), "%d %B %Y"),
                   'sampai',
                   format(as.Date(input$dateTo), "%d %B %Y"))
    
    status %>% 
      filter(date >= input$dateFrom & date <= input$dateTo) %>%
      ggplot(aes(x=date, y=value, fill=status)) + 
      geom_bar(position = 'dodge', stat='identity') +
      geom_text(aes(label=value), position=position_dodge(width=1), vjust=-0.25) +
      labs(title = label,
           x = "Tanggal",
           y = "Jumlah kapal",
           color = "Status perjalanan") 
  })
  
  #render plot data jumlah kapal berdasarkan jenis kapal
  output$jenis_kapal <- renderPlot({
    label <- paste('Periode', 
                   format(as.Date(input$dateFrom), "%d %B %Y"),
                   'sampai',
                   format(as.Date(input$dateTo), "%d %B %Y"))
    
    temp <- data_jenis_kapal %>%
      filter(date >= input$dateFrom & date <= input$dateTo)
    
    for (i in 1:10) {
      temp$cumulative[i] = temp$value[i]
    }
    
    for (i in 11:NROW(temp$value)) {
      temp$cumulative[i] = temp$value[i] + temp$cumulative[i-10]
    }
    
    temp <- tail(temp, 10)
    
    temp %>% 
      ggplot(aes(x=vessel_type, y=cumulative, fill=vessel_type)) + 
      geom_bar(stat='identity') +
      geom_text(aes(label=cumulative), position=position_dodge(width=1), vjust=-0.25) +
      labs(title = label,
           x = "Jenis kapal",
           y = "Jumlah kapal",
           color = "Status perjalanan") 
  })
  
  #render plot data jumlah kapal berdasarkan asal negara kapal
  output$asal_flag <- renderPlot({
    label <- paste('Periode', 
                   format(as.Date(input$dateFrom), "%d %B %Y"),
                   'sampai',
                   format(as.Date(input$dateTo), "%d %B %Y"))
    
    temp <- data_asal_kapal %>%
      filter(date >= input$dateFrom & date <= input$dateTo)
    
    for (i in 1:10) {
      temp$cumulative[i] = temp$value[i]
    }
    
    for (i in 11:NROW(temp$value)) {
      temp$cumulative[i] = temp$value[i] + temp$cumulative[i-10]
    }
    
    temp <- tail(temp, 10)
    
    temp %>% 
      ggplot(aes(x=flag, y=cumulative, fill=flag)) + 
      geom_bar(stat='identity') +
      geom_text(aes(label=cumulative), position=position_dodge(width=1), vjust=-0.25) +
      labs(title = label,
           x = "Jenis kapal",
           y = "Jumlah kapal",
           color = "Status perjalanan") 
  })
  
  #menampilkan data lengkap yang digunakan dalam bentuk tabel
  output$myTable <- renderDataTable(
    full %>%
      filter(`Ata/atd` >= input$dateFrom & `Ata/atd` <= input$dateTo),
    options = list(pageLength = 10, info = FALSE)
  )
  
}
