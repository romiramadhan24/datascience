using PythonCall
using DataFrames
using Arrow

# Load modul Python sekali di tingkat file
const py_bq   = pyimport("google.cloud.bigquery")
const py_sa   = pyimport("google.oauth2.service_account")
const py_prql = pyimport("prql_python")
const py_json = pyimport("json")
const py_pa   = pyimport("pyarrow")
const py_ipc  = pyimport("pyarrow.ipc")

# 1. Mengambil client via Environment Variable (Secret Codespace)
function get_bq_client(project_id::String; env_var::String="GCP_KEY_JSON")
    json_str = get(ENV, env_var, "")
    if isempty(json_str)
        error("Environment variable secret '$env_var' tidak ditemukan atau kosong!")
    end

    info = py_json.loads(json_str)
    credentials = py_sa.Credentials.from_service_account_info(info)
    return py_bq.Client(project=project_id, credentials=credentials)
end

# 2. Mengambil client via File Path
function get_bq_client(json_key_path::String, project_id::String)
    !isfile(json_key_path) && error("File kredensial tidak ditemukan: $json_key_path")
    credentials = py_sa.Credentials.from_service_account_file(json_key_path)
    return py_bq.Client(project=project_id, credentials=credentials)
end

function run_query(client, sql_query::String)
    query_job = client.query(sql_query)
    
    # 1. Ambil data sebagai PyArrow Table
    arrow_table = query_job.to_arrow()
    
    # 2. Serialize ke buffer bytes menggunakan pyarrow.ipc (RecordBatchFileWriter)
    sink = py_pa.BufferOutputStream()
    writer = py_ipc.RecordBatchFileWriter(sink, arrow_table.schema)
    writer.write_table(arrow_table)
    writer.close()
    
    # 3. Ambil byte mentah Python lalu konversi ke Vector{UInt8} Julia
    py_bytes = sink.getvalue().to_pybytes()
    julia_bytes = pyconvert(Vector{UInt8}, py_bytes)
    
    # 4. Parsing zero-copy ke Julia DataFrame via Arrow.jl
    return DataFrame(Arrow.Table(julia_bytes))
end

function run_prql(client, prql_query::String)
    sql_query = pyconvert(String, py_prql.compile(prql_query))
    return run_query(client, sql_query)
end