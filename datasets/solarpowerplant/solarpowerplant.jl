using DataFrames
using TidierData
using LibPQ
using DBInterface
using Arrow
using CategoricalArrays
using PythonCall
using DotEnv
using PrettyTables

# Load .env & connect
DotEnv.load!(joinpath(@__DIR__, "..", "..", ".env"))
db = LibPQ.Connection(ENV["SUPABASE_CONN_STR"])

# Query & print (aman dari connection leak)
try
    local result = execute(db, "SELECT * FROM public.solarpowerplant LIMIT 10;")
    local df = DataFrame(result)
    pretty_table(df)
finally
    close(db)
end