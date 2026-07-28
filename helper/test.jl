include("/workspaces/datascience/helper/api_imf.jl")

df_all = extract_sdmx_data(data_json)
first(df_all, 5)