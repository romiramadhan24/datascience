using HTTP
using JSON3
using DataFrames

# URL Data Query yang valid untuk IMF Data Explorer (SDMX v3.0)
url_data = "https://api.imf.org/external/sdmx/3.0/data/dataflow/IMF.STA/LS/9.0.0/AFG+ALB+DZA+AGO+AIA+ATG+ARG+ARM+ABW+AUS+AUT+AZE+BHS+BHR+BGD+BRB+BLR+BEL+BLZ+BEN+BTN+BOL+BIH+BWA+BRA+BRN+BGR+BFA+BDI+CPV+KHM+CMR+CAN+CAF+TCD+CHL+CHN+COL+COM+COD+COG+CRI+HRV+CUW+CYP+CZE+CIV+DNK+DJI+DMA+DOM+ECU+EGY+SLV+GNQ+ERI+EST+SWZ+ETH+FJI+FRA+GAB+GMB+GEO+DEU+GHA+GRC+GRD+GTM+GIN+GNB+GUY+HTI+HND+HKG+HUN+ISL+IND+IDN+IRN+IRQ+IRL+ISR+ITA+JPN+JOR+KAZ+KIR+KOR+KWT+KGZ+LAO+LBN+LSO+LBR+LBY+LTU+LUX+MAC+MDG+MWI+MYS+MDV+MLI+MLT+MHL+MRT+MUS+MEX+FSM+MDA+MNG+MNE+MSR+MAR+MOZ+MMR+NAM+NPL+NLD+NZL+NER+NGA+MKD+NOR+OMN+PAK+PLW+PAN+PNG+PRY+PER+POL+PRT+QAT+ROU+RUS+RWA+WSM+SMR+SAU+SEN+SRB+SYC+SLE+SGP+SVK+SVN+SLB+SOM+ZAF+ESP+LKA+KNA+LCA+VCT+SDN+SUR+CHE+SYR+STP+TJK+TZA+THA+TLS+TGO+TON+TTO+TUN+TUV+TUR+UGA+UKR+ARE+GBR+USA+URY+UZB+VUT+VEN+VNM+WBG+YEM+ZMB+ZWE+CSK+YUG.WR+U+E+LF+UP.IX+PT+PE+POP_PCH_PT+YOY_PCH_PT.A+M+Q?c%5BTIME_PERIOD%5D=ge:1945-12-31+le:2026-05-31&attributes=all&detail=full&includeHistory=true&limit=100"

response = HTTP.get(url_data, ["Accept" => "application/json"])
data_json = JSON3.read(String(response.body))

# 2. Ambil daftar periode waktu dari metadata struktur
time_periods = data_json.data.structures[1].dimensions.observation[1].values

# Fungsi pembantu untuk mengambil label waktu
get_time_label(item) = hasproperty(item, :id) ? item.id : (hasproperty(item, :value) ? item.value : string(item))

# 3. Ekstrak data dari semua series ke dalam daftar
records = []
datasets = data_json.data.dataSets[1]

for (series_id, series_obj) in datasets.series
    obs = series_obj.observations
    for (k_sym, v_val) in obs
        # Indeks waktu pada SDMX berbasis 0, Julia berbasis 1
        idx = parse(Int, string(k_sym)) + 1
        time_label = get_time_label(time_periods[idx])
        val = v_val[1]
        push!(records, (Series = string(series_id), Time = time_label, Value = val))
    end
end

# 4. Buat DataFrame
df = DataFrame(records)

# 5. Tampilkan 5 sampel data pertama
first(df, 5)