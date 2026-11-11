# Portfolio 3: Transactions & Concurrency Analysis Report

## 1. ACID Guarantees in Payment Operations
- **Atomicity:** All fund transfer steps (debits, credits, ledger audit entries) execute inside `process_fund_transfer()`. If an exception occurs, PostgreSQL executes an immediate `ROLLBACK`.
- **Consistency:** Database check constraints (`CHECK balance >= 0`) enforce non-negative balances at the engine level.
- **Isolation:** Explicit row locking (`SELECT ... FOR UPDATE`) prevents concurrent double-spending race conditions.
- **Durability:** Committed transactions are persistently recorded in PostgreSQL's Write-Ahead Log (WAL).

## 2. Deadlock Detection & Resolution Engine
- **Cause:** Deadlocks occur when concurrent processes lock dependent account rows in conflicting orders (Session 1: $A \rightarrow B$; Session 2: $B \rightarrow A$).
- **Detection:** PostgreSQL's lock manager detects circular lock wait dependencies and terminates the blocking transaction with error code `40P01` (`deadlock_detected`).
- **Mitigation Strategy:** Ordering account row locks deterministically by sorted primary key UUID (`p_source_acc < p_dest_acc`) completely eliminates circular wait conditions.

## 3. Transaction Isolation Levels Comparison
- **Read Committed (Default):** Prevents dirty reads. Suitable for standard analytical reporting queries.
- **Repeatable Read:** Prevents dirty and non-repeatable reads. Used during financial audit reconciliations.
- **Serializable:** Enforces strict sequential transaction execution, eliminating serialization anomalies and phantom reads.