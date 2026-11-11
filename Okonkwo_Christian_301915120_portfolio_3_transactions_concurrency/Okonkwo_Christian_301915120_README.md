# Portfolio 3: Transactions and Concurrency

## Deliverables Summary
- `transfer_transactions.sql`: PL/pgSQL transaction function with row locking and isolation level tests.
- `concurrency_analysis.md`: Technical report evaluating ACID guarantees, lock management, and deadlock resolution.
- `rollback_evidence.png`: Screenshot demonstrating automated transaction rollback on insufficient funds.
- `deadlock_evidence.png`: Screenshot showing terminal logs of PostgreSQL detecting and aborting a circular deadlock.

## How to Reproduce
1. Execute `transfer_transactions.sql` in pgAdmin.
2. Run two concurrent `psql` sessions to reproduce the deadlock scenario documented in `concurrency_analysis.md`.