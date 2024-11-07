## ---------------------------
##
## Script name: Plotting.r
##
## Purpose of script: 
##      # A file of functions for cleaning the Palmer Penguins dataset
##
## Author: Dr. Lydia France
##
## Date Created: 2024-11-05 
##
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

#  A function to make a boxplot with jittered points for given columns
plot_boxplot <- function(data, 
                         x_column, 
                         y_column, 
                         x_label, 
                         y_label, 
                         colour_mapping) {

    
    # Remove NA values 
    data <- data %>%
        drop_na({{ x_column }}, {{ y_column }}) 



    # Now make the plot
    ggplot(data = data, 
           aes(
            x = {{ x_column }}, # Use {{ }} for x and y columns
            y = {{ y_column }}, 
            color = {{ x_column }})) +  
        geom_boxplot(width = 0.3, show.legend = FALSE) +
        geom_jitter(
            alpha = 0.3,
            size = 1,
            show.legend = FALSE,
            position = position_jitter(width = 0.2, seed = 0)) +
        scale_color_manual(values = colour_mapping) +  # Use color_mapping input here
        labs(x = x_label, y = y_label) +  # Use provided x and y labels
        theme_bw()
}



# Save the plot as a png file

save_plot_png <- function(plot, 
                         filename, size, res, scaling){
  agg_png(filename, width   =  size, 
                    height  =  size, 
                    units   =  "cm", 
                    res     =  res, 
                    scaling =  scaling)
  print(plot)
  dev.off()
}

# Save the plot as a svg file
save_plot_svg <- function(plot, 
                         filename, size, scaling){
    size_inches = size/2.54
    svglite(filename, width   = size_inches, 
                      height  = size_inches, 
                      scaling = scaling)
    print(plot)
    dev.off()
}