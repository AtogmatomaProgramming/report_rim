#' Description:
#' 
#'  Function to draw the map of Spain with the work ports
#'
#' @param df_coords master dataframe with the ports and its coordinates


draw_map <- function(df_coords,
                     plot_data = FALSE){
  
  tryCatch(
    expr = {
        
        leaflet(data = df_coords) %>% 
          addTiles() %>%  
          addMarkers(
            lng = ~LONGITUD, 
            lat = ~LATITUD,  
            popup = ~PUERTO  
          )
        
    },
    error = function(e){
      message("ERROR executing the function: ", e$message)
    }
  )
  
}