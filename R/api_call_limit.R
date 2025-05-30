#' Title API call limit checker  with quota
#'
#' @param user_id  unique identifier for the user
#' @param hours number of hours for the rolling window
#' @param quota maximum number of allowed request for the window
#' @param log_path path to access the log csv file
#'
#' @returns throws error if the user exceed limit
#' @export
check_user_limit <- function(user_id, hours=24, quota=1,
                             log_path = file.path(".", "user_access_log.csv")){

  now <- Sys.time()

  # initialise the log file
  if(!file.exists(log_path)){

    log <- data.frame(user_id=character(), timestamp = as.POSIXct(character()))
  } else {
    log <- read.csv(log_path, stringsAsFactors = FALSE)
    log$timestamp <- as.POSIXct(log$timestamp, tz="UTC")
  }

  # filter the log file for the user within the last hours
  user_logs <- log[log$user_id == user_id]
  recent_logs <- user_logs[difftime(now, user_log$timestamp, units="hours")<=hours,]

  # check if the quota has exceeded

  if (nrow(recent_logs)>quota){
    next_allowed <- min(recent_logs$timestamp) + hours *3600
    wait_time <- round(as.numeric(difftime(next_allowed, now, units = "hours")),2)
    stop(paste("API request limit reached. Try again in", wait_time, "hour(s)."))
  }

  # log the new access
  log <- rbind(log, data.frame(user_id=user_id, timestamp=now))
  write.csv(log, log_path, row.names = FALSE)
}





