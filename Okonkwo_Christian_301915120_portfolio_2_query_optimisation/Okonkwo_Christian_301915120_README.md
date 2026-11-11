# Portfolio 2: Query Processing and Optimisation

## Deliverables Summary
- `query_optimisation.sql`: Analytical SQL query, index DDLs, and `EXPLAIN ANALYZE` commands.
- `performance_analysis.md`: Technical analysis report documenting pre- and post-optimization cost metrics.
- `unoptimized_plan.png`: Execution plan screenshot showing sequential scanning behavior.
- `optimized_plan.png`: Execution plan screenshot showing index scanning behavior and latency drop.

## How to Reproduce
1. Execute `query_optimisation.sql` against `omnipay_db` in pgAdmin.
2. Observe `EXPLAIN ANALYZE` execution time reduction before and after index creation.