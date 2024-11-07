# ----------------------------------------------------------------
#            INSTRUCTIONS FOR THE TERMINAL 
# ----------------------------------------------------------------

# We want to make sure this is being saved by git. 
# You can check this by clicking the Git tab in RStudio.

# If it doesn't exist, then put in the terminal (NOT CONSOLE):
#       git init

# And then use the git tab in RStudio to add the files and commit. 

# See canvas for more help with git. 


# ----------------------------------------------------------------
#            INSTRUCTIONS FOR THE CONSOLE 
# ----------------------------------------------------------------

# Make sure you have renv installed. In the console:
#         install.packages("renv") 
# or use the Packages pane in RStudio

# Look in your RProject files, if you don't see a folder called renv
# you need to initialise it. 

#         renv::init()

# Now we can install the packages we need using renv:

# ----Install the packages: ----
#         renv::install("tidyverse")
#         renv::install("palmerpenguins")
#         renv::install("here")
#         renv::install("janitor")
#         renv::install("patchwork")
#         renv::install("ragg")
#         renv::install("svglite")

# You can use install.packages() to install, but you will need to update renv:
# renv::snapshot()

# Later when we come back to this project, or someone else wants to use it,
# we can restore the packages:
# renv::restore()


# ----------------------------------------------------------------
#            PENGUIN ANALYSIS SCRIPT 
# ----------------------------------------------------------------

# Do not start your script with install.packages() -- it will download the packages every time you run the script
# Do not start your script with setwd("C:/Users/...") -- we are using the here() function which is much better
library(tidyverse)
library(palmerpenguins)
library(here)
library(janitor)
library(patchwork)
library(ragg)
library(svglite)

# Loading the functions we wrote from two files. 
source(here("functions", "cleaning.R"))
source(here("functions", "plotting.R"))
# -------------------------------------

# ---- Save the raw data ----
# This is commented out because we already have the raw data saved.
# write_csv(penguins_raw, here("data", "penguins_raw.csv"))
# -------------------------------------

# ---- Load the raw data ----
penguins_raw <- read_csv(here("data", "penguins_raw.csv"))
# -------------------------------------

# ---- Check column names ----  
colnames(penguins_raw)
# -------------------------------------

# ---- Cleaning the data ----
# We can use the functions from libraries like janitor and also 
# our own functions, like those in cleaning.R. 
# I've used a pipe %>% to chain the functions together. You can also make this
# into a function if you want to (functions within functions).
penguins_clean <- penguins_raw %>%
  clean_column_names() %>%
  remove_columns(c("comments", "delta")) %>%
  shorten_species() %>%
  shorten_sex() %>%
  remove_empty_columns_rows()
# -------------------------------------


# ---- Check the output ----
colnames(penguins_clean)
# -------------------------------------


# ---- Save the clean data ----
write_csv(penguins_clean, here("data", "penguins_clean.csv"))
# -------------------------------------


# ---- Creating the plotting colour palettes ----
species_colours <- c("Adelie" = "darkorange", 
                    "Chinstrap" = "purple", 
                    "Gentoo" = "cyan4")

malefemale_colours <- c("Male" = "#457EAC",  
                       "Female" = "#9191E9")
# -------------------------------------


# ---- Creating the plotting colour palettes ----
flipper_plot <- plot_boxplot(penguins_clean, 
                             species, flipper_length_mm, 
                             "Species", "Flipper Length (mm)", 
                             species_colours)

bill_length_plot <- plot_boxplot(penguins_clean, 
                                 species, culmen_length_mm, 
                                 "Species", "Bill Length (mm)", 
                                 species_colours)

flipper_sexes_plot <- plot_boxplot(penguins_clean, 
                                 sex, flipper_length_mm, 
                                 "Sex", "Flipper Length (mm)", 
                                 malefemale_colours)

bill_length_sexes_plot <- plot_boxplot(penguins_clean, 
                                 sex, culmen_length_mm, 
                                 "Sex", "Bill Length (mm)", 
                                 malefemale_colours)
# -------------------------------------


# ------- Saving the plots png --------------------

# This plot is 20x20cm with good scaling for a report and high resolution.
save_plot_png(flipper_plot, 
             here("figures", "flipper_length_boxplot_report.png"), 
             20, 300, 2)

# This plot looks identical to the report, but is double the size 
# and therefore double the scale. 
save_plot_png(flipper_plot, 
             here("figures", "flipper_length_boxplot_poster.png"), 
             40, 300, 4)

# This plot is 20x20cm with good scaling for a powerpoint.
save_plot_png(flipper_plot, 
             here("figures", "flipper_length_boxplot_powerpoint.png"), 
             20, 300, 3)
# -------------------------------------


# ------- Making a combined plot --------------------

# Using patchwork, we can combine the plots together.
# Combine plots in a 2x2 grid
combined_plot <- (flipper_plot | flipper_sexes_plot) / (bill_length_plot | bill_length_sexes_plot)
combined_plot
# -------------------------------------


# ------- Saving the combined plot as svg --------------------

save_plot_svg(combined_plot, 
             here("figures", "combined_plot.svg"), 
             20, 1)
# -------------------------------------