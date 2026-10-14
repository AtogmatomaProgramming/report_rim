#' Description:
#'  Function to import in all unique file all de rim working data
#'
#' @param years years of work

load_rim_data <- function(years) {
  
  # 1. Construimos directamente las rutas de las carpetas de cada año
  # Ej: "rim/2020", "rim/2021" (o file.path("rim", years))
  target_dirs <- file.path("data", "rim", years)
  
  # Filtramos solo los directorios que realmente existen para evitar errores
  valid_dirs <- target_dirs[dir.exists(target_dirs)]
  
  if (length(valid_dirs) == 0) {
    stop("No se encontró ningún directorio válido para los años especificados en la carpeta 'rim'.")
  }
  
  # 2. Leemos los archivos de cada carpeta de forma limpia con lapply
  rim_files_list <- lapply(valid_dirs, function(d) {
    filenames <- list.files(d, full.names = FALSE)
    
    # Si la carpeta está vacía, retornamos NULL
    if (length(filenames) == 0) return(NULL)
    
    # ¡CORRECCIÓN CLAVE AQUÍ!
    # Usamos 'file' y 'path' para que coincidan con los nombres reales de importRIMLengths
    data_per_dir <- mapply(
      importRIMLengths, 
      file = filenames, 
      path = d, 
      SIMPLIFY = FALSE
    )
    
    do.call(rbind, data_per_dir)
  })
  
  # Eliminamos posibles elementos NULL (si una carpeta estaba vacía)
  rim_files_list <- rim_files_list[!sapply(rim_files_list, is.null)]
  
  if (length(rim_files_list) == 0) {
    stop("No se pudieron cargar archivos de los directorios indicados.")
  }
  
  # 3. Unificamos todos los años en un único data.frame
  rim_merged <- do.call(rbind, rim_files_list)
  
  # 4. Ajustes finales en R base
  rim_merged$YEAR <- as.character(rim_merged$YEAR)
  
  rim_merged <- convert_month_number_name(rim_merged, table_num_month)
  
  return(rim_merged)
}


