#' Description:
#'  Function to proccess according needed data the rim file
#'
#' @param df rim's dataframe


process_rim_df <- function(df){
  
  
  rim_df <- df[df$PUERTO %in% cities & 
                df$YEAR == specific_year, ] %>% 
    mutate(TOTAL_SAMPLES = n_distinct(COD_ID),
           TOTAL_VESSELS_SAMPLED = n_distinct(COD_BARCO)) %>% 
    group_by(ESTRATO_RIM) %>% 
    mutate(TOTAL_STRATUM_SAMPLES = n_distinct(COD_ID),
           TOTAL_STRATUM_VESSELS_SAMPLED = n_distinct(COD_BARCO)) %>%
    group_by(MES) %>% 
    mutate(TOTAL_MONTHLY_SAMPLES = n_distinct(COD_ID)) %>% 
    group_by(ESTRATO_RIM, MES) %>% 
    mutate(MONTHLY_SAMPLES = n_distinct(COD_ID)) %>% 
    group_by(PUERTO) %>% 
    mutate(PORT_TOTAL_SAMPLES = n_distinct(COD_ID),
           PORT_TOTAL_VESSELS_SAMPLED = n_distinct(COD_BARCO)) %>%
    group_by(PUERTO, ESTRATO_RIM) %>% 
    mutate(PORT_TOTAL_STRATUM_SAMPLES = n_distinct(COD_ID), 
           PORT_TOTAL_STRATUM_VESSELS_SAMPLED = n_distinct(COD_BARCO)) %>% 
    group_by(PUERTO, MES) %>% 
    mutate(PORT_TOTAL_MONTHLY_SAMPLES = n_distinct(COD_ID)) %>% 
    group_by(PUERTO, ESTRATO_RIM, MES) %>% 
    mutate(PORT_MONTHLY_SAMPLES = n_distinct(COD_ID)) 
  
  rim_df <- unique(rim_df[, c("PUERTO", "ESTRATO_RIM", "MES",
                              "PORT_TOTAL_SAMPLES",
                              "PORT_MONTHLY_SAMPLES", 
                              "PORT_TOTAL_MONTHLY_SAMPLES", 
                              "PORT_TOTAL_STRATUM_SAMPLES",
                              "PORT_TOTAL_STRATUM_VESSELS_SAMPLED",
                              "PORT_TOTAL_VESSELS_SAMPLED", 
                              "MONTHLY_SAMPLES", 
                              "TOTAL_MONTHLY_SAMPLES",
                              "TOTAL_STRATUM_SAMPLES",
                              "TOTAL_STRATUM_VESSELS_SAMPLED",
                              "TOTAL_SAMPLES",
                              "TOTAL_VESSELS_SAMPLED")])
  
  return(rim_df)
  
}

