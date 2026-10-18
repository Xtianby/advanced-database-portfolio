# Portfolio 1: Database Design and Modelling

## 1. Case Study Selection
**Organisation:** OmniPay Switch Systems  
**Nature of Business:** Digital payment switch & wallet platform processing P2P funds transfers, multi-currency accounts, and double-entry ledger bookkeeping.  

## 2. Deliverables Summary
- `schema.sql`: Production PostgreSQL DDL schema with UUID primary keys, foreign key constraints, unique indexes, and domain checks.
- `customers.csv`: Raw dataset containing 10,000 customer records used for database staging and ETL pipeline seeding.
- `er-diagram.png`: Visual Entity-Relationship Diagram showing entity relationships and cardinalities.
- `normalization-analysis.md`: Formal proof demonstrating BCNF normalization progression from 1NF to BCNF.

## 3. How to Reproduce
1. Execute `schema.sql` in PostgreSQL / pgAdmin to create tables.
2. Load `customers.csv` into `customers_staging`.
3. Run the ETL transformation script inside `schema.sql` to populate `users`, `accounts`, and `transactions`.