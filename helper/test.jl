include("/workspaces/datascience/helper/auth.jl")
using .BigQueryHelper

# 1. Konfigurasi
const JSON_KEY   = "/workspaces/datascience/bigquery.json"
const PROJECT_ID = "database-collection-503407"
const DATASET_ID = "dataset"
const TABLE_NAME = "worldenergy"

# 2. Panggil fungsi secara eksplisit dengan nama modulnya
client = BigQueryHelper.get_bq_client(JSON_KEY, PROJECT_ID)

# 3. Jalankan Query
sql = """
    SELECT * 
    FROM $PROJECT_ID.$DATASET_ID.$TABLE_NAME 
    LIMIT 10
"""

df = BigQueryHelper.run_query(client, sql)
println(df)