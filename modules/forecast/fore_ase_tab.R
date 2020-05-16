fore_ase_tab_ui <- function(id){
    
    ns <- NS(id)
    
    tabPanel(
        "6: Windowed ASE",
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
                    5,
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

fore_ase_tab_server <- function(input, output, session, dataset, test_dataset, estimates, d_num, s_num){
    
    ase_data <- reactive({

        train <- dataset()
        test <- test_dataset()
        
        init_forecast <- fore.aruma.wge(
            train,
            phi = estimates()$phi,
            theta = estimates()$theta,
            d = d_num(),
            s = s_num(),
            n.ahead = input$horizon,
            limits = F,
            plot = F
        )
        
        fore_list <- list(init_forecast$f)
        ase_vect <- c()

        for(i in 1:(input$window_num - 1)){
            
            v1 <- train[(1 + i):length(train)]
            v2 <- test[1:i]
            
            fore_data <- c(v1, v2)

            wspd_fore <- fore.aruma.wge(
                fore_data,
                phi = estimates()$phi,
                theta = estimates()$theta,
                d = d_num(),
                s = s_num(),
                n.ahead = input$horizon,
                limits = F,
                plot = F
            )

            err <- test[(i + 1):(i + input$horizon)] - wspd_fore$f
            ase_vect <- c(ase_vect, mean(err^2))

            fore_list[[i + 1]] <- wspd_fore$f
            
        }
        
        return(list(ase = ase_vect, forecast = fore_list))
    })
    
    output$mean_ase <- renderText({
        mean(ase_data()$ase)
    })

    output$plot_window_ase <- renderPlot({
        
        fore_list <- ase_data()$forecast
        
        f_first <- lapply(fore_list, `[[`, 1)
        f_first <- unlist(f_first)

        f_last <- lapply(fore_list, `[[`, input$horizon)
        f_last <- unlist(f_last)
        
        rolling_ase_plot(
            test_dataset(),
            input$window_num,
            input$horizon,
            fore_list,
            f_first,
            f_last,
            input$y_lower,
            input$y_upper
        )
        # plot(f_ones, type = "l")
        # lines(f_last)
    })
    
}

# mean(ase_arima_vect)



rolling_ase_plot <- function(test, window_num, horizon, fore_list, f_first, f_last, y_lower, y_upper){
    
    plot(
        x = 1:(window_num + horizon - 1),
        test[1:(window_num + horizon - 1)],
        type = "n",
        ylim = c(y_lower, y_upper),
        xlim = c(0, (window_num + horizon))
    )
    
    # Forecast
    for(i in 1:window_num) {
        lines(
            x = i:(i + horizon - 1), 
            y = fore_list[[i]], 
            type = "l", 
            col = "grey80"
        )
    }

    # Test Data
    lines(
        x = 1:(window_num + horizon - 1), 
        test[1:(window_num + horizon - 1)], 
        type = "l", 
        lwd = 3
    )
    
    # First Line
    lines(
        x = 1:window_num, 
        f_first, 
        col = "blue", 
        type = "l", 
        lwd = 2
    )
    
    # Last Line
    lines(
        x = horizon:(window_num + horizon -1), 
        f_last, 
        col = "red", 
        type = "l", 
        lwd = 2
    )
    
}

