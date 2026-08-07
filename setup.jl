using Pkg

ENV["JULIA_PKG_PRECOMPILE_AUTO"] = "0"

Pkg.activate(@__DIR__)

required_julia_packages = [

    "DataFrames",
    "DataFramesMeta",
    "CSV",
    "Arrow",
    "JSON3",
    "Revise",
    "Random",      
    "Lux", 
    "ComponentArrays",
    "DifferentialEquations", 
    "Zygote",
    "SciMLSensitivity",
    "Optimization",
    "OptimizationOptimJL",
    "OptimizationOptimisers",
    "CairoMakie"
]

current_deps = Pkg.project().dependencies
missing_julia = [p for p in required_julia_packages if !haskey(current_deps, p)]


if !isempty(missing_julia)
    @info "Menginstal paket Julia baru:" missing_julia
    Pkg.add(missing_julia)
else
    @info "Semua paket Julia sudah terdaftar di Project.toml."
end

@info "Menyelaraskan lingkungan (instantiate)..."
Pkg.instantiate()

@info "Jalankan prekompilasi paralel..."
Pkg.precompile()

@info " Selesai! Environment Julia & Python siap digunakan."