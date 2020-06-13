fore_forecast_tab_ui <- function(id){
    #N
    ns <- NS(id)
    tabPanel(
        "5: Forecast",
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


fore_forecast_tab_server <- function(input, output, session, dataset, estimates, d_num, s_num){
    
    output$fore_plot <- renderPlot({
        f <- fore.aruma.wge(
            dataset(), 
            phi = estimates()$phi, 
            theta = estimates()$theta, 
            d = d_num(), 
            s = s_num(), 
            n.ahead = input$n_incr,
            limits = F,
            plot = F
        )
        
        plot_fore_obs_test(tail(dataset(), input$n_obs), f$f)
    })
    
}





