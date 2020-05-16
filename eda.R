eda_page <- tabPanel(
    
    "EDA",
    sidebarLayout(
        
        sidebarPanel(
            width = 3,    
            eda_data_select_ui("dt_select")
        ),
        
        mainPanel(
            includeCSS("www/custom.css"),
            width = 9,
            tabBox(
                width= 12,
                tabPanelSum <- tabPanel(
                    "Summary",
                    eda_summary_tab_ui("summary_tab")
                    
                ),
                tabPanelWsp <- tabPanel(
                    "Windspeed",
                    eda_windspeed_tab_ui("windspeed_tab")
                )
                
            )
        )
    )
)


