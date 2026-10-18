# Portfolio 5: Distributed & Cloud Database Architecture Analysis

## 1. Case Study High Availability Architecture
To ensure continuous operation for **OmniPay Switch Systems** during regional network partitions or hardware failures, the database layer transitions from a single-instance setup to a distributed primary-replica topology using PostgreSQL Write-Ahead Log (WAL) streaming replication.

### Core Topology Components:
- **Primary Master Node (`omnipay_pg_primary`):** Handles all read/write transactions (`INSERT`, `UPDATE`, `DELETE`) and enforces ACID ledger consistency.
- **Secondary Standby Node (`omnipay_pg_replica`):** Asynchronously streams WAL records from the primary instance. It handles read-heavy analytical dashboards and serves as an immediate failover target.
- **Failover Router (PgBouncer / Patroni):** Continuously monitors primary node health. If health checks fail for 10 seconds, it automatically promotes the standby replica to primary master.

## 2. Horizontal Sharding & Data Partitioning Strategy
To scale beyond single-node hardware limits for millions of transactions, financial records are horizontally sharded using **Consistent Hash Partitioning** on `source_account_id`:
- **Shard Node 01 (Lagos DC):** Accounts `0000000000` to `0024999999`
- **Shard Node 02 (Abuja DC):** Accounts `0025000000` to `0049999999`
- **Shard Node 03 (Port Harcourt DC):** Accounts `0050000000` to `0074999999`
- **Shard Node 04 (Kano DC):** Accounts `0075000000` to `0099999999`

## 3. CAP Theorem & PACELC Evaluation
- **CAP Classification:** **CP (Consistency & Partition Tolerance)**. Financial ledger integrity strictly requires preventing split-brain double-spending, even if network partitions force temporary write rejection on isolated nodes.
- **PACELC Classification:** **PC/EC**. Under network partitions ($P$), the system chooses Consistency ($C$) over Availability ($A$). Otherwise ($E$), it chooses Consistency ($C$) over Latency ($L$) to maintain strict balance accuracy.