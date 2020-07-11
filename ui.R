source('eda.R')
source('forecast.R')
source('var.R')
source('about.R')

ui <- fluidPage(
    navbarPage(
        "Buoy Lidar Data",
        eda_page,
        forecast_page,
        var_page,
        about_page
    )
)
