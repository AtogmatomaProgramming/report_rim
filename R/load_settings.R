#### ---- Script to load work scripts inside the R folder ---- ####

## ---- Scripts from function directory ---- ##

source(file.path(getwd(), "R", "functions", "import_libraries.R"))
source(file.path(getwd(), "R", "functions", "draw_map.R"))
source(file.path(getwd(), "R", "functions", "load_nvdp_data.R"))
source(file.path(getwd(), "R", "functions", "load_rim_data.R"))
source(file.path(getwd(), "R", "functions", "process_rim_df.R"))
source(file.path(getwd(), "R", "functions", "process_nvdp_df.R"))
source(file.path(getwd(), "R", "functions", "adjust_total_value.R"))
source(file.path(getwd(), "R", "functions", "convert_month_number_name.R"))
source(file.path(getwd(), "R", "functions", "analysis_table_stratum.R"))

## ---- Scripts from settings directory ---- ##

source(file.path(getwd(), "R", "settings", "libraries.R"))
source(file.path(getwd(), "R", "settings", "masters.R"))
source(file.path(getwd(), "R", "settings", "global_variables.R"))
source(file.path(getwd(), "R", "settings", "dynamic_variables.R"))