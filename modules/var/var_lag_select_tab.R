var_lag_select_tab_ui <- function(id){
    
    ns <- NS(id)
    
    tabPanel(
        "2: Lag Select",
        fluidRow(
            column(
                width = 3,
                numericInput(
                    ns("lag_max"),
                    "Lag.Max:",
                    5,
                    min = 5
                )
            )
        ),
        
        fluidRow(
            column(
                width = 6, 
                DT::DTOutput(ns("vsel_table")) %>% withSpinner(color="#0dc5c1")
            )
        )
    )
}

var_lag_select_tab_server <- function(input, output, session, dataset){
    
    output$vsel_table <- DT::renderDT({
        temp <- VARselect(dataset(), lag.max = input$lag_max, type = "none", season = NULL, exogen = NULL)
        temp <- as.data.frame(temp$selection)
        temp

    }, options = list(dom = 't'))

}