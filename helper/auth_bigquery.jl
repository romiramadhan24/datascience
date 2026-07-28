# Helper untuk autentikasi dan query ke Google BigQuery menggunakan PythonCall.jl
using PythonCall
using DataFrames
using Arrow

# Import modul Python yang diperlukan
const py_bq   = pyimport("google.cloud.bigquery")
const py_sa   = pyimport("google.oauth2.service_account")
const py_prql = pyimport("prql_python")
const py_json = pyimport("json")
const py_pa   = pyimport("pyarrow")
const py_ipc  = pyimport("pyarrow.ipc")

# Fungsi untuk mengambil client BigQuery
function get_bq_client(project_id::String; env_var::String="GCP_KEY_JSON")
    json_str = get(ENV, env_var, "")
    if isempty(json_str)
        error("Environment variable secret '$env_var' tidak ditemukan atau kosong!")
    end

    info = py_json.loads(json_str)
    credentials = py_sa.Credentials.from_service_account_info(info)
    return py_bq.Client(project=project_id, credentials=credentials)
end

# Fungsi untuk mengambil client BigQuery dari file JSON
function get_bq_client(json_key_path::String, project_id::String)
    !isfile(json_key_path) && error("File kredensial tidak ditemukan: $json_key_path")
    credentials = py_sa.Credentials.from_service_account_file(json_key_path)
    return py_bq.Client(project=project_id, credentials=credentials)
end

# Fungsi untuk menjalankan query SQL dan mengembalikan DataFrame Julia
function run_query(client, sql_query::String)
    query_job = client.query(sql_query)
    arrow_table = query_job.to_arrow()
    sink = py_pa.BufferOutputStream()
    writer = py_ipc.RecordBatchFileWriter(sink, arrow_table.schema)
    writer.write_table(arrow_table)
    writer.close()
    py_bytes = sink.getvalue().to_pybytes()
    julia_bytes = pyconvert(Vector{UInt8}, py_bytes)
    return DataFrame(Arrow.Table(julia_bytes))
end

# Fungsi untuk menjalankan query PRQL dan mengembalikan DataFrame Julia
function run_prql(client, prql_query::String)
    sql_query = pyconvert(String, py_prql.compile(prql_query))
    return run_query(client, sql_query)
end

# Set default project ID untuk BigQuery
const db = "database-collection-503407"

# Set variabel tersebut sebagai default argument di fungsi q()
function q(prql_str::String; project::String=db)
    client = get_bq_client(project)
    df = run_prql(client, prql_str)    
    return df
end