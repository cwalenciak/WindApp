var_review_tab_ui <- function(id){
    
    ns <- NS(id)
    
    tabPanel(
        "1: Data Review",
        tagList(
            fluidRow(
                col_box_plot(
                    plotOutput(ns('plot_single_height_wspd')),
                    'Wind Speed',
                    8
                ),
                col_box_plot(
                    plotOutput(ns('plot_dew')), 
                    'Dew Point', 
                    4
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

    )
    
    
    
}


var_review_tab_server <- function(input, output, session, wndspd, dataset){

    output$plot_single_height_wspd <- renderPlot({
        wnd_dt <- data.table(time = 1:length(wndspd()), y = wndspd())
        ggplot(wnd_dt, aes(x = time, y = y)) + geom_line()
    }, height = 300)
    
    
    # Plot Avg Dew Point 
    output$plot_dew <- renderPlot({
        new_dt <- dataset()
        if(!is.null(new_dt[["avg_dew_point"]])){
            dew_dt <- data.table(time = 1:new_dt[,.N], y = new_dt[["avg_dew_point"]])
            ggplot(dew_dt, aes(x = time, y = y)) + geom_line()
        }
    }, height = 300)
    
    
    # Plot Temperature 
    output$plot_temp <- renderPlot({
        new_dt <- dataset()
        if(!is.null(new_dt[["avg_temp"]])){
            press_dt <- data.table(time = 1:new_dt[,.N], y = new_dt[["avg_temp"]])
            ggplot(press_dt, aes(x = time, y = y)) + geom_line()
        }
    }, height = 300)
    
    
    # Plot Pressure
    output$plot_press <- renderPlot({
        new_dt <- dataset()
        if(!is.null(new_dt[["avg_pressure"]])){
            press_dt <- data.table(time = 1:new_dt[,.N], y = new_dt[["avg_pressure"]])
            ggplot(press_dt, aes(x = time, y = y)) + geom_line()
        }
    }, height = 300)
    
    
    # Plot Pressure
    output$plot_humid <- renderPlot({
        new_dt <- dataset()
        if(!is.null(new_dt[["avg_humidity"]])){
            press_dt <- data.table(time = 1:new_dt[,.N], humid = new_dt[["avg_humidity"]])
            ggplot(press_dt, aes(x = time, y = humid)) + geom_line()
        }
    }, height = 300)
    
}


