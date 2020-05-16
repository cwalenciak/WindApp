#***************************************************************
# EDA WINDSPEED TAB MODULE
#***************************************************************
eda_windspeed_tab_ui <- function(id){
    ns <- NS(id)
    
    tagList(
        fluidRow(
            checkboxGroupInput(
                ns("heights"),
                "Heights:",
                height_vect,
                1,
                inline = TRUE
            ),
            numericInput(
                ns("ma_filt_num"),
                "Moving Average Filter:",
                0,
                min = 0
            )
        ),
        
        fluidRow(
            col_box_plot(
                plotOutput(ns('plot_wspd')), 
                'Wind Speed', 
                12
            )
        )
    )
}



eda_windspeed_tab_server <- function(input, output, session, dt){
    
    output$plot_wspd <- renderPlot({
        multi_heights_plot(dt(), input$heights, height_map, input$ma_filt_num)
    })
    
}