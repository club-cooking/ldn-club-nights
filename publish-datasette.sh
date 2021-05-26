cd data
csvs-to-sqlite clubs.csv events.csv artists.csv promoters.csv ldn-club-nights.db
gcloud components install beta
gcloud config set run/region europe-west2
gcloud config set project club-cooking-datasette
datasette publish cloudrun ldn-club-nights.db --service ldn-club-nights -m ../metadata.json
