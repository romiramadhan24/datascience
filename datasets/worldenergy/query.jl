include("/workspaces/datascience/helper/auth_bigquery.jl")
using Statistics, Dates

# Jalankan kueri ringkas dari BigQuery
df_mentah = q("SELECT * FROM `$db.dataset.labour_statistics` LIMIT 100")