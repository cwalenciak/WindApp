
var_page <- tabPanel(
    "VAR",
    sidebarLayout(
        
        sidebarPanel(
            width = 3,
            var_data_select_ui("var_data_select")
        ),
        
        mainPanel(
            width = 9,
            includeCSS("www/custom.css"),
            tabBox(
                width= 12,
                var_review_tab_ui("var_review_tab"),
                var_lag_select_tab_ui("var_lag_select_tab"),
                var_forecast_tab_ui("var_forecast_tab"),
                var_ase_tab_ui("var_ase_tab")
            )
        )
    )
)
