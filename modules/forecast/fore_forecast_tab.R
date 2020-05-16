fore_forecast_tab_ui <- function(id){
    #N
    ns <- NS(id)
    tabPanel(
        "5: Forecast",
        fluidRow(
            numericInput(
                ns("n_incr"),
                "n Ahead:",
                10,
                min = 5
            )
        ),
        fluidRow(
            plotOutput(ns('fore_plot'))
        )
    )
}


fore_forecast_tab_server <- function(input, output, session, dataset, estimates, d_num, s_num){
    
    output$fore_plot <- renderPlot({
        fore.aruma.wge(
            dataset(), 
            phi = estimates()$phi, 
            theta = estimates()$theta, 
            d = d_num(), 
            s = s_num(), 
            n.ahead = input$n_incr,
            limits = F
        )
    })
    
}





