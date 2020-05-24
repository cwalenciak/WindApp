fore_model_id_tab_ui <- function(id){
    
    ns <- NS(id)
    
    tabPanel(
        "3: Model ID",
        fluidRow(
            column(
                width = 3,
                numericInput(
                    ns("p_upper"),
                    "p Upper Limit:",
                    5,
                    min = 0,
                    max = 15
                )
            ),
            column(
                width = 3,
                numericInput(
                    ns("q_upper"),
                    "q Upper Limit:",
                    3,
                    min = 0,
                    max = 10
                )
            ),
            column(
                width = 3,
                actionButton(
                    ns("update_button"),
                    "Refresh"
                )
            )
        ),
        
        fluidRow(
            column(
                width = 6, 
                DT::DTOutput(ns('aic_table')) %>% withSpinner(color="#0dc5c1")
            ),
            column(
                width = 6,
                DT::DTOutput(ns('bic_table')) %>% withSpinner(color="#0dc5c1")
            )
        )
    )
}

fore_model_id_tab_server <- function(input, output, session, dataset){
    
    upper_bounds <- eventReactive(input$update_button,{
        c(
            input$p_upper,
            input$q_upper
        )
    })
    
    # AIC
    output$aic_table <- DT::renderDT({
        ub <- upper_bounds()
        
        aic5.wge(
            dataset(),
            type = "aic", 
            p = 0:ub[1], 
            q = 0:ub[2]
        )
    }, options = list(dom = 't'))
    
    # BIC
    output$bic_table <- DT::renderDT({
        ub <- upper_bounds()
        
        aic5.wge(
            dataset(),
            type = "bic", 
            p = 0:ub[1], 
            q = 0:ub[2]
        )
    }, options = list(dom = 't'))

}

