using Pkg
Pkg.activate(@__DIR__)

# Daftar package paling modern, canggih, dan bersih untuk Data Science & AI
required_packages = [
    # Manipulasi Data Modern & Clean
    "DataFrames",
    "TidierData",         # Manipulasi data paling clean (tanpa butuh simbol :)
    "CSV",
    "JSON",
    "Arrow",
    "CategoricalArrays",

    # Statistik & Probabilitas
    "StatsBase",
    "Distributions",
    "HypothesisTests",

    # Database (PostgreSQL)
    "LibPQ",
    "DBInterface",
    "HTTP",
    "DotEnv",
    "GoogleCloud",

    # Machine Learning & Deep Learning Modern
    "MLJ",                # Ekosistem ML Klasik
    "GLM",                # Regresi Linear & Logistik
    "EvoTrees",           # Gradient Boosting kencang berbasis Julia
    "Lux",                # Deep Learning paling modern & stateful
    "JuMP",               # Optimasi Matematis

    # Notebook & Produktivitas
    "Revise",
    "OhMyREPL",
    "Pluto",
    "BenchmarkTools",
    "ProgressMeter",
    "PrettyTables",

    # Integrasi Python Modern
    "PythonCall"
]

# 1. Cek dan instal package yang belum ada di folder ini
current_deps = Pkg.project().dependencies
missing_packages = [p for p in required_packages if !haskey(current_deps, p)]

if !isempty(missing_packages)
    @info "Menginstal package baru..." missing_packages
    Pkg.add(missing_packages)
end

# 2. Otomatis update semua package ke versi terbaru
@info "Memeriksa dan memperbarui versi package..."
#Pkg.update()
#Pkg.instantiate()

@info "Selesai! Environment Julia kamu sudah dalam versi paling canggih dan clean."