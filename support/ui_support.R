
col_box_plot <- function(output, name, width){
    c <- column(
        width = width,
        box(
            output,
            title = name,
            solidHeader = T,
            width = NULL,
            height = '350px',
            collapsible = F
        )
    )
    
    return(c)
}

