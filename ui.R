#load all libraries
library(methods)
library(base)
library(stats)
library(datasets)

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

fluidPage(
  
  div(h1("VISUALISASI DATA PELABUHAN GRESIK", style="font-weight: bold"), style="text-align: center;"),
  div(h4("Dibuat oleh : Akhmad Fadil Mubarok (221810129)"), style="text-align: center; font-weight: bold;"),
  hr(),
  
  fluidRow(
    column(6,
       h2("Pelabuhan Gresik", style="font-weight: bold;"),
       br(),
       div("Pelabuhan Gresik merupakan pe labuhan berukuran menengah yang terletak di Kabupaten Gresik, Jawa Timur, Indonesia. Lebih tepatnya lokasi Pelabuhan Gresik berada pada selat madura atau sebelah utara Pelabuhan Tanjung Perak Surabaya. Pelabuhan Gresik memiliki UN/Locode resmi, yakni IDGRE. Jenis kapal yang biasa singgah di Pelabuhan Gresik berjenis Cargo (20%), Oil/Chemical Tanker (16%), General Cargo (15%), Bulk Carrier (11%), Oil Products Tanker (8%). Panjang maksimum kapal yang tercatat memasuki pelabuhan ini adalah 230 meter, draught maksimum adalah 13 meter, serta bobot mati maksimum adalah 82214 ton.", style="text-align: justify; font-size: 1.3em;"),
    ),
    column(6,
       div(img(src='https://photos.marinetraffic.com/ais/showphoto.aspx?photoid=2127435', style="width: 100%; border-radius: 1em;"), style="text-align: center;")
    )
  ),
  br(),
  hr(),
  
  h3("Pilih rentang waktu data", style="font-weight: bold;"),
  div("Rentang waktu diperlukan untuk memilih periode data yang akan ditampilkan.", style="text-align: justify; font-size: 1em; color:#3e403f;"),
  br(),
  dateInput("dateFrom", "From:", value = "2021-12-08", min = "2021-12-08", max = "2021-12-19", format = "yyyy-mm-dd"),
  dateInput("dateTo", "To:", value = "2021-12-19", min = "2021-12-08", max = "2021-12-19", format = "yyyy-mm-dd"),
  br(),
  hr(),
  
  h3("Tabel data lengkap", style="font-weight: bold;"),
  div(dataTableOutput('myTable'), style="background-color: white; padding: 0.5em; border-radius: 1em;"),
  
  hr(),
  
  h3("Visualisasi Data", style="font-weight: bold;"),
  
  fluidRow(
    column(6,
      div(h4("Jumlah kapal per hari", style="font-weight: bold;"), style="text-align: center;"),
      div(plotOutput("per_day"), style="text-align: center;"),
    ),
    column(6,
      div(h4("Jumlah kapal berdasarkan status per hari", style="font-weight: bold;"), style="text-align: center;"),
      div(plotOutput("status"), style="text-align: center;"),
    )
  ),
  
  br(),
  
  fluidRow(
    column(6,
       div(h4("Jumlah kapal berdasarkan jenis kapal", style="font-weight: bold;"), style="text-align: center;"),
       div(plotOutput("jenis_kapal"), style="text-align: center;"),
    ),
    column(6,
       div(h4("Jumlah kapal berdasarkan asal negara", style="font-weight: bold;"), style="text-align: center;"),
       div(plotOutput("asal_flag"), style="text-align: center;"),
    )
  ),
  
  br(),
  hr(),
  
  h3("Bar Chart Race", style="font-weight: bold;"),
  div(p("Klik salah satu untuk melakukan render bar chart animation."), style="color:#3e403f;"),
  div(span(actionButton("race", "Jumlah Kapal Berdasarkan Jenis Kapal")), span(actionButton("flag", "Jumlah Kapal Berdasarkan Asal Negara"))),
  
  hr(),
  div(div(imageOutput("bar_race"),imageOutput("flag_race"), style="text-align: center;"), style="height: 720px;"),
  
  add_busy_spinner(spin = "fading-circle"),
  br(),
  hr(),
  style="background-color: #0494c7;"
)