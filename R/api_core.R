#source("R/data_loader.R")
#source("R/api_limit.R")
#source("R/utils.R")

source(file.path("..", "R", "data_loader.R"))
source(file.path("..", "R", "api_call_limit.R"))
source(file.path("..", "R", "utils.R"))

# Load and cache the data
data_list <- load_wheat_data()

#' Title Get phenotype
#'
#' @param user_id User identifier
#' @param format Output format (json or csv)
#' @param columns Comma-separated list of columns to return
#' @param rows Comma-separated list of row names (e.g., Line1,Line2)
#' @param limit
#' @param offset
#'
#' @returns
#' @export
#' @get /phenotypes
function(user_id, format="json", columns=NULL, rows=NULL, limit=100, offset=0){

  check_user_limit(user_id)
  df <- process_and_validate_dataset(data_list$phenotype, "phenotype")
  format_output(df, format)
}

#' Get genotype Data
#' @get /genotypes
function(user_id, format="json", columns=NULL, rows=NULL, limit=100, offset=0){

  check_user_limit(user_id)
  df <- process_and_validate_dataset(data_list$genotype, "genotype")
  format_output(df, format)
}

#' Get marker Data
#' @get /marker
function(user_id, format="json", columns=NULL, rows=NULL, limit=100, offset=0){

  check_user_limit(user_id)
  df <- process_and_validate_dataset(data_list$marker, "marker")
  format_output(df, format)
}


#' Get full wheat data
#' @get /all_data
function(user_id, format="json", columns=NULL, rows=NULL, limit=100, offset=0){

  check_user_limit(user_id)
  combined <- list(
    genotypes = data_list$genotype,
    phenotypes = data_list$phenotype,
    marker = data_list$marker
  )
  combined
}
