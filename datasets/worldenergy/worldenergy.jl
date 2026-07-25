using CSV, DataFrames, Arrow, TidierData, PrettyTables

file_path = "/workspaces/datascience/datasets/worldenergy/worldenergy2025"

df = @chain file_path begin
    Arrow.Table
    DataFrame
    @slice(1:5)
end

pretty_table(
    df;
    backend = :latex,
    table_format = latex_table_format__booktabs
)