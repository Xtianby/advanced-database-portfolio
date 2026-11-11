# advanced-database-portfolio
XTIANBY PORTFOLIO
# Advanced Database Systems Portfolio (MIT 8103)

**Student Name:** Okonkwo Christian Chikelue  
**Selected Case Study:** OmniPay Switch Systems (Fintech Payment Switch & Digital Wallet Platform)  

## 1. Case Study & Business Scenario
OmniPay Switch Systems is a high-throughput payment switch operating across Nigeria. The system processes peer-to-peer (P2P) transfers, merchant digital wallet payments, and double-entry ledger bookkeeping.

### Core Database Operations Supported:
- Customer identity registration and KYC tier management.
- Multi-currency digital wallet account creation.
- Real-time P2P funds transfer execution with strict debit/credit balance checks.
- Double-entry ledger audit logging for financial compliance.

## 2. Target Database Architecture
- **Relational Engine:** PostgreSQL 15+ (BCNF normalized schema, double-entry ledger, ACID transaction isolation).
- **Dataset Scale:** 10,000 customers (`users`), 10,000 active wallets (`accounts`), and 100,000 transaction records (`transactions`).

## 3. Portfolio Repository Structure
- `portfolio-1-database-design/`: PostgreSQL DDL schema, ER Diagram, and BCNF normalization proof.
- `portfolio-2-query-optimisation/`: Synthetic ETL data seeding, complex analytical queries, and `EXPLAIN ANALYZE` index benchmarking.
- `portfolio-3-transactions-concurrency/`: PL/pgSQL transfer function, isolation tests, and deadlock detection logs.
- `portfolio-4-nosql/`: MongoDB JSON schemas and fraud detection aggregation pipelines.
- `portfolio-5-distributed-cloud/`: Docker Compose streaming replication configuration and failover architecture.

## 4. Declarations & Integrity
- **AI Use Declaration:** AI tools were utilized as learning aids for debugging SQL syntax and generating markdown templates. All DDL scripts, ETL pipelines, and performance benchmarks were manually created, executed, and verified locally.
- **Academic References:** Cited in standard APA 6th Edition format.
