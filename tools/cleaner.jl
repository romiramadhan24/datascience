using CSV
using DataFrames

# 1. Baca file CSV Anda
df = CSV.read("/workspaces/datascience/datasets/RenewableEnergy.csv", DataFrame)

# 2. Hapus koma dan semua teks setelahnya pada kolom COUNTRY
# r",.*" artinya: koma (,) dan seluruh karakter setelahnya (.*) diganti dengan ""
df.COUNTRY = replace.(df.COUNTRY, r",.*" => "")

# 3. (Opsional) Hapus spasi sisa di awal/akhir jika ada
df.COUNTRY = strip.(df.COUNTRY)

# 4. Simpan kembali ke file CSV baru
CSV.write("/workspaces/datascience/datasets/RenewableEnergy.csv", df)