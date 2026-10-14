#' Description:
#'  Function to proccess the nvdp's dataframe with the 
#'  needed values
#'
#' @param df nvdp's dataframe


process_nvdp_df <- function(df){
  
  nvdp_df <- df[df$PUERTO %in% cities & 
                           df$ANYO == specific_year, ] %>% 
    mutate(TOTAL_UNLOADS = n_distinct(IDMAREA),
           TOTAL_UNIQUE_VESSELS = n_distinct(COD_BUQUE)) %>% 
    group_by(ESTRATO_RIM) %>% 
    mutate(TOTAL_STRATUM_UNLOADS = n_distinct(IDMAREA),
           TOTAL_STRATUM_UNIQUE_VESSELS = n_distinct(COD_BUQUE)) %>% 
    group_by(PUERTO) %>% 
    mutate(PORT_TOTAL_UNLOADS = n_distinct(IDMAREA), 
           PORT_TOTAL_UNIQUE_VESSELS = n_distinct(COD_BUQUE)) %>%
    group_by(PUERTO, ESTRATO_RIM) %>% 
    mutate(PORT_TOTAL_STRATUM_UNLOADS = n_distinct(IDMAREA),
           PORT_TOTAL_STRATUM_UNIQUE_VESSELS = n_distinct(COD_BUQUE))
  
  
  nvdp_df <- unique(nvdp_df[, c(
    "PUERTO", "ESTRATO_RIM", 
    "PORT_TOTAL_STRATUM_UNLOADS", 
    "PORT_TOTAL_UNLOADS",
    "PORT_TOTAL_STRATUM_UNIQUE_VESSELS",
    "PORT_TOTAL_UNIQUE_VESSELS",
    "TOTAL_STRATUM_UNLOADS", 
    "TOTAL_STRATUM_UNIQUE_VESSELS",
    "TOTAL_UNLOADS",
    "TOTAL_UNIQUE_VESSELS"
  )])
  
  
  nvdp_df <- nvdp_df[!is.na(nvdp_df$ESTRATO_RIM), ]
  
  nvdp_df <- nvdp_df[!(nvdp_df$ESTRATO_RIM %in% wrong_stratums), ]
  
  return(nvdp_df)
  
}




