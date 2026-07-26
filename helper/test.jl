include("/workspaces/datascience/helper/auth.jl")

json_key   = "/workspaces/datascience/bigquery.json"
project_id = "database-collection-503407"
dataset_id = "dataset"
table_name = "worldenergy"

client = get_bq_client(json_key, project_id)

sql = """
    SELECT * 
    FROM `$project_id.$dataset_id.$table_name` 
    LIMIT 10
"""

df = run_query(client, sql)
println(df)