
#' Description:
#'  Function to import the neccesary libraries and download it in the case 
#'  it is not presence on the computer
#'
#' @param l_name name of the library


import_libraries <- function(l_name){
  
  tryCatch(
    expr = {
      
      if(l_name %in% installed.packages()[, "Package"]){
        
        require(l_name, character.only = TRUE)
        
        message(paste0("Package ", l_name, " loaded successfully"))
        
      } else {
        
        install.packages(l_name)
        
        require(l_name, character.only = TRUE)
        
        message(paste0("Package ", l_name, " installed and loaded successfully"))
        
      }
      
    },
    error = function(e){
      message("ERROR executing the function: ", e$message)
    }
  )
  
}
