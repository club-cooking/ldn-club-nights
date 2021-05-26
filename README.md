# ldn-club-nights

Data on clubs, events and line-ups in London listed on Resident Advisor (RA) across the years 2014-2019. Last scraped mid-2020.

## data-raw

This folder contains the raw data files scraped from RA, in .json format.

## data

This folder contains the processed data files, detailed below.

### `clubs.csv`

Data on 1325 clubs in London listed on RA. 

Data dictionary:

| Column    | Description                                                                                                                                                                |
|:----------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| club_name      | The name of the club                                                                                                                                 |
| club_address   | The address of the club                                                                                                                 |
| club_id     | A numeric identifier used for the club on RA                                                                                                                                |
| club_status  | Logical; is the club open or closed |

### `events.csv`

Data on events in London listed on RA.

Data dictionary:

| Column    | Description                                                                                                                                                                |
|:----------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| club_id      | A numeric identifier used for the club on RA                                                                                                                                 |
| event_id   | A numeric identifier used for the event on RA                                                                                                               |
| event_name     | The name of the event                                                                                                                                |
| event_date  | The date of the event |

### `lineups-club.json`

Full lineup history for selected clubs.

Data dictionary:

| Column    | Description                                                                                                                                                                |
|:----------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| event_id   | A numeric identifier used for the event on RA  |
| event_name | The name of the event |
| event_date | The date of the event |
| venue_id | A numeric identifier used for the club on RA |
| venue_name | The name of the club |
| artist_name | The name of the artist |
| artist_id | A numeric identifier used for the artist on RA |
| promoter_name | The name of the promoter |
| promoter_id | A numeric identifier used for the promoter on RA |

### `lineups-month.json`

Lineups for all clubs in London in 2014-2019.

Data dictionary:

| Column    | Description                                                                                                                                                                |
|:----------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| region_code   | A identifier used for the event region on RA  |
| event_id   | A numeric identifier used for the event on RA  |
| event_name | The name of the event |
| event_date | The date of the event |
| venue_id | A numeric identifier used for the club on RA |
| venue_name | The name of the club |
| artist_name | The name of the artist |
| artist_id | A numeric identifier used for the artist on RA |
| promoter_name | The name of the promoter |
| promoter_id | A numeric identifier used for the promoter on RA |

## code

Follow numeric prefix for the correct order of running each .R script:

- `01-scrape.R`: create all raw data (`data-raw/`) files
- `02-tidy-data.R`: create final data (`data/`) files

## config

Config files to change the behaviour of the scraper, specifically the detailed event info (i.e. lineups). Edit `month-lineups-config.csv` if you want to pull line-ups for different time period.
