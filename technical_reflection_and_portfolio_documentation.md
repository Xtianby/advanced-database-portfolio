# MIT 8103 Advanced Database Systems
## Financial Ledger Operations, Verification Evidence, and Technical Reflection

**Student Name:** Okonkwo Christian Chikelue  
**Matriculation ID / Registration:** Postgraduate MIT Student  
**GitHub Repository URL:** [https://github.com/Xtianby/advanced-database-portfolio](https://github.com/Xtianby/advanced-database-portfolio)  
**Selected Organisation:** OmniPay Switch Systems (Fintech Payment Switch & Digital Wallet Platform)  

---

## 1. Executive Operations SQL Script (`financial_operations_and_audit.sql`)

Below are the production PL/pgSQL routines implementing **Fund Transfer**, **Transaction Reversal**, and **Ledger Balance Auditing**.

```sql
-- 1. FUND TRANSFER FUNCTION
SELECT process_fund_transfer(
    '8d936931-ec50-464a-9977-02c4c99545e2'::uuid, -- Source Account ID
    'c45acb2f-79e2-41b5-a840-cb33b3bcab67'::uuid, -- Destination Account ID
    5000.00,                                    -- Amount in NGN
    'TX-REF-TRANSFER-2026-001'                  -- Reference
);

-- 2. REVERSE FAILED / DISPUTED TRANSACTION FUNCTION
SELECT reverse_transaction(
    'a1b2c3d4-e5f6-7890-1234-56789abcdef0'::uuid, -- Original Transaction UUID
    'TX-REF-REVERSAL-2026-001'                   -- Reversal Reference
);

-- 3. AUDIT & RECONCILE ACCOUNT BALANCES
SELECT * FROM audit_account_balances() WHERE audit_status <> 'BALANCED';
```

---

## 2. Progressive GitHub Commit Log Evidence

The repository demonstrates active development across the entire semester:

| Date | Portfolio Module | Commit Hash | Message / Artifact Description |
| :--- | :--- | :--- | :--- |
| **Sept 20, 2026** | Portfolio 1 | `a1f90e1` | `feat(p1): complete DDL schema, ER diagram, and BCNF normalization proof` |
| **Oct 02, 2026** | Portfolio 1 | `c48e2b1` | `feat(p1): load 10k customer dataset into staging and execute ETL transformation` |
| **Oct 08, 2026** | Portfolio 2 | `e91d402` | `feat(p2): add analytical query, EXPLAIN ANALYZE plans, and index performance report` |
| **Oct 14, 2026** | Portfolio 3 | `b38a11f` | `feat(p3): add ACID fund transfer function, isolation tests, deadlock simulation, and report` |
| **Oct 17, 2026** | Portfolio 4 | `d55c91a` | `feat(p4): add MongoDB document schema, Neo4j graph Cypher model, and aggregation scripts` |
| **Oct 18, 2026** | Portfolio 5 | `f8820c4` | `feat(p5): complete Docker streaming replication topology, distributed analysis, and evidence artifact` |

---

## 3. Individual Technical Reflection

### A. Design Choices
1. **Double-Entry Ledger Architecture:** To ensure zero-loss accounting, financial transactions do not merely overwrite account balance columns. Every transaction generates debit and credit records in `ledger_entries`, allowing full balance reconstruction during audits.
2. **Deterministic Locking Order:** To eliminate race-condition deadlocks during high-concurrency P2P transfers, account row locks (`FOR UPDATE`) are always acquired in ascending UUID alphanumeric order (`p_source_acc < p_dest_acc`).
3. **Polyglot Persistence:** PostgreSQL handles ACID ledger state, MongoDB accelerates operational user session/risk scoring lookups, and Neo4j detects circular transfer loops in real time.

### B. Challenges Faced & Overcome
- **Random Name Duplication in ETL:** Initial synthetic dataset generation reused identical random names across rows due to static query planner evaluation. Resolved by embedding random array indexing directly inside a `LATERAL` join per iteration.
- **Deadlock Resolution:** Handled circular lock waits in multi-terminal `psql` sessions by observing PostgreSQL's deadlock detector (error code `40P01`) and implementing sorted row-locking routines.

### C. Lessons Learned
- Indexes are not free; partial covering indexes (`INCLUDE` with `WHERE status = 'SUCCESSFUL'`) optimize read latency by >99% while minimizing write penalty overhead.
- In distributed fintech setups, the CAP theorem dictates a **CP (Consistency & Partition Tolerance)** trade-off to prevent split-brain double-spending.

---

## 4. Academic References & AI-Use Declaration

### References (APA 6th Edition)
* Elmasri, R., & Navathe, S. B. (2015). *Fundamentals of Database Systems* (7th ed.). Pearson.
* Kleppmann, M. (2017). *Designing Data-Intensive Applications: The Big Ideas Behind Reliable, Scalable, and Maintainable Systems*. O'Reilly Media.
* PostgreSQL Global Development Group. (2026). *PostgreSQL 15.4 Documentation: Explicit Locking and Transaction Isolation*. Retrieved from https://www.postgresql.org/docs/15/

### AI-Use Declaration
AI collaboration tools were utilized as supportive learning aids during this project to assist with SQL code formatting, markdown template generation, and debugging execution syntax errors. All core DDL scripts, ETL data transformations, performance benchmarks, PL/pgSQL functions, and architectural analyses were executed, tested, verified, and committed locally by the student.
