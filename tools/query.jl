include("/workspaces/datascience/helper/auth_bigquery.jl")
using Statistics, Dates

df_mentah = q("SELECT * FROM `$db.dataset.labour_statistics` LIMIT 100")