#***************************************************************
# SUMMARY TAB MODULE
#***************************************************************
eda_summary_tab_ui <- function(id){
    
    ns <- NS(id)
    
    tagList(
        fluidRow(
            selectInput(
                ns("height_select"),
                "Select Height:",
                height_vect
            )
        ),
        
        fluidRow(
            col_box_plot(
                plotOutput(ns('plot_single_height_wspd')),
                'Wind Speed',
                6
            ),
            col_box_plot(
                plotlyOutput(ns('plot_rose')), 
                'Wind Rose', 
                6
            )
        ),
        
        fluidRow(
            col_box_plot(
                plotOutput(ns('plot_temp')), 
                'Temperature', 
                4
            ),
            col_box_plot(
                plotOutput(ns('plot_press')), 
                'Pressure', 
                4
            ),
            col_box_plot(
                plotOutput(ns('plot_humid')), 
                'Humid', 
                4
            )
        )
        
    )
}

eda_summary_tab_server <- function(input, output, session, dt){
    
    output$plot_single_height_wspd <- renderPlot({
        multi_heights_plot(dt(), c(input$height_select), height_map)
    }, height = 300)
    
    
    # Plot Temperature 
    output$plot_temp <- renderPlot({
        new_dt <- dt()
        press_dt <- data.table(time = 1:new_dt[,.N], y = new_dt[["avg_temp"]])
        ggplot(press_dt, aes(x = time, y = y)) + geom_line()
    }, height = 300)
    
    
    # Plot Pressure
    output$plot_press <- renderPlot({
        new_dt <- dt()
        press_dt <- data.table(time = 1:new_dt[,.N], y = new_dt[["avg_pressure"]])
        ggplot(press_dt, aes(x = time, y = y)) + geom_line()
    }, height = 300)
    
    
    # Plot Pressure
    output$plot_humid <- renderPlot({
        new_dt <- dt()
        press_dt <- data.table(time = 1:new_dt[,.N], humid = new_dt[["avg_humidity"]])
        ggplot(press_dt, aes(x = time, y = humid)) + geom_line()
    }, height = 300)
    
    # Plot Wind Rose
    output$plot_rose <- renderPlotly({
        df <- dt()
        create_wind_rose(
            df, 
            height_map[[as.integer(input$height_select)]][1], 
            height_map[[as.integer(input$height_select)]][2]
        )
    })
}