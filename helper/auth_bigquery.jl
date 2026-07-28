using PythonCall, DataFrames, Arrow

const py_bq   = pyimport("google.cloud.bigquery")
const py_sa   = pyimport("google.oauth2.service_account")
const py_json = pyimport("json")
const py_pa   = pyimport("pyarrow")
const py_ipc  = pyimport("pyarrow.ipc")

const db = "database-collection-503407"
const CLIENT_STORE    = Dict{String, Py}()

function auto_credentials()
    env_json = get(ENV, "GCP_KEY_JSON", "")
    !isempty(env_json) && return py_sa.Credentials.from_service_account_info(py_json.loads(env_json))

    json_files = String[pyconvert(String, f) for f in readdir(".") if endswith(pyconvert(String, f), ".json")]
    for file in json_files
        content = read(file, String)
        contains(content, "service_account") && return py_sa.Credentials.from_service_account_file(file)
    end
end

function get_bq_client(project::String = db)
    haskey(CLIENT_STORE, project) && return CLIENT_STORE[project]
    
    creds = auto_credentials()
    client = py_bq.Client(project=project, credentials=creds)
    CLIENT_STORE[project] = client
    return client
end

function q(sql::String; project::String = db, copycols::Bool = false)::DataFrame
    client = get_bq_client(project)
    py_arrow_tbl = client.query(sql).to_arrow()

    sink = py_pa.BufferOutputStream()
    writer = py_ipc.RecordBatchStreamWriter(sink, py_arrow_tbl.schema)
    writer.write_table(py_arrow_tbl)
    writer.close()

    bytes = pyconvert(Vector{UInt8}, sink.getvalue().to_pybytes())
    return DataFrame(Arrow.Table(bytes); copycols=copycols)
end