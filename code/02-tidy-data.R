
# setup -------------------------------------------------------------------

# load packages
library(jsonlite)
library(purrr)
library(furrr)
library(readr)
library(dplyr)
library(tidyr)

# get clubs data
clubs <- read_json("data-raw/clubs.json", simplifyVector = TRUE)

# get events data
events <- read_json("data-raw/events.json", simplifyVector = TRUE)
events <- events[sapply(events, length) == 2] # remove missing records

# get lineups x month
lineups_month_files <- list.files("data-raw/lineups-month", full.names = TRUE)
lineups_month <- future_map(lineups_month_files, read_json, simplifyVector = TRUE)

# get lineups x club
lineups_club_files <- list.files("data-raw/lineups-club", full.names = TRUE)
lineups_club <- future_map_dfr(lineups_club_files, read_json, simplifyVector = TRUE)

# clean data --------------------------------------------------------------

# create clubs dataframe
clubs_df <- clubs %>%
  mutate_all(unlist) %>%
  select(club_id, everything())

# create events dataframe
events_df <- future_map_dfr(events, function(x){
  df <- x[["events"]]
  df$club_id <- as.numeric(x[["club_id"]])
  df
})
events_df <- events_df[!sapply(events_df$event_id, is.null), ] # remove bad events
events_df <- mutate_all(events_df, unlist)
events_df$event_date <- as.Date(events_df$event_date)

# create lineups x month dataframe
lineups_month_df <- future_map_dfr(lineups_month, function(x){
  df <- x[["events"]]
  df
})

# remove bad events
lineups_month_df <- lineups_month_df[!sapply(lineups_month_df$artists, length) == 0, ]
lineups_month_df <- lineups_month_df[!sapply(lineups_month_df$artists, length) == 0, ]
lineups_month_df <- lineups_month_df[!sapply(lineups_month_df$event_date, length) == 0, ]
lineups_month_df <- lineups_month_df[!sapply(lineups_month_df$venue_id, length) == 0, ]
lineups_month_df <- lineups_month_df %>%
  mutate(across(event_id:venue_name, ~unlist(.x)))

# create artist-level df
artists <- lineups_month_df[sapply(lineups_month_df$artists, length) == 2, ] %>% # remove bad events
  unnest(artists) %>%
  mutate(across(c(artist_name, artist_id), ~unlist(.x))) %>%
  select(artist_id, artist_name, event_id, club_id=venue_id)

# create promoter-level df
promoters <- lineups_month_df[sapply(lineups_month_df$promoters, length) == 2, ] %>% # remove bad events
  unnest(promoters) %>%
  mutate(across(c(promoter_name, promoter_id), ~unlist(.x))) %>%
  select(promoter_id, promoter_name, event_id, club_id=venue_id)

# export ------------------------------------------------------------------

write_csv(clubs_df, "data/clubs.csv")
write_csv(events_df, "data/events.csv")
write_csv(artists, "data/artists.csv")
write_csv(promoters, "data/promoters.csv")
