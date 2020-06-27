var_forecast_tab_ui <- function(id){
    ns <- NS(id)
    
    tabPanel(
        "3: Forecast",
        fluidRow(
            column(
                width = 4,
                numericInput(
                    ns("n_incr"),
                    "n Ahead:",
                    10,
                    min = 5
                )
            ),
            column(
                width = 4,
                numericInput(
                    ns("p_incr"),
                    "p lags:",
                    1,
                    min = 1
                )
            ),
            column(
                width = 4,
                numericInput(
                    ns("n_obs"),
                    "Display Observation N:",
                    20,
                    min = 5
                )
            )
        ),
        fluidRow(
            plotOutput(ns('fore_plot'))
        )
    )
}


var_forecast_tab_server <- function(input, output, session, dataset, xregs){
    
    output$fore_plot <- renderPlot({
        lsfit <- VAR(xregs(), p = input$p_incr, type = "none")
        preds <- predict(lsfit, n.ahead = input$n_incr)
        plot_fore_obs_test(tail(xregs()[[1]], input$n_obs), preds$fcst[[1]][,1])
    })
    
    return(
        reactive({
            input$p_incr
        })
    )
    
}


