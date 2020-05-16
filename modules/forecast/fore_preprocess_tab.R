fore_preprocess_tab_ui <- function(id){
    
    ns <- NS(id)
    
    tabPanel(
        "2: Preprocess",
        fluidRow(
            column(
                width = 4,
                numericInput(
                    ns("d_incr"),
                    "Difference (d):",
                    0,
                    min = 0
                )
            ),
            column(
                width = 4,
                numericInput(
                    ns("s_incr"),
                    "Seasonality (s):",
                    0,
                    min = 0
                )
            )
        ),
        
        fluidRow(
            column(
                plotOutput(ns('plot_diff_data')),
                width = 12
            )
        )
        
    )
}


fore_preprocess_tab_server <- function(input, output, session, dataset){
    
    wspd_trans <- reactive({
        x <- diff_data(dataset(), input$d_incr)
        season_data(x, input$s_incr)
    })
    
    output$plot_diff_data <- renderPlot({
        plotts.sample.wge(wspd_trans())
    })
    
    return(
        list(
            data = reactive({wspd_trans()}),
            d = reactive({input$d_incr}),
            s = reactive({input$s_incr})
        )
    )
}


#************************************************************************************
# DIFFERENCE DATA (1-B)
#************************************************************************************
diff_data <- function(dif_data, d){
    
    dif <- dif_data
    
    if(d > 0){
        for(i in 1:d){
            dif <- diff(dif, 1)
        }        
    }
    
    return(dif)
}



#************************************************************************************
# SEASONALITY
#************************************************************************************
season_data <- function(data, s){
    
    dif <- data
    
    if(s > 0){
        dif <- diff(dif, s)
    }
    
    return(dif)
}
