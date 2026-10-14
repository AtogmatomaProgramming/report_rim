#### ---- Script to load the necessary libraries to work ---- ####

# Libraries 

lib_names <- c("leaflet", "sapmuebase", "dplyr", "ggplot2", "patchwork", "tidyr", 
               "leaflet.minicharts", "knitr", "kableExtra")

# Import them

sapply(lib_names, import_libraries)
