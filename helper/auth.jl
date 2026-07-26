using GoogleCloud

const BQ_PROJECT = "database-collection-503407"
const BQ_DATASET = "dataset"
const BQ_TABLE_NAME = "worldenergy"
const BQ_TABLE = "`$BQ_PROJECT.$BQ_DATASET.$BQ_TABLE_NAME`"

"""
    get_bq_creds()

Mengambil GoogleSession untuk autentikasi GCP.
"""
function get_bq_creds()
    tmp_dir = joinpath(@__DIR__, "..", ".tmp")
    mkpath(tmp_dir)
    key_path = joinpath(tmp_dir, "gcp_key_temp.json")

    if !isfile(key_path)
        write(key_path, ENV["GCP_KEY_JSON"])
    end

    return GoogleSession(key_path)
end