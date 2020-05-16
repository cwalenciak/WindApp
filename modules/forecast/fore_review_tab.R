fore_review_tab_ui <- function(id){
    
    ns <- NS(id)
    
    tabPanel(
        "1: Data Review",
        box(
            plotOutput(ns('plot_train_data')),
            title = "Selected Train Data:", 
            solidHeader = T,
            width = NULL, 
            collapsible = F
        )
    )
    
}


fore_review_tab_server <- function(input, output, session, dataset){
    
    output$plot_train_data <- renderPlot({
        plotts.wge(dataset())
    })
    
}