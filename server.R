library(dplyr)
library(ggplot2)
library(data.table)
library(plotly)
library(RColorBrewer)



server <- function(input, output){
    
    #*******************************************************************************
    # EDA PAGE
    #*******************************************************************************
    
    dt_select <- callModule(eda_data_select_server, "dt_select")
    
    # SUMMARY TAB
    callModule(eda_summary_tab_server, "summary_tab", dt_select)
    
    # WINDSPEED TAB
    callModule(eda_windspeed_tab_server, "windspeed_tab", dt_select )
    
    
    #*******************************************************************************
    # FORECAST PAGE
    #*******************************************************************************
    windspeed <- callModule(fore_data_select_server, "fore_data_select")
    
    # 1: REVIEW TAB 
    callModule(fore_review_tab_server, "fore_review_tab", windspeed$train)

    # 2: TRANSFORM DATA 
    trans_data <- callModule(fore_preprocess_tab_server , "fore_preprocess_tab", windspeed$train)
    
    # 3: MODEL IDENTIFICATION
    callModule(fore_model_id_tab_server, "fore_model_id_tab", trans_data$data)
    
    # 4: MODEL ESTIMATES
    estimates <- callModule(fore_model_est_tab_server, "fore_model_est_tab", trans_data$data)
    
    # 5: FORECAST
    callModule(
        fore_forecast_tab_server,
        "fore_forecast_tab", 
        windspeed$train,
        estimates, 
        trans_data$d, 
        trans_data$s 
    )
    
    # 6: ASE
    callModule(
        fore_ase_tab_server,
        "fore_ase_tab",
        windspeed$train,
        windspeed$test,
        estimates,
        trans_data$d,
        trans_data$s
    )
    
    
    #*******************************************************************************
    # VAR PAGE
    #*******************************************************************************
    windspeed2 <- callModule(var_data_select_server, "var_data_select")
    
    # 1: REVIEW TAB 
    callModule(var_review_tab_server, "var_review_tab", windspeed2$train_wnd, windspeed2$train_xreg)
    
    # 2: LAG SELECTION
    callModule(var_lag_select_tab_server, "var_lag_select_tab", windspeed2$train_xreg)
    
    # 3: FORECAST
    lags <- callModule(
        var_forecast_tab_server,
        "var_forecast_tab",
        windspeed2$train_wnd,
        windspeed2$train_xreg
    )
    # var_ase_tab_server <- function(input, output, session, train_data, test_data, lags, col){
    callModule(var_ase_tab_server, "var_ase_tab", windspeed2$train_xreg, windspeed2$test_wnd, lags, "t")
    
    
}




