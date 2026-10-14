
## ---- Variables de texto dinámicas ----
years_text <- if (length(years) > 1) {
  paste(paste(years[-length(years)], collapse = ", "), "y", years[length(years)])
} else {
  years
}

# Mapeo según la zona de influencia (puedes ampliar con más códigos si usas otros)
area_muestreo_text <- switch(influence_area,
                             "AC" = "Asturias - Cantabria",
                             "GN" = "Galicia Norte",
                             "GS" = "Galicia Sur",
                             "GC" = "Golfo de Cádiz")

# Mapeo según la zona de influencia (puedes ampliar con más códigos si usas otros)
area_region <- switch(influence_area,
                      "AC" = "Asturias y Cantabria",
                      "GN" = "Galicia",
                      "GS" = "Galicia",
                      "GC" = "Cádiz")


