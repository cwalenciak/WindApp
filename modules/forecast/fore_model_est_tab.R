fore_model_est_tab_ui <- function(id){
    
    ns <- NS(id)
    
    tabPanel(
        "4: Model Estimate",
        fluidRow(
            column(
                width = 3,
                numericInput(
                    ns("p"),
                    "Phi Count (p):",
                    0,
                    min = 0,
                    max = 15
                )
            ),
            column(
                width = 3,
                numericInput(
                    ns("q"),
                    "Theta Count (q):",
                    0,
                    min = 0,
                    max = 10
                )
            )
        ),
        
        fluidRow(
            box("Phi's", textOutput(ns('est_phis')))
        ),
        fluidRow(
            box("Theta's", textOutput(ns('est_thetas')))
        ),
        fluidRow(
            box("Residuals:", plotOutput(ns('est_residuals')))
        )
    )
}


fore_model_est_tab_server <- function(input, output, session, dataset){
    
    estimates <- reactive({ 
        est.arma.wge(dataset(), p = input$p, q = input$q)
    })
    
    output$est_phis <- renderText({
        estimates()$phi
    })
    
    output$est_thetas <- renderText({
        estimates()$theta
    })
    
    output$est_residuals <- renderPlot({
        plotts.wge(estimates()$res)
    })
    
    return(
        reactive({
            estimates()
        })
    )
}