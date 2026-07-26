using GoogleCloud

session = get_bq_creds()

# 2. Eksekusi query dengan BQ module
sql_query = "SELECT * FROM $BQ_TABLE LIMIT 10"

# Memanggil API BigQuery lewat GoogleCloud.BQ
response = GoogleCloud.BQ.query(session, BQ_PROJECT, sql_query)

println(response)