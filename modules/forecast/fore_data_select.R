fore_data_select_ui <- function(id){
    
    ns <- NS(id)
    
    tagList(
        selectInput(
            ns("site"),
            "Select Site:",
            c("New Jersey","Virginia")
        ),
        
        dateInput(
            ns("train_day"),
            "Day to Train:",
            value = '2016-04-20',
            min(file_date_range),
            max(file_date_range)
        ),
        
        # numericInput(
        #     ns("n_points"),
        #     "n points (from end of day):",
        #     1440,
        #     min = 1,
        #     max = 1440
        # ),
        
        selectInput(
            ns("interval_select"),
            "Select Interval",
            time_vect
        ),
        
        selectInput(
            ns("height_select"),
            "Select Height:",
            height_vect
        )
    )
}


fore_data_select_server <- function(input, output, session){
    
    wind <- reactive({
        if(input$site == "New Jersey"){
            wind_data <- wind_nj
        } else { 
            wind_data <- wind_va
        }
        
        # Select Data Interval
        wind_data[[as.integer(input$interval_select)]]
        
    })       
    
    col <- reactive({
        height_map[[as.integer(input$height_select)]][1]
    })        
    
    # Filter data to date range
    train <- reactive({
        wind_train_day <- wind()[file_date == input$train_day]
        wind_train_day <- wind_train_day[[col()]]
        # wind_train_day[(length(wind_train_day) - input$n_points + 1):length(wind_train_day)]
    })

    observeEvent(input$interval_select,{
        updateNumericInput(
            session,
            "n_points",
            value = length(train()),
            max = length(train())
        )
    })
    
    test <- reactive({
        wind_test_day <- wind()[file_date == (input$train_day + 1)]
        wind_test_day[[col()]]
    })
    
    return(
        list(
            train = reactive({ train() }),
            test = reactive({ test() })
        )
    )
    
}




