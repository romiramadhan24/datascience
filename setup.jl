using Pkg

# 1. Matikan prekompilasi otomatis saat Pkg.add agar tidak memicu kompilasi ulang yang lama
ENV["JULIA_PKG_PRECOMPILE_AUTO"] = "0"

Pkg.activate(@__DIR__)

# ==============================================================================
# 📦 DAFTAR PACKAGE JULIA
# ==============================================================================
required_julia_packages = [
    # Manipulasi Data Modern & Clean
    "DataFrames",
    "CSV",
    "JSON",
    "JSON3",
    "Arrow",

    # Statistik & Probabilitas
    "StatsBase",
    "Distributions",
    "HypothesisTests",
    "Statistics",

    # Database & GCP
    "HTTP",
    "DotEnv",

    # Machine Learning & Deep Learning
    "MLJ",                # Ekosistem ML Klasik
    "GLM",                # Regresi Linear & Logistik
    "EvoTrees",           # Gradient Boosting berbasis Julia
    "Lux",                # Deep Learning modern
    "JuMP",               # Optimasi Matematis

    # Notebook & Produktivitas
    "Revise",
    "OhMyREPL",
    "Pluto",

    # Integrasi Python & Conda
    "PythonCall",
    "CondaPkg"
]

# ==============================================================================
# 🐍 DAFTAR PACKAGE PYTHON (Via CondaPkg)
# ==============================================================================
required_python_packages = [
    "google-cloud-bigquery",
    "google-auth",
    "pyarrow"
]

# Paket yang HANYA ada di PyPI (pip)
#required_pip_packages = [
#    "prql-python"
#]

# ==============================================================================
# 🚀 PROSES EKSEKUSI SETUP
# ==============================================================================

# 2. Ambil dependensi Julia yang sudah terdaftar
current_deps = Pkg.project().dependencies
missing_julia = [p for p in required_julia_packages if !haskey(current_deps, p)]

# 3. Install paket Julia yang belum ada
if !isempty(missing_julia)
    @info "Menginstal paket Julia baru:" missing_julia
    Pkg.add(missing_julia)
else
    @info "Semua paket Julia sudah terdaftar di Project.toml."
end

# 4. Sinkronkan & Kompilasi Lingkungan Julia
@info "Menyelaraskan lingkungan (instantiate)..."
Pkg.instantiate()

# 5. Install paket Python secara otomatis dari daftar di atas
using CondaPkg
@info "Memeriksa dan menginstal paket Python..."
for py_pkg in required_python_packages
    CondaPkg.add(py_pkg)
end

#@info "Memeriksa dan menginstal paket Pip (PyPI)..."
#for pip_pkg in required_pip_packages
#    CondaPkg.add_pip(pip_pkg) # <-- Gunakan add_pip untuk prql-python
#end

@info "Jalankan prekompilasi paralel..."
Pkg.precompile()

@info "🎉 Selesai! Environment Julia & Python siap digunakan."