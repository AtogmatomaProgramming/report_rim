#' Description:
#'  Function to proccess according needed data the rim file
#'
#' @param df rim's dataframe


process_rim_df <- function(df, work_cities = cities, year_to_filter = specific_year) {
  
  # 1. Aseguramos que las comparaciones sean entre cadenas de texto (character)
  target_year   <- as.character(year_to_filter)
  df_years      <- as.character(df$YEAR)
  df_ports      <- trimws(as.character(df$PUERTO)) # trimws elimina espacios en blanco indeseados
  target_cities <- trimws(as.character(work_cities))
  
  # 2. Filtrado inicial robusto
  mask <- (df_ports %in% target_cities) & (df_years == target_year)
  rim_df <- df[mask, ]
  
  # Control de seguridad: Si no hay filas que coincidan, nos avisa con un mensaje descriptivo
  if (nrow(rim_df) == 0) {
    warning(
      "El filtrado devolvió 0 filas.\n",
      " - Año buscado: '", target_year, "' | Años en el DF: ", paste(unique(df_years), collapse = ", "), "\n",
      " - Puertos buscados: ", paste(target_cities, collapse = ", "), " | Puertos en el DF: ", paste(head(unique(df_ports), 5), collapse = ", ")
    )
    return(rim_df)
  }
  
  # 3. Cálculo de métricas
  rim_df <- rim_df %>% 
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
    mutate(PORT_MONTHLY_SAMPLES = n_distinct(COD_ID)) %>% 
    ungroup() # Importante: desagrupar al final
  
  # 4. Selección de columnas únicas
  cols_to_keep <- c("PUERTO", "ESTRATO_RIM", "MES",
                    "PORT_TOTAL_SAMPLES", "PORT_MONTHLY_SAMPLES", 
                    "PORT_TOTAL_MONTHLY_SAMPLES", "PORT_TOTAL_STRATUM_SAMPLES",
                    "PORT_TOTAL_STRATUM_VESSELS_SAMPLED", "PORT_TOTAL_VESSELS_SAMPLED", 
                    "MONTHLY_SAMPLES", "TOTAL_MONTHLY_SAMPLES",
                    "TOTAL_STRATUM_SAMPLES", "TOTAL_STRATUM_VESSELS_SAMPLED",
                    "TOTAL_SAMPLES", "TOTAL_VESSELS_SAMPLED")
  
  rim_df <- unique(rim_df[, cols_to_keep])
  
  return(rim_df)
}

