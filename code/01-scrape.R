
# setup -------------------------------------------------------------------

# source packages
library(ahhray) # devtools::install_github("club-cooking/ahhray")
library(jsonlite)
library(dplyr)
library(tidyr)
library(purrr)
library(furrr)
library(glue)
library(yaml)

# get local functions
source("utils/functions.R")

# get months for lineups
month_config <- read_yaml("config/month-config.yml")
months <- seq.Date(
  as.Date(month_config$start_date), as.Date(month_config$end_date), by = "1 month"
)

# get clubs ---------------------------------------------------------------

clubs <- ra_get_region_clubs(ai = 13, include_closed = TRUE)
write_json(clubs$clubs, path = "data-raw/clubs.json")

# get events --------------------------------------------------------------

future_map(clubs$club_id, possibly(ra_get_club_events, NA_real_)) %>%
  write_json(path = "data-raw/events.json")

# get club lineups --------------------------------------------------------

# get events data
events <- read_json("data/events.json", simplifyVector = TRUE)

# get lineups x month -----------------------------------------------------

future_map(
  months, function(x) {

    if (file.exists(glue("data-raw/lineups-month/{x}.json"))) return()

    lineups <- ra_get_region_events(region_code = "uk/london", start_date = x)

    write_json(lineups, path = glue("data-raw/lineups-month/{x}.json"))

    lineups
  }
)
