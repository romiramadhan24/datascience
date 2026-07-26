include("/workspaces/datascience/helper/auth_bigquery.jl")

q("""
prql target:sql.bigquery

from e=`$db.dataset.worldenergy`
select { e.Country, e.Year }
take 5
""")