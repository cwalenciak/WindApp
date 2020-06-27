var_ase_tab_ui <- function(id){
    
    ns <- NS(id)
    
    tabPanel(
        "4: Windowed ASE",
        fluidRow(
            column(
                width = 3,
                numericInput(
                    ns("horizon"),
                    "horizon:",
                    10,
                    min = 1
                )
            ),
            column(
                width = 3,
                numericInput(
                    ns("window_num"),
                    "Windows:",
                    10,
                    min = 1
                )
            ),
            column(
                width = 3,
                numericInput(
                    ns("y_lower"),
                    "y_lower:",
                    2,
                    min = 0,
                    step = .5
                )
            ),
            column(
                width = 3,
                numericInput(
                    ns("y_upper"),
                    "y_upper:",
                    8,
                    min = 5,
                    max = 40,
                    step = .5
                )
            ),
            box("Mean ASE", textOutput(ns('mean_ase')))
        ),
        fluidRow(
            plotOutput(ns('plot_window_ase'))
        )
    )
}

var_ase_tab_server <- function(input, output, session, train_data, test_data, lags, col){
    
    var_arr <- reactive({var_windowed_ase(input$window_num, input$horizon, train_data(), test_data(), lags())})
    
    output$mean_ase <- reactive({var_arr()$mean_ase})
    
    
    output$plot_window_ase <- renderPlot({
        
        # var_windowed_ase <- function(windows, horizon, ts_data, col, train_size, type = "none"){
        var_arr <- var_arr()
        print(var_arr$mean_ase)
        # windowed_ase_plot <- function(test, window_num, horizon, fore_list, f_first, f_last, y_lower, y_upper){
        windowed_ase_plot(test_data()[[1]],
                          input$window_num,
                          input$horizon,
                          var_arr$fore_df,
                          var_arr$fore_df[1, ],
                          var_arr$fore_df[nrow(var_arr$fore_df), ],
                          input$y_lower,
                          input$y_upper)
    })
    
}


# ts_data: dataframe
var_windowed_ase <- function(windows, horizon, train_data, test_data, lags, type = "none"){
    
    return_list <- list()
    
    ase_vect <- c()
    fore_df <- c()

    for(i in 1:windows){
        
        ts1 <- train_data[i:nrow(train_data),]
        ts2 <- head(test_data, i-1)
        ts <- as.data.frame(rbind(ts1, ts2))

        lsfit <- VAR(ts, p = lags, type = type)
        
        preds <- predict(lsfit, n.ahead = horizon)
    
        err <- test_data[[1]][(1 + i - 1):(horizon + i - 1)] - preds$fcst[[1]][,1]
        ase_vect <- c(ase_vect, mean(err ^ 2))
        
        fore_df <- cbind(fore_df, preds$fcst[[1]][,1])
    }

    return(
        list(
            mean_ase = mean(ase_vect),
            fore_df = fore_df
        )
    )
    
}
