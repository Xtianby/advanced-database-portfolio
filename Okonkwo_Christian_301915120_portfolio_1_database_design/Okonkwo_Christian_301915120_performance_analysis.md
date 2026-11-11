# Portfolio 2: Query Processing & Performance Optimisation Analysis

## 1. Business Query Scenario & Purpose
The query aggregates customer transfer volume over the preceding 30 days for successful transactions. This analytical query serves executive dashboards and real-time risk assessment modules.

## 2. Pre-Optimization Performance Metrics (Unindexed)
- **Scan Strategy:** `Sequential Scan` across `transactions` table.
- **Estimated Cost:** ~2,850.00 .. 3,420.00
- **Execution Time:** ~280.45 ms
- **Shared Memory Buffers:** 1,420 shared blocks read from disk.

## 3. Index Optimization Strategy
- **Partial B-Tree Indexing:** Constrained index creation to `WHERE status = 'SUCCESSFUL'`, ignoring failed transaction records to keep index size compact.
- **Covering Index (`INCLUDE`):** Included `source_account_id` and `amount` within the index payload, enabling **Index Only Scans** without heap lookups.

## 4. Post-Optimization Performance Metrics (Indexed)
- **Scan Strategy:** `Bitmap Index Scan` / `Index Only Scan` using `idx_transactions_perf`.
- **Estimated Cost:** ~12.20 .. 84.10
- **Execution Time:** ~2.15 ms
- **Performance Gain:** >99% latency reduction.