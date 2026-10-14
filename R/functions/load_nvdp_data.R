#' Description:
#'  Function to import in all unique file all de nvdp working data
#'
#' @param years years of work


load_nvdp_data <- function(years, path_files) {
  
  # 1. Generamos los patrones de búsqueda (ej: "nvdp/2020", "nvdp/2021")
  patterns <- file.path("nvdp", years)
  
  # 2. Filtramos de 'path_files' solo los archivos que coinciden con los años
  # Usamos paste con collapse = "|" para hacer un grep vectorizado directo
  nvdp_paths <- path_files[grep(paste(patterns, collapse = "|"), path_files)]
  
  # Control de seguridad: Si no hay coincidencias, avisamos antes de romper el código
  if (length(nvdp_paths) == 0) {
    stop("No se encontraron archivos en 'path_files' para los años especificados.")
  }
  
  # 3. OPTIMIZACIÓN: Leemos, renombramos y filtramos en UNA SOLA PASADA
  # Usamos lapply para garantizar que el resultado sea siempre una lista de data.frames
  nvdp_files <- lapply(nvdp_paths, function(path) {
    
    df <- read.csv(path, stringsAsFactors = FALSE)
    
    # Normalización de nombres de columnas
    colnames(df)[grep("TRIM", colnames(df))]  <- "TRIM"
    colnames(df)[grep("BUQUE", colnames(df))] <- "COD_BUQUE"
    
    # Seleccionamos solo las columnas base (drop = FALSE evita que se convierta en vector si es 1 col)
    df <- df[, base_columns_nvdp, drop = FALSE]
    
    return(df)
  })
  
  # 4. Unificación de los data.frames
  nvdp_merged <- do.call(rbind, nvdp_files)
  
  # 5. Cruce de tablas (Merges en R base)
  nvdp_merged <- merge(nvdp_merged, metier_stratum_port, all.x = TRUE)
  nvdp_merged <- merge(nvdp_merged, sapmuebase::puerto, all.x = TRUE)
  
  # 6. Filtrado y transformaciones finales
  nvdp_merged <- nvdp_merged[nvdp_merged$LABORATORIO != "AZTI", ]
  nvdp_merged$ANYO <- as.character(nvdp_merged$ANYO)
  
  nvdp_merged <- convert_month_number_name(nvdp_merged, table_num_month)
  
  return(nvdp_merged)
  
}


