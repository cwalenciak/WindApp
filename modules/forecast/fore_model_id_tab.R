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
                    "update_aic",
                    "Refresh"
                )
            )
        ),
        
        fluidRow(
            column(
                width = 6, 
                DT::DTOutput(ns('aic_table'))
            ),
            column(
                width = 6,
                DT::DTOutput(ns('bic_table'))
            )
        )
    )
}

fore_model_id_tab_server <- function(input, output, session, dataset){
    
    # AIC
    output$aic_table <- DT::renderDT({
        aic5.wge(
            dataset(),
            type = "aic", 
            p = 0:input$p_upper, 
            q = 0: input$q_upper
        )
    }, options = list(dom = 't'))
    
    # BIC
    output$bic_table <- DT::renderDT({
        aic5.wge(
            dataset(),
            type = "bic", 
            p = 0:input$p_upper, 
            q = 0: input$q_upper
        )
    }, options = list(dom = 't'))
    
}

