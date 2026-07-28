using HTTP
using JSON3
using DataFrames

# URL Data Query yang valid untuk IMF Data Explorer (SDMX v3.0)
url_data = "https://api.imf.org/external/sdmx/3.0/data/dataflow/IMF.STA/LS/9.0.0/AFG+ALB+DZA+AGO+AIA+ATG+ARG+ARM+ABW+AUS+AUT+AZE+BHS+BHR+BGD+BRB+BLR+BEL+BLZ+BEN+BTN+BOL+BIH+BWA+BRA+BRN+BGR+BFA+BDI+CPV+KHM+CMR+CAN+CAF+TCD+CHL+CHN+COL+COM+COD+COG+CRI+HRV+CUW+CYP+CZE+CIV+DNK+DJI+DMA+DOM+ECU+EGY+SLV+GNQ+ERI+EST+SWZ+ETH+FJI+FRA+GAB+GMB+GEO+DEU+GHA+GRC+GRD+GTM+GIN+GNB+GUY+HTI+HND+HKG+HUN+ISL+IND+IDN+IRN+IRQ+IRL+ISR+ITA+JPN+JOR+KAZ+KIR+KOR+KWT+KGZ+LAO+LBN+LSO+LBR+LBY+LTU+LUX+MAC+MDG+MWI+MYS+MDV+MLI+MLT+MHL+MRT+MUS+MEX+FSM+MDA+MNG+MNE+MSR+MAR+MOZ+MMR+NAM+NPL+NLD+NZL+NER+NGA+MKD+NOR+OMN+PAK+PLW+PAN+PNG+PRY+PER+POL+PRT+QAT+ROU+RUS+RWA+WSM+SMR+SAU+SEN+SRB+SYC+SLE+SGP+SVK+SVN+SLB+SOM+ZAF+ESP+LKA+KNA+LCA+VCT+SDN+SUR+CHE+SYR+STP+TJK+TZA+THA+TLS+TGO+TON+TTO+TUN+TUV+TUR+UGA+UKR+ARE+GBR+USA+URY+UZB+VUT+VEN+VNM+WBG+YEM+ZMB+ZWE+CSK+YUG.WR+U+E+LF+UP.IX+PT+PE+POP_PCH_PT+YOY_PCH_PT.A+M+Q?c%5BTIME_PERIOD%5D=ge:1945-12-31+le:2026-05-31&attributes=all&detail=full&includeHistory=true&limit=100"

println("Mengunduh data dari IMF SDMX API...")
response = HTTP.get(url_data)

println("Merapikan JSON...")
data_json = JSON3.read(response.body)

function extract_all_raw_sdmx(data_json)
    struct_info = data_json.data.structures[1]
    
    # Ambil metadata dimensi & atribut
    series_dim_meta = struct_info.dimensions.series
    obs_dim_meta = struct_info.dimensions.observation
    series_attr_meta = hasproperty(struct_info.attributes, :series) ? struct_info.attributes.series : []
    obs_attr_meta = hasproperty(struct_info.attributes, :observation) ? struct_info.attributes.observation : []
    
    dataset = data_json.data.dataSets[1]
    rows = []

    # Helper penanganan nilai SDMX
    function parse_sdmx_val(val_obj)
        if isnothing(val_obj)
            return missing
        elseif hasproperty(val_obj, :value)
            return string(val_obj.value)
        elseif hasproperty(val_obj, :id)
            return string(val_obj.id)
        elseif hasproperty(val_obj, :name)
            return string(val_obj.name)
        else
            return string(val_obj)
        end
    end

    for (series_key_str, series_obj) in dataset.series
        s_indices = parse.(Int, split(string(series_key_str), ":")) .+ 1
        row_dict = Dict{Symbol, Any}()
        
        # 1. Dimensi Series
        for (i, dim) in enumerate(series_dim_meta)
            val_idx = s_indices[i]
            val_obj = dim.values[val_idx]
            row_dict[Symbol(dim.id)] = parse_sdmx_val(val_obj)
        end
        
        # 2. Atribut Series
        if hasproperty(series_obj, :attributes)
            for (i, attr_val) in enumerate(series_obj.attributes)
                if !isnothing(attr_val) && i <= length(series_attr_meta)
                    attr_name = Symbol(series_attr_meta[i].id)
                    attr_lookup = series_attr_meta[i].values
                    if attr_val + 1 <= length(attr_lookup)
                        row_dict[attr_name] = parse_sdmx_val(attr_lookup[attr_val + 1])
                    else
                        row_dict[attr_name] = attr_val
                    end
                end
            end
        end

        # 3. Observasi (Time & Value)
        for (obs_key_sym, obs_val_arr) in series_obj.observations
            obs_dict = copy(row_dict)
            obs_idx = parse(Int, string(obs_key_sym)) + 1
            
            for dim in obs_dim_meta
                val_obj = dim.values[obs_idx]
                obs_dict[Symbol(dim.id)] = parse_sdmx_val(val_obj)
            end
            
            raw_val = obs_val_arr[1]
            obs_dict[:VALUE] = raw_val isa Number ? Float64(raw_val) : tryparse(Float64, string(raw_val))
            
            if length(obs_val_arr) > 1
                for (j, attr_val) in enumerate(obs_val_arr[2:end])
                    if !isnothing(attr_val) && j <= length(obs_attr_meta)
                        attr_name = Symbol(obs_attr_meta[j].id)
                        obs_dict[attr_name] = attr_val
                    end
                end
            end
            
            push!(rows, obs_dict)
        end
    end
    
    return DataFrame(rows)
end

# Ekstraksi ke DataFrame
df_imf = extract_all_raw_sdmx(data_json)