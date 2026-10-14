#### ---- Global variables used on the script ---- ####

#' Description:
#'  Name of the full path of the files

path_files <- list.files(getwd(), recursive = TRUE, full.names = TRUE)

#' Description:
#'  Name of the columns needed to work with the nvdp file

base_columns_nvdp <- c("IDMAREA", "METIER_IEO", "METIER_DCF", "TRIM", 
                       "MES", "LOCODE", "LABORATORIO", "ANYO", "COD_BUQUE")

#' Description:
#'  Data frame where the month name is related it's correspondet number


table_num_month <- data.frame(MES = c(1:12), 
                              MONTH = c("ENERO", "FEBRERO", "MARZO", 
                                        "ABRIL", "MAYO", "JUNIO", 
                                        "JULIO", "AGOSTO", "SEPTIEMBRE", 
                                        "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"))


months_ordered <- c("ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", 
                      "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE")
  
  
table_num_month$MONTH <- factor(table_num_month$MONTH, 
                                  levels = months_ordered)
  
#' Description:
#'  Stratums on nvdp not useful for the study
  
wrong_stratums <- c("RECSP", "SIN-METIER", "NO_ASIG", "NO_ICES")

#' Description:
#'  Filter columns for sampling analysis

cols_samp_analysis <- list(
                          STRATUM_RIM = c(
                                          "ESTRATO_RIM", 
                                          "MES", 
                                          "MONTHLY_SAMPLES", 
                                          "TOTAL_MONTHLY_SAMPLES", 
                                          "TOTAL_STRATUM_SAMPLES",
                                          "TOTAL_SAMPLES"
                                          ),
                          PORT_STRATUM_RIM = c(
                                              "ESTRATO_RIM", 
                                              "MES", 
                                              "PORT_MONTHLY_SAMPLES",
                                              "PORT_TOTAL_MONTHLY_SAMPLES",
                                              "PORT_TOTAL_STRATUM_SAMPLES", 
                                              "PORT_TOTAL_SAMPLES"
                                               ),
                          STRATUM_NVDP = c(
                                          "ESTRATO_RIM", 
                                          "TOTAL_STRATUM_UNLOADS", 
                                          "TOTAL_UNLOADS"
                                          ),
                          PORT_STRATUM_NVDP = c(
                                                "ESTRATO_RIM", 
                                                "PORT_TOTAL_STRATUM_UNLOADS", 
                                                "PORT_TOTAL_UNLOADS"
                                               ),
                          VESSELS_RIM = c(
                                          "ESTRATO_RIM", 
                                          "TOTAL_STRATUM_VESSELS_SAMPLED", 
                                          "TOTAL_VESSELS_SAMPLED"
                                         ),
                          PORT_VESSELS_RIM = c(
                                              "ESTRATO_RIM",
                                              "PORT_TOTAL_STRATUM_VESSELS_SAMPLED",
                                              "PORT_TOTAL_VESSELS_SAMPLED"
                                              ),
                          VESSELS_NVDP = c(
                                          "ESTRATO_RIM", 
                                          "TOTAL_STRATUM_UNIQUE_VESSELS", 
                                          "TOTAL_UNIQUE_VESSELS"
                                          ),
                          PORT_VESSELS_NVDP = c(
                                          "ESTRATO_RIM", 
                                          "PORT_TOTAL_STRATUM_UNIQUE_VESSELS", 
                                          "PORT_TOTAL_UNIQUE_VESSELS"
                                          )
                          )



