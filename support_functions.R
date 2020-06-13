#************************************************************************************
# MULTI-HEIGHTS
#************************************************************************************
multi_heights_plot <- function(dt, heights_list, height_map, ma_n = 0){

    height_dt <- data.table()
    
    for(i in heights_list){
        
        # Get column from height list
        col <- height_map[[as.integer(i)]][1]
        
        # Get height title from height list
        height <- height_map[[as.integer(i)]][3]

        # MA Filter
        filt_data <- ma_filter(dt[[col]], ma_n)
        
        # temp_dt <- data.table(time = 1:dt[,.N], wspd = dt[[col]], height = height)
        temp_dt <- data.table(time = 1:length(filt_data), wspd = filt_data, height = height)
        height_dt <- rbindlist(list(height_dt, temp_dt))
    }
    
    g <- ggplot(height_dt, aes(x = time, y = wspd, col = height)) + geom_line()

    return(g)
}






# press_dt <- data.table(time = 1:new_dt[,.N], y = new_dt[["avg_temp"]])
# ggplot(press_dt, aes(x = time, y = y)) + geom_line()




ma_filter <- function(data, n){
    
    ma <- data
    if(n > 0){
        ma <- stats::filter(ma, rep(1, n))/n
        ma <- ma[!is.na(ma)]
    }
    
    return(ma)
}


#************************************************************************************
# WIND ROSE
#************************************************************************************
create_wind_rose <- function(dt, wind_col, dir_col){
    
    # Assign to columns
    dt[, horizontal_wdir:= dt[[dir_col]]]
    dt[, horizontal_wspd:= dt[[wind_col]]]
    
    dt[horizontal_wdir < 0, horizontal_wdir := horizontal_wdir + 360]
    
    # Break up in bins
    dt[, dir_bin:=cut(horizontal_wdir, breaks = 12)]
    
    by_dir <- dt %>% 
        group_by(dir_bin)
    
    wspd_grouped <- by_dir %>% 
        summarise(wspd = mean(horizontal_wspd))
    
    wspd_grouped$lower_bin <- seq(0,330, length.out = nrow(wspd_grouped))
    wspd_grouped$upper_bin <- seq(30,360, length.out = nrow(wspd_grouped))
    

    dir_colors = colorRampPalette(brewer.pal(n = 8, name = "RdBu"))(12)
    
    fig <- plot_ly(
        type = 'scatterpolar',
        mode = 'lines',
        height = 300
    ) 
    
    for (i in 1:nrow(wspd_grouped)) { 
        fig <- fig %>%
            add_trace(
                r = c(0, wspd_grouped$wspd[i], wspd_grouped$wspd[i], 0),
                theta = c(0, wspd_grouped$lower_bin[i], wspd_grouped$upper_bin[i], 0),
                fill = 'toself',
                fillcolor = dir_colors[i],
                line = list(
                    color = 'black'
                )
            ) 
    }
    
    fig <- fig %>%
        layout(
            title = list(text = "Wind Speed Average by Direction", y = 1, yanchor = "top"),
            polar = list(
                radialaxis = list(
                    visible = T,
                    range = c(0,max(wspd_grouped$wspd) + 1)
                ),
                angularaxis = list(
                    nticks = 16,
                    tickfont = list(size = 8),
                    rotation = 90,
                    direction = 'clockwise'
                )
            ),
            showlegend = F
        )
    
    return(fig)
}


# Inputs are vector data
plot_fore_obs_test <- function(obs_data, fore_data, test_data = NULL){

    obs_seq <- 1:length(obs_data)
    fore_seq <- (length(obs_data) ):(length(obs_data) + length(fore_data))

    df1 <- data.frame(time = obs_seq, y = obs_data, type = "observations")
    
    df2 <- data.frame(time = fore_seq, y =c(tail(obs_data,1), fore_data) , type = "forecast")

    if (is.null(test_data)){
        df3 <- data.frame()
    }else{
        df3 <- data.frame(time = fore_seq, y = test_data, type = "test")
    }

    df <- rbind(df1, df2, df3)
    
    ggplot(df, aes(x = time, y = y, color = type)) + 
        geom_line() + 
        scale_colour_manual(values=c(observations='black', test = 'blue' , forecast='red'))
    
}






