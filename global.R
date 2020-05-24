library(rsconnect)
library(shiny)
library(tswge)
library(plotly)
library(shinydashboard)
library(DT)
library(shinycssloaders)

#*******************************************************************
# Import Data
#*******************************************************************
wind_nj <- list()
wind_nj[[1]] <- data.table::fread("data/nj/nj_all_1min.csv", colClasses = c(file_date = "Date"))
wind_nj[[2]] <- data.table::fread("data/nj/nj_all_5min.csv", colClasses = c(file_date = "Date"))
wind_nj[[3]] <- data.table::fread("data/nj/nj_all_10min.csv", colClasses = c(file_date = "Date"))
wind_nj[[4]] <- data.table::fread("data/nj/nj_all_30min.csv", colClasses = c(file_date = "Date"))
wind_nj[[5]] <- data.table::fread("data/nj/nj_all_1hour.csv", colClasses = c(file_date = "Date"))
wind_nj[[6]] <- data.table::fread("data/nj/nj_all_1day.csv", colClasses = c(file_date = "Date"))

wind_va <- list()
wind_va[[1]] <- data.table::fread("data/va/va_all_1min.csv", colClasses = c(file_date = "Date"))
wind_va[[2]] <- data.table::fread("data/va/va_all_5min.csv", colClasses = c(file_date = "Date"))
wind_va[[3]] <- data.table::fread("data/va/va_all_10min.csv", colClasses = c(file_date = "Date"))
wind_va[[4]] <- data.table::fread("data/va/va_all_30min.csv", colClasses = c(file_date = "Date"))
wind_va[[5]] <- data.table::fread("data/va/va_all_1hour.csv", colClasses = c(file_date = "Date"))
wind_va[[6]] <- data.table::fread("data/va/va_all_1day.csv", colClasses = c(file_date = "Date"))



#*******************************************************************
# DATE RANGE
#*******************************************************************
wndx <- wind_nj[[1]]
file_date_range <- unique(wndx[,c(file_date)])


# Height Map for Check Box
height_map <- list()
height_map[[1]] <- c("h_wspd_1", "h_wdir_1", "55m")
height_map[[2]] <- c("h_wspd_2", "h_wdir_2", "60m")
height_map[[3]] <- c("h_wspd_3", "h_wdir_3", "80m")
height_map[[4]] <- c("h_wspd_4", "h_wdir_4", "100m")
height_map[[5]] <- c("h_wspd_5", "h_wdir_5", "120m")
height_map[[6]] <- c("h_wspd_6", "h_wdir_6", "150m")



height_vect <- c(
    "55m" = 1,
    "60m" = 2,
    "80m" = 3,
    "100m" = 4,
    "120m" = 5,
    "150m" = 6
)


time_vect <-c(
    "1 min" = 1,
    "5 min" = 2,
    "10 min" = 3,
    "30 min" = 4,
    "1 hour" = 5,
    "1 day" = 6
)





source('support/ui_support.R')
source('support_functions.R')

# EDA MODULES
source("modules/eda/eda_data_select.R")
source("modules/eda/eda_summary_tab.R")
source("modules/eda/eda_windspeed_tab.R")

# FORECAST MODULES
source("modules/forecast/fore_data_select.R")
source("modules/forecast/fore_review_tab.R")
source("modules/forecast/fore_preprocess_tab.R")
source("modules/forecast/fore_model_id_tab.R")
source("modules/forecast/fore_model_est_tab.R")
source("modules/forecast/fore_forecast_tab.R")
source("modules/forecast/fore_ase_tab.R")