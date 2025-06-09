library(jsonlite)
library(readr)
library(arrow)


log_message <- function(msg){

  cat(paste0("[", Sys.time(),"]", msg,"\n"))

}


#' Duplicate checks
#'
#' @param df name of the dataframe

remove_duplicates<- function(df){
  df[!duplicated(df), ,drop=FALSE]
}

#' data validation
#'
#' @param df name of the dataframe
#' @param df_name name the dataframe

validate_dataframe_structure <- function(df, df_name) {
  #if (!is.data.frame(df)) stop(paste(df_name, "must be a data frame."))
  if (nrow(df) == 0) stop(paste(df_name, "has 0 rows."))
  if (ncol(df) == 0) stop(paste(df_name, "has 0 columns."))
  if (is.null(rownames(df))) stop(paste(df_name, "must have rownames."))
  log_message(paste(df_name, "structure is valid."))
}



#' Title Check missing value
#'
#' @param df name of the dataframe
#' @param df_name name the dataframe

report_missing_values <- function(df, df_name) {
  na_count <- sum(is.na(df))
  if (na_count > 0) {
    log_message(paste("Warning:", df_name, "has", na_count, "missing values."))
  } else {
    log_message(paste(df_name, "has no missing values."))
  }
}


#' Title process and validation
#'
#' @param df name of the dataframe
#' @param df_name name the dataframe

process_and_validate_dataset <- function(df, df_name) {
  validate_dataframe_structure(df, df_name)
  df <- remove_duplicates(df)
  report_missing_values(df, df_name)
  return(df)
}


format_output <- function(data, format = "json") {
  format <- tolower(format)

  if (format == "json") {
    # JSON output as string
    return(toJSON(data, pretty = TRUE, auto_unbox = TRUE))

  } else if (format == "csv") {
    # CSV output as string
    tmp <- tempfile(fileext = ".csv")
    write_csv(data, tmp)
    return(readr::read_file(tmp))

  } else if (format == "parquet") {
    # Parquet output as raw binary (to be returned as a file)
    tmp <- tempfile(fileext = ".parquet")
    write_parquet(data, sink = tmp)
    return(readBin(tmp, what = "raw", n = file.info(tmp)$size))

  } else {
    stop("Unsupported format. Choose from 'json', 'csv', or 'parquet'.")
  }
}
