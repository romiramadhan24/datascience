module BigQueryHelper

using PythonCall
using DataFrames

export get_bq_client, run_query

"""
Membuat dan mengembalikan objek BigQuery Client.
Membutuhkan path ke file JSON Service Account.
"""
function get_bq_client(json_key_path::String, project_id::String)
    # Import modul Python
    bigquery = pyimport("google.cloud.bigquery")
    service_account = pyimport("google.oauth2.service_account")
    
    # Gunakan variabel json_key_path dari parameter fungsi
    credentials = service_account.Credentials.from_service_account_file(json_key_path)
    
    # Return client object
    return bigquery.Client(project=project_id, credentials=credentials)
end

"""
Menjalankan query SQL menggunakan client yang diberikan.
Mengembalikan hasil berupa Julia DataFrame.
"""
function run_query(client, sql_query::String)
    query_job = client.query(sql_query)
    results_df = query_job.to_dataframe()
    
    # Konversi hasil Python Pandas ke Julia DataFrame
    return DataFrame(pyconvert(Dict, results_df.to_dict(orient="list")))
end

end # module