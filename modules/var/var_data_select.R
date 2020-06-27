var_data_select_ui <- function(id){
    
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
        
        selectInput(
            ns("interval_select"),
            "Select Interval",
            time_vect
        ),
        
        selectInput(
            ns("height_select"),
            "Select Height:",
            height_vect
        ),
        
        checkboxGroupInput(
            ns("xreg_select"),
            "Select XReg Variables:",
            xreg_vars,
            selected = xreg_vars,
            inline = FALSE
        )
    )
}


var_data_select_server <- function(input, output, session){
    
    col <- reactive({
        height_map[[as.integer(input$height_select)]][1]
    }) 

    wind <- reactive({
        if(input$site == "New Jersey"){
            wind_data <- wind_nj
        } else {
            wind_data <- wind_va
        }

        # Select Data Interval
        wind_data[[as.integer(input$interval_select)]]

    })
    
    observeEvent(input$interval_select, {
        updateNumericInput(
            session,
            "n_points",
            value = length(train_wnd()),
            max = length(train_wnd())
        )
    })

    # Filter data to date range
    train_wnd <- reactive({
        wind_train_day <- wind()[file_date == input$train_day]
        wind_train_day[[col()]]
    })

    test_wnd <- reactive({
        wind_test_day <- wind()[file_date == (input$train_day + 1)]
        temp <- c(col(), input$xreg_select)
        wind_test_day[,..temp]
    })
    
    train_xreg <- reactive({
        wind_train_day <- wind()[file_date == input$train_day]
        temp <- c(col(), input$xreg_select)
        wind_train_day[,..temp]
    })


    return(
        list(
            train_wnd = reactive({ train_wnd() }),
            test_wnd = reactive({ test_wnd() }),
            train_xreg = reactive({ train_xreg() }),
            col = reactive({ col () })
        )
    )
    
}



