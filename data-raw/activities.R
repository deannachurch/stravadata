# ACTIVITIES.R
#
# This script downloads Strava activity data from the Strava API.
#
# Ben Davies
# February 2020


# Initialisation ----

library(dplyr)
library(httr)
library(lubridate)
library(jsonlite)
library(readr)

cache_dir <- 'data-raw/activities/'
if (!dir.exists(cache_dir)) dir.create(cache_dir)


# API requests ----

source('data-raw/oauth-token.R')

activities_list <- list()
i <- 1
done <- F
while (!done) {
  req <- GET(
    url = 'https://www.strava.com/api/v3/athlete/activities',
    config = token,
    query = list(per_page = 200, page = i)
  )
  stop_for_status(req)
  activities_list[[i]] <- fromJSON(content(req, as = 'text'), flatten = T)
  if (length(content(req)) < 200) {
    done <- T
  } else {
    i <- i + 1
  }
}

missing_ids <- setdiff(
  unlist(lapply(activities_list, function(x) x$id)),
  as.numeric(sub('[.]json', '', list.files(cache_dir)))
)

for (id in missing_ids) {
  req <- GET(
    url = paste0('https://www.strava.com/api/v3/activities/', id),
    config = token,
    query = list(include_all_efforts = "TRUE")
  )
  stop_for_status(req)
  req %>%
    content(as = 'text') %>%
    prettify() %>%
    write_file(paste0(cache_dir, id, '.json'))
}


# Data export ----

cache_list <- lapply(dir(cache_dir, full.names = T), read_json)

null2na <- function(x) ifelse(!is.null(x), x, NA)

activities <- cache_list %>%
  lapply(
    function(x) {
      tibble(
        id           = x$id,
        name         = x$name,
        type         = x$type,
        workout_type = null2na(x$workout_type),
        start_time   = as_datetime(x$start_date_local),
        timezone     = x$timezone,
        distance     = x$distance,
        time_moving  = x$moving_time,
        time_total   = x$elapsed_time,
        elev_gain    = x$total_elevation_gain,
        mean_hr      = null2na(x$average_heartrate),
        max_hr       = null2na(x$max_heartrate),
        mean_cadence = null2na(x$average_cadence),
        n_athletes   = x$athlete_count,
        exertion     = null2na(x$perceived_exertion)
      )
    }
  ) %>%
  bind_rows() %>%
  arrange(id)

write_csv(activities, 'data-raw/activities.csv')

if (!dir.exists('data')) dir.create('data/')
save(activities, file = 'data/activities.rda', version = 2, compress = 'bzip2')


# Session info ----

bldr::save_session_info('data-raw/activities.log')
