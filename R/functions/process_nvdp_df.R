#' Description:
#'  Function to proccess the nvdp's dataframe with the 
#'  needed values
#'
#' @param df nvdp's dataframe


process_nvdp_df <- function(df, 
                            work_cities = cities, 
                            year_to_filter = specific_year, 
                            excluded_stratums = wrong_stratums) {
  
  # 1. Siguraduen a character amin dagiti suhetibo nga ad-aduen tapno awan ti mismatch
  target_year   <- as.character(year_to_filter)
  
  # Check nu DAYTOY ket ANYO wenno YEAR ti nagan ti kolumna iti NVDP
  year_col      <- if ("ANYO" %in% colnames(df)) "ANYO" else "YEAR"
  df_years      <- as.character(df[[year_col]])
  
  df_ports      <- trimws(as.character(df$PUERTO))
  target_cities <- trimws(as.character(work_cities))
  
  # 2. Sililagda a panagfiltrar
  mask <- (df_ports %in% target_cities) & (df_years == target_year)
  nvdp_df <- df[mask, ]
  
  # Control check: Nu awan ti naiload, mangted iti pakdaar a mangipakita nu apay
  if (nrow(nvdp_df) == 0) {
    warning(
      "Ti process_nvdp_df ket nagsubli iti 0 a rangtay (empty).\n",
      " - Tawen a maipapaaut: '", target_year, "' | Taawen nga adda iti NVDP: ", paste(unique(df_years), collapse = ", "), "\n",
      " - Puerta a maipapaaut: ", paste(target_cities, collapse = ", "), " | Puerta nga adda iti NVDP: ", paste(head(unique(df_ports), 5), collapse = ", ")
    )
    return(nvdp_df)
  }
  
  # 3. Panagkalkula ti metrikas babaen ti dplyr
  nvdp_df <- nvdp_df %>% 
    mutate(
      TOTAL_UNLOADS = n_distinct(IDMAREA),
      TOTAL_UNIQUE_VESSELS = n_distinct(COD_BUQUE)
    ) %>% 
    group_by(ESTRATO_RIM) %>% 
    mutate(
      TOTAL_STRATUM_UNLOADS = n_distinct(IDMAREA),
      TOTAL_STRATUM_UNIQUE_VESSELS = n_distinct(COD_BUQUE)
    ) %>% 
    group_by(PUERTO) %>% 
    mutate(
      PORT_TOTAL_UNLOADS = n_distinct(IDMAREA), 
      PORT_TOTAL_UNIQUE_VESSELS = n_distinct(COD_BUQUE)
    ) %>% 
    group_by(PUERTO, ESTRATO_RIM) %>% 
    mutate(
      PORT_TOTAL_STRATUM_UNLOADS = n_distinct(IDMAREA),
      PORT_TOTAL_STRATUM_UNIQUE_VESSELS = n_distinct(COD_BUQUE)
    ) %>% 
    ungroup() # Napateg: I-ungroup para nadalus ti agsubli a dataframe
  
  # 4. Panagpili ti uniko a kolumna
  cols_to_keep <- c(
    "PUERTO", "ESTRATO_RIM", 
    "PORT_TOTAL_STRATUM_UNLOADS", 
    "PORT_TOTAL_UNLOADS",
    "PORT_TOTAL_STRATUM_UNIQUE_VESSELS",
    "PORT_TOTAL_UNIQUE_VESSELS",
    "TOTAL_STRATUM_UNLOADS", 
    "TOTAL_STRATUM_UNIQUE_VESSELS",
    "TOTAL_UNLOADS",
    "TOTAL_UNIQUE_VESSELS"
  )
  
  nvdp_df <- unique(nvdp_df[, cols_to_keep])
  
  # 5. Ikkaten ti NA ken ti bakat ti nakasinsin nga estratos
  nvdp_df <- nvdp_df[!is.na(nvdp_df$ESTRATO_RIM), ]
  
  if (exists("excluded_stratums") && length(excluded_stratums) > 0) {
    nvdp_df <- nvdp_df[!(nvdp_df$ESTRATO_RIM %in% excluded_stratums), ]
  }
  
  return(nvdp_df)
}




