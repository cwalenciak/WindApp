source('eda.R')
source('forecast.R')

ui <- fluidPage(
    navbarPage(
        "Buoy Lidar Data",
        eda_page,
        forecast_page
    )
)
