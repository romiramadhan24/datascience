using PythonCall
using DataFrames
using Arrow

const py_bq   = pyimport("google.cloud.bigquery")
const py_sa   = pyimport("google.oauth2.service_account")
const py_json = pyimport("json")

function get_bq_client(project_id::String; env_var::String="GCP_KEY_JSON")
    json_str = get(ENV, env_var, "")
    if isempty(json_str)
        error("Environment variable secret '$env_var' tidak ditemukan atau kosong!")
    end

    info = py_json.loads(json_str)
    credentials = py_sa.Credentials.from_service_account_info(info)
    return py_bq.Client(project=project_id, credentials=credentials)
end

function get_bq_client(json_key_path::String, project_id::String)
    !isfile(json_key_path) && error("File kredensial tidak ditemukan: $json_key_path")
    credentials = py_sa.Credentials.from_service_account_file(json_key_path)
    return py_bq.Client(project=project_id, credentials=credentials)
end

function get_bq_client(project_id::String; env_var::String="GCP_KEY_JSON")
    json_str = get(ENV, env_var, "")
    if isempty(json_str)
        error("Environment variable secret '$env_var' tidak ditemukan atau kosong!")
    end

    info = py_json.loads(json_str)
    credentials = py_sa.Credentials.from_service_account_info(info)
    return py_bq.Client(project=project_id, credentials=credentials)
end

const DEFAULT_PROJECT = "database-collection-503407"

function q(sql_str::String; project::String=DEFAULT_PROJECT)
    client = get_bq_client(project)
    return run_query(client, sql_str)
end
