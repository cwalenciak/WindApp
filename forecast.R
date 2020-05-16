
forecast_page <- tabPanel(
    "Forecast",
    sidebarLayout(
        
        sidebarPanel(
            width = 3,
            fore_data_select_ui("fore_data_select")
        ),
        
        mainPanel(
            width = 9,
            includeCSS("www/custom.css"),
            tabBox(
                width= 12,
                fore_review_tab_ui("fore_review_tab"),
                fore_preprocess_tab_ui("fore_preprocess_tab"),
                fore_model_id_tab_ui("fore_model_id_tab"),
                fore_model_est_tab_ui("fore_model_est_tab"),
                fore_forecast_tab_ui("fore_forecast_tab"),
                fore_ase_tab_ui("fore_ase_tab")
            )
        )
        
    )
)

