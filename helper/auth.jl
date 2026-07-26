using PythonCall
using DataFrames

function get_bq_client(json_key_path::String, project_id::String)
    !isfile(json_key_path) && error("File kredensial tidak ditemukan: $json_key_path")
    
    bigquery = pyimport("google.cloud.bigquery")
    service_account = pyimport("google.oauth2.service_account")
    
    credentials = service_account.Credentials.from_service_account_file(json_key_path)
    return bigquery.Client(project=project_id, credentials=credentials)
end

function run_query(client, sql_query::String)
    query_job = client.query(sql_query)
    results_df = query_job.to_dataframe()
    
    return DataFrame(pyconvert(Dict, results_df.to_dict(orient="list")))
end