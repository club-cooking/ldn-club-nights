cd data
csvs-to-sqlite clubs.csv events.csv artists.csv promoters.csv ldn-venues.db
gcloud components install beta
gcloud config set run/region europe-west2
gcloud config set project club-cooking-datasette
datasette publish cloudrun ldn-venues.db --service ldn-venues -m ../metadata.json