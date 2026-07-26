# Romi Ramadhan — Data Science Portfolio

[![Language: Julia](https://img.shields.io/badge/Language-Julia-9558B2)](https://julialang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

Selamat datang di portofolio data science saya — kumpulan proyek, notebook, dan eksperimen yang saya bangun menggunakan Julia. Di sini saya memadukan pendekatan ilmiah, praktik reproducible, dan visualisasi yang komunikatif untuk menjawab pertanyaan bisnis dan riset.

---

## Mengapa melihat portofolio ini?
- End-to-end: tiap proyek mencakup pengumpulan data, pembersihan, eksplorasi, pemodelan, dan interpretasi hasil.
- Reproducible: environment dan instruksi jelas sehingga hasil bisa dijalankan ulang.
- Julia-first: menunjukkan performa dan elegansi sintaks Julia untuk analisis ilmiah.

---

## Sorotan
- 🔎 Exploratory Data Analysis (EDA) mendalam dengan visual yang komunikatif
- 🧠 Machine Learning & Statistical Modeling (regresi, klasifikasi, time series, probabilistic)
- 📦 Pipeline yang dapat dijalankan ulang (Project.toml / Manifest.toml pada tiap proyek)
- 📈 Dashboard & visual interaktif (Pluto.jl / Dash.jl / Makie)

---

## Proyek unggulan
Buka folder masing-masing proyek untuk notebook, skrip, dan README detil.

- housing-price-prediction — Pipeline lengkap untuk prediksi harga properti; feature engineering, cross-validation, dan interpretasi model.
- sales-forecasting — Pemodelan deret waktu untuk forecasting penjualan, decomposition, dan evaluasi skenario.
- sentiment-analysis — Klasifikasi teks untuk analisis sentimen dengan pipeline preprocessing dan evaluasi.
- interactive-visuals — Dashboard interaktif untuk eksplorasi data dan penyajian insight.

Jika Anda ingin, saya bisa menambahkan ringkasan singkat (1–2 kalimat) untuk tiap proyek berdasarkan isi foldernya.

---

## Cara cepat menjalankan
1. Clone repo:
   git clone https://github.com/romiramadhan24/datascience.git
2. Masuk ke folder proyek yang ingin dijalankan, lalu buka Julia REPL.
3. Install dependensi (di dalam folder proyek yang memiliki Project.toml):
   using Pkg; Pkg.instantiate()
4. Buka notebook (Pluto atau Jupyter) atau jalankan skrip di src/.

Catatan: periksa README di tiap folder proyek untuk instruksi spesifik dan contoh dataset.

---

## Struktur repositori (singkat)
- notebooks/ — Notebook per proyek (Pluto / IJulia)
- src/ — Kode Julia yang dapat digunakan ulang (preprocessing, modeling, utilities)
- data/ — Dataset atau skrip pengunduhan data
- dashboards/ — Aplikasi visual interaktif
- results/ — Output model, figure, dan laporan

---

## Stack & tools
- Bahasa utama: Julia
- Data: DataFrames.jl, CSV.jl
- Visualisasi: Plots.jl, Makie.jl, VegaLite.jl, StatsPlots
- ML & statistik: MLJ.jl, Flux.jl, GLM.jl, Turing.jl
- Notebook & dashboard: Pluto.jl, IJulia, Dash.jl

---

## Reproducibility
Setiap proyek yang lengkap memiliki Project.toml dan/atau Manifest.toml. Ikuti instruksi pada masing-masing folder untuk mereplikasi environment dan hasil eksperimen.

---

## Tentang saya
Halo — saya Romi (lihat profil GitHub: https://github.com/romiramadhan24). Saya tertarik pada penerapan metode kuantitatif untuk menyelesaikan masalah nyata, membangun model yang dapat dijelaskan, dan menyajikan insight yang berguna bagi pengambil keputusan.

---

## Ingin berkolaborasi?
Buka issue di repo ini atau kirim pesan melalui profil GitHub saya: https://github.com/romiramadhan24

---

## Lisensi
Isi repo ini dilisensikan di bawah MIT License — lihat file LICENSE untuk detail.

---

Terima kasih sudah mengunjungi portofolio ini — silakan jelajahi proyek dan beri tahu saya jika Anda ingin versi README berbahasa Inggris atau versi yang memuat screenshot dan demo interaktif.