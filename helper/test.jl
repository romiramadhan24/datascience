include("/workspaces/datascience/helper/auth_bigquery.jl")

project_id = "database-collection-503407"
dataset_id = "dataset"
table_name = "worldenergy"

# Cukup masukkan project_id, kredensial otomatis dibaca dari secret GCP_KEY_JSON
client = get_bq_client(project_id)

prql = """
prql target:sql.bigquery

from `$project_id.$dataset_id.$table_name`
take 5
"""

df = run_prql(client, prql)
println(df)