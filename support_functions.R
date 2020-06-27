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
    fore_seq <- length(obs_data):(length(obs_data) + length(fore_data))

    df1 <- data.frame(time = obs_seq, y = obs_data, type = "observations")
    
    df2 <- data.frame(time = fore_seq, y =c(tail(obs_data,1), fore_data) , type = "forecast")

    if (is.null(test_data)){
        df3 <- data.frame()
    }else{
        df3 <- data.frame(time = fore_seq, y = c(tail(obs_data, 1), test_data), type = "test")
    }

    df <- rbind(df1, df2, df3)
    
    ggplot(df, aes(x = time, y = y, color = type)) + 
        geom_line() + 
        scale_colour_manual(values=c(observations='black', test = 'blue' , forecast='red'))
    
}



arima_windowed_ase <- function(windows, horizon, ts_data, train_size, p, q, d = 0, s = 0){
    
    return_list <- list()
    
    ase_vect <- c()
    
    fore_df <- c()
    obs_df <- c()
    test_df <- c()
    
    ts1 <- ts_data[1:train_size]
    ts2 <- ts_data[(train_size + 1):length(ts_data)]
    
    for(i in 1:windows){
        
        test_data <- ts2[i:(horizon + (i - 1))]
        
        temp1 <- tail(ts1, length(ts1) - (i - 1))
        temp2 <- head(ts2, i - 1)
        ts <- c(temp1, temp2)
        
        ts_dif <- diff(ts, lags = d)
        
        ts_est <-
            est.arma.wge(ts_dif,
                         p = p,
                         q = q,
                         factor = F)
        
        ts_fore <-
            fore.aruma.wge(
                ts,
                phi = ts_est$phi,
                theta = ts_est$theta,
                d = d,
                s = s,
                n.ahead = horizon,
                limits = F,
                plot = F
            )
        
        err <- test_data - ts_fore$f
        ase_vect <- c(ase_vect, mean(err ^ 2))
        
        fore_df <- cbind(fore_df, ts_fore$f)
        obs_df <- cbind(obs_df, ts)
        test_df <- cbind(test_df, test_data)
        
    }
    
    colnames(fore_df) <- (1:windows)
    colnames(obs_df) <- (1:windows)
    colnames(test_df) <- (1:windows)
    
    return(
        list(
            mean(ase_vect),
            fore_df,
            obs_df,
            test_df
        )
    )
    
}


#============================
# WINDOWED ASE FUNCTIONS
#============================

windowed_ase_plot <- function(test, window_num, horizon, fore_list, f_first, f_last, y_lower, y_upper){
    
    plot(
        x = 1:(window_num + horizon - 1),
        test[1:(window_num + horizon - 1)],
        type = "n",
        ylim = c(y_lower, y_upper),
        xlim = c(0, (window_num + horizon))
    )
    
    # Forecast
    for(i in 1:window_num) {
        lines(
            x = i:(i + horizon - 1), 
            y = fore_list[,i], 
            type = "l", 
            col = "grey80"
        )
    }
    
    # Test Data
    lines(
        x = 1:(window_num + horizon - 1), 
        test[1:(window_num + horizon - 1)], 
        type = "l", 
        lwd = 3
    )
    
    # First Line
    lines(
        x = 1:window_num, 
        f_first, 
        col = "blue", 
        type = "l", 
        lwd = 2
    )
    
    # Last Line
    lines(
        x = horizon:(window_num + horizon -1), 
        f_last, 
        col = "red", 
        type = "l", 
        lwd = 2
    )
    
}



