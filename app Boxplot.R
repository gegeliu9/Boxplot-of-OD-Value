rm(list=ls())
library(shiny)
library(survminer)
library(survival)
library(readxl)
library(plyr)
library(readxl)
library(drc)
library(dr4pl)
library(reshape2)
library(stringr)

ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      tags$h4("Title: Boxplot"),
      tags$hr(),
      fileInput("file1", "Choose CSV File :",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
      ),
      checkboxInput("header", "Header", TRUE),
      tags$hr(),
      
      submitButton("Submit", icon("refresh"))
      
    ),
    
    mainPanel(
      uiOutput('outSelections'),
      tags$hr(),
      plotOutput('boxPlot'),
      downloadButton('download1', 'Download', class = "buttCol"),
      tags$hr(),
      
    tabPanel("Dataset",tableOutput("contents"))
    )))
    
  

server <- function(input, output) {
  output$contents <- renderTable({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    data=data.frame(read.csv(inFile$datapath, header = input$header))
    colnames(data)[1] <- "concentration"
    data2 <- as.data.frame(lapply(data, as.character))
    data2
  })
  
  output$boxPlot <- renderPlot({
    inFile <- input$file1
    data=data.frame(read.csv(inFile$datapath, header = input$header))
    colnames(data)[1] <- "concen"
    data <- melt(data,id.vars ="concen",value.name = "od" )
    boxplot(data$od,main='Boxplot of OD Value',ylab='OD')
  })
  

}

# Run the app ----
shinyApp(ui = ui, server = server)










