
#' Description:
#' 
#'  Function to put the value of TOTALES in ESTRATO_RIM's column
#'  at last position
#'
#' @param df dataframe with the value of TOTALES in ESTRATO_RIM's column
#' 
#' @note WARNING: in this case this function only can be applied 
#' to the dataframe created to view the results of the sampled and
#' unloaded trips by ESTRATO_RIM and MONTH


adjust_total_value <- function(df) {
  
  df_without_totals <- df[df$ESTRATO_RIM != "TOTALES", ] 
  
  df_without_totals <- df_without_totals[order(df_without_totals$ESTRATO_RIM), ]
  
  df_totals <- df[df$ESTRATO_RIM == "TOTALES", ]
  
  # 2. Los volvemos a pegar: primero los datos, luego el total
  df_ordered <- bind_rows(df_without_totals, df_totals)
  
  return(df_ordered)
}
