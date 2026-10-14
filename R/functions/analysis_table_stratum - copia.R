
#' Description:
#'  Function to obtain the table with the analysis of sampled and unload
#'  trips according month and ESTRATO_RIM
#'
#' @param rim_df rim's dataframe
#' @param nvdp_df nvdp's dataframe
#' @param ports vector with the study port. Could be one or more
#' @param stratums_sampled vector with all the ESTRATO_RIM sampled on 
#' study region


analysis_table_stratum <- function(ports,
                                   rim_df, 
                                   nvdp_df, 
                                   stratums_sampled,
                                   vessels = FALSE){


  if(vessels){
    
    if(length(ports) > 1){
      
      columns_filter_rim <- cols_samp_analysis[["VESSELS_RIM"]]
      
      columns_filter_nvdp <- cols_samp_analysis[["VESSELS_NVDP"]]
      
    } else {
      
      columns_filter_rim <- cols_samp_analysis[["PORT_VESSELS_RIM"]]
      
      columns_filter_nvdp <- cols_samp_analysis[["PORT_VESSELS_NVDP"]]
      
    }
    
  } else {
    
    if(length(ports) > 1){
      
      columns_filter_rim <- cols_samp_analysis[["STRATUM_RIM"]]
      
      columns_filter_nvdp <- cols_samp_analysis[["STRATUM_NVDP"]]
      
    } else {
      
      columns_filter_rim <- cols_samp_analysis[["PORT_STRATUM_RIM"]]
      
      columns_filter_nvdp <- cols_samp_analysis[["PORT_STRATUM_NVDP"]]
      
    }
    
    
  }
  
  
  
  rim_df <- rim_df[rim_df$PUERTO %in% ports, columns_filter_rim]
  
  nvdp_df <- nvdp_df[nvdp_df$PUERTO %in% ports, columns_filter_nvdp]
  
  colnames(rim_df) <- gsub("PORT_", "", colnames(rim_df), ignore.case = TRUE)
  
  colnames(nvdp_df) <- gsub("PORT_", "", colnames(nvdp_df), ignore.case = TRUE)
  
  colnames(rim_df) <- gsub("VESSELS_", "", colnames(rim_df), ignore.case = TRUE)
  
  colnames(nvdp_df) <- gsub("VESSELS_", "", colnames(nvdp_df), ignore.case = TRUE)
  
  rim_df <- unique(rim_df[, c(
    "ESTRATO_RIM", 
    "MES", 
    "MONTHLY_SAMPLES", 
    "TOTAL_MONTHLY_SAMPLES", 
    "TOTAL_STRATUM_SAMPLES",
    "TOTAL_SAMPLES"
  )])
  
  
  nvdp_df <- unique(nvdp_df[, c(
    "ESTRATO_RIM", 
    "TOTAL_STRATUM_UNLOADS", 
    "TOTAL_UNLOADS"
  )])
  
  
  rim_df <- merge(
    rim_df,
    nvdp_df,
    all.x = TRUE
  )
  
  
  rim_df <- 
    rim_df %>% 
    mutate(TOTAL_COBERTURE = 
             round(
               (TOTAL_SAMPLES/TOTAL_UNLOADS)*100, 
               digits = 2)
    ) %>% 
    group_by(ESTRATO_RIM) %>% 
    mutate(STRATUM_COBERTURE = 
             round(
               (TOTAL_STRATUM_SAMPLES/TOTAL_STRATUM_UNLOADS)*100, 
               digits = 2)
    )
  
  
  ## SUBSET TOTAL VALUES BY STRATUM
  
  totals_stratum <- unique(rim_df[, c(
    "ESTRATO_RIM", 
    "TOTAL_STRATUM_SAMPLES", 
    "TOTAL_STRATUM_UNLOADS",
    "STRATUM_COBERTURE"
  )])
  
  totals <- unique(rim_df[, c("TOTAL_SAMPLES", "TOTAL_UNLOADS", "TOTAL_COBERTURE")])
  
  totals$ESTRATO_RIM <- "TOTALES"
  
  colnames(totals)[grep("TOTAL_SAMPLES", colnames(totals))] <- "TOTAL_STRATUM_SAMPLES"
  colnames(totals)[grep("TOTAL_UNLOADS", colnames(totals))] <- "TOTAL_STRATUM_UNLOADS"
  colnames(totals)[grep("TOTAL_COBERTURE", colnames(totals))] <- "STRATUM_COBERTURE"
  
  totals_stratum <- rbind(totals_stratum, totals)
  
  
  ## SUBSET TOTAL VALUES BY MONTH
  
  totals_month <- unique(rim_df[, c("MES", "TOTAL_MONTHLY_SAMPLES")])
  
  totals_month <- 
    totals_month %>% 
    pivot_wider(names_from = MES, 
                values_from = TOTAL_MONTHLY_SAMPLES)
  
  totals_month$ESTRATO_RIM <- "TOTALES"
  
  
  ## SUBSET VALUES BY MONTH
  
  month_data <- unique(rim_df[, c("ESTRATO_RIM", "MES", "MONTHLY_SAMPLES")]) %>% 
    pivot_wider(names_from = MES, 
                values_from = MONTHLY_SAMPLES, 
                values_fill = 0)
  
  month_data <- rbind(month_data, totals_month)
  
  ## CREATE FINAL TABLE
  
  final_table <- merge(month_data, 
                       totals_stratum,
                       all.x = TRUE)
  
  
  ## ADD ZERO VALUES FOR THE REST OF ESTRATO_RIM IN CASE THERE ARE NOT
  ## SAMPLES
  
  present_stratums <- unique(final_table$ESTRATO_RIM) 
  
  if(length(stratums_sampled) != length(present_stratums)){
    
    non_present_stratums <- stratums_sampled[!(stratums_sampled %in% present_stratums)]
    
    stratums <- data.frame(ESTRATO_RIM = non_present_stratums)
    
    final_table <- merge(
                        final_table,
                        stratums, 
                        all = TRUE
                        )
    
    
    final_table[is.na(final_table)] <- 0
    
  }
  
  


  ## ORDER IN ALPHABETICH WAY THE VALUES of STRATO RIM AND PUT TOTALS IN THE FINAL
  
  final_table <- adjust_total_value(final_table)
  
  
  ## CHECK IF WE HAVE ALL THE MONTH PRESENT
  
  present_months <- colnames(final_table)
  
  missing_months <- months_ordered[!(months_ordered %in% present_months)]
  
  
  if (length(missing_months) > 0) {
    final_table[missing_months] <- 0
  }
  
  
  ## REORDER COLUMNS
  
  final_table <- final_table[, c(
                                "ESTRATO_RIM",
                                months_ordered,
                                "TOTAL_STRATUM_SAMPLES", 
                                "TOTAL_STRATUM_UNLOADS",
                                "STRATUM_COBERTURE"
                                )]
  
  
  return(final_table)

  
}
