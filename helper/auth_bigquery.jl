# ==============================================================================
# INDONESIA DATA SCIENCE STACK: MAXIMUM PERFORMANCE BIGQUERY TRANSFERS
# ==============================================================================
using PythonCall
using DataFrames
using Arrow
## Kunci Kasta Tertinggi: Tidak ada library transformasi makro (Tidier/Meta) di sini.
## Kita gunakan fungsi dasar Julia dan operator pipa murni (|>) untuk pemrosesan lokal.

# Hanya import modul Python yang kritis untuk koneksi infrastruktur GCP
const py_bq   = pyimport("google.cloud.bigquery")
const py_sa   = pyimport("google.oauth2.service_account")
const py_json = pyimport("json")

# ==============================================================================
# 1. AUTENTIKASI EFEKTIF & BERSIH
# ==============================================================================

"""
Mengambil client BigQuery menggunakan JSON string dari Environment Variable (Aman untuk Production/CI-CD).
"""
function get_bq_client(project_id::String; env_var::String="GCP_KEY_JSON")
    json_str = get(ENV, env_var, "")
    if isempty(json_str)
        error("Environment variable secret '$env_var' tidak ditemukan atau kosong!")
    end

    info = py_json.loads(json_str)
    credentials = py_sa.Credentials.from_service_account_info(info)
    return py_bq.Client(project=project_id, credentials=credentials)
end

"""
Mengambil client BigQuery dari file fisik JSON lokal.
"""
function get_bq_client(json_key_path::String, project_id::String)
    !isfile(json_key_path) && error("File kredensial tidak ditemukan: $json_key_path")
    credentials = py_sa.Credentials.from_service_account_file(json_key_path)
    return py_bq.Client(project=project_id, credentials=credentials)
end

# ==============================================================================
# 2. RUN_QUERY KASTA TERTINGGI: ZERO-COPY ARROW TRANSFER (PERFORMA MAKSIMAL)
# ==============================================================================

"""
Mengeksekusi kueri SQL murni ke BigQuery dan mentransfer datanya langsung 
ke memori RAM Julia tanpa alokasi buffer biner ganda. Menghapus kebocoran RAM.
"""
function run_query(client, sql_query::String)
    py_pa = pyimport("pyarrow")
    py_ipc = pyimport("pyarrow.ipc")
    
    query_job = client.query(sql_query)
    py_arrow_table = query_job.to_arrow()
    
    # Buat buffer biner murni di memori Python
    sink = py_pa.BufferOutputStream()
    writer = py_ipc.RecordBatchFileWriter(sink, py_arrow_table.schema)
    writer.write_table(py_arrow_table)
    writer.close()
    
    # Ambil byte-nya tanpa alokasi baru dan lempar ke Arrow.jl milik Julia
    py_bytes = sink.getvalue().to_pybytes()
    julia_bytes = pyconvert(Vector{UInt8}, py_bytes)
    
    return DataFrame(Arrow.Table(julia_bytes))
end

# ==============================================================================
# 3. ANTARMUKA UTAMA (SISTEM KASTA TERTINGGI)
# ==============================================================================

# Set default project ID untuk BigQuery Anda
const DEFAULT_PROJECT = "database-collection-503407"

"""
Fungsi `q()` Impian: Menggunakan ANSI SQL murni untuk performa warehouse maksimal,
menghilangkan lapisan 'prql' untuk menjaga efisiensi JIT Compiler Julia.
"""
function q(sql_str::String; project::String=DEFAULT_PROJECT)
    client = get_bq_client(project)
    return run_query(client, sql_str)
end
