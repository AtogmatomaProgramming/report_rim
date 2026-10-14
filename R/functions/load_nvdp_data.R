#' Description:
#'  Function to import in all unique file all de nvdp working data
#'
#' @param years years of work


load_nvdp_data <- function(years){
  
  match_nvdp <- sapply(years,
                       function(i){
                         file.path("nvdp", i)
                       }
                      )
  
  
  nvdp_path <- sapply(match_nvdp, 
                      function(i, f){
                        f <- f[grepl(i, f)]
                      }, 
                      path_files)
  
  
  nvdp_files <- sapply(nvdp_path, 
                       read.csv)
  
  nvdp_files <- lapply(nvdp_files, 
                       function(i){
                         colnames(i)[grep("TRIM", colnames(i))] <-"TRIM"
                         colnames(i)[grep("BUQUE", colnames(i))] <-"COD_BUQUE"
                         return(i)
                       })
  
  
  nvdp_files <- lapply(nvdp_files, 
                     function(i){
                       i <- i[, base_columns_nvdp]
                       return(i)
                     })
  

  
  nvdp_merged <- do.call(rbind, nvdp_files)
  
  
  nvdp_merged <- merge(nvdp_merged,
                       metier_stratum_port,
                       all.x = TRUE)
  
  nvdp_merged <- merge(nvdp_merged,
                       sapmuebase::puerto,
                       all.x = TRUE)
  
  ## Internal adjust for nvdp df
  
  nvdp_merged <- nvdp_merged[nvdp_merged$LABORATORIO != "AZTI", ]
  
  nvdp_merged$ANYO <- as.character(nvdp_merged$ANYO)
  
  nvdp_merged <- convert_month_number_name(
                                           nvdp_merged, 
                                           table_num_month
                                           )
  
  return(nvdp_merged)
  
  
}




