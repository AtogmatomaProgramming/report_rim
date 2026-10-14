#' Description:
#'  Function to import in all unique file all de rim working data
#'
#' @param years years of work


load_rim_data <- function(years){
  
  
  dirs <- list.dirs(getwd())
  
  match_rim <- sapply(years,
                       function(i){
                         file.path("rim", i)
                       }
  )
  
  
  rim_dirs <- sapply(match_rim, 
                      function(i, f){
                        f <- f[grepl(i, f)]
                      }, 
                      dirs)
  
  rim_names <- list.files(rim_dirs)
  
  rim_files <- mapply(importRIMLengths, 
                      rim_names, 
                      rim_dirs,
                      SIMPLIFY = FALSE)
  
  rim_files <- do.call(rbind, rim_files)
  
  ## Internal adjust for rim df
  
  rim_files$YEAR <- as.character(rim_files$YEAR)
  
  ## Add month with the name,not the number
  
  rim_files <- convert_month_number_name(rim_files, 
                                         table_num_month)
  
  return(rim_files)
  
}




