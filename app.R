library(here)


setwd("C:/Users/cwale/OneDrive/Documents/WindApp")

source('global.R')

source('ui.R')
source('server.R')


shinyApp(ui = ui, server = server)



