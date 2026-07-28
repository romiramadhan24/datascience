include("/workspaces/datascience/helper/auth_bigquery.jl")

q("""
prql target:sql.bigquery

from e=`$db.dataset.RenewableEnergy`
select {}
take 5
""")