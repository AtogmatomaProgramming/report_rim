
#' Description:
#'  Function to convert the number of the month to
#'  its name
#'
#' @param df rim or nvdp dataframe
#' @param master_month dataframe with the relation between number and month name


convert_month_number_name <- function(df, master_month){
  
  df <- merge(
    df,
    master_month, 
    all.x = TRUE
  )
  
  df$MES <- df$MONTH
  
  df$MONTH <- NULL
  
  return(df)
  
}