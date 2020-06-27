source('eda.R')
source('forecast.R')
source('var.R')

ui <- fluidPage(
    navbarPage(
        "Buoy Lidar Data",
        eda_page,
        forecast_page,
        var_page
    )
)
