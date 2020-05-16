#***************************************************************
# EDA DATA MODULE
#***************************************************************
eda_data_select_ui <- function(id){
    
    ns <- NS(id)
    
    tagList(
        selectInput(
            ns("site"),
            "Select Site:",
            c("New Jersey","Virginia")
        ),
        
        selectInput(
            ns("interval_select"),
            "Select Interval",
            time_vect
        ),
        
        dateRangeInput(
            ns("dates"),
            'Select Date Range:',
            '2016-04-20',
            '2016-04-20',
            min(file_date_range),
            max(file_date_range)
        )
    )
}


eda_data_select_server <- function(input, output, session){
    
    reactive({
    
        if(input$site == "New Jersey"){
            wind_data <- wind_nj
        } else { 
            wind_data <- wind_va
        }
        
        # Select Data Interval
        wind_dt <- wind_data[[as.integer(input$interval_select)]]

        # Filter data to date range
        wind_dt <- wind_dt[ file_date >= input$dates[1] & file_date <= input$dates[2] ]
   
        wind_dt
    })
    
}