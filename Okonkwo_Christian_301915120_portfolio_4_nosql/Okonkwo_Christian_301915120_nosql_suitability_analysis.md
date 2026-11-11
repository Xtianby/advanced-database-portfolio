# Portfolio 4: NoSQL & Advanced Data Models Analysis

## 1. Case Study Architectural Hybrid Model
For **OmniPay Switch Systems**, a polyglot persistence architecture is implemented:
- **PostgreSQL (Relational Engine):** Serves as the primary source of truth for ACID balance management, account creation, and double-entry ledger audits.
- **MongoDB (Document Model):** Serves as a high-velocity operational cache for real-time risk scoring, device fingerprinting, and dynamic KYC metadata.
- **Neo4j (Graph Model):** Serves specialized security analytics to detect fraud rings, shared device networks, and circular money laundering patterns.

## 2. Suitability Evaluation Matrix

| Criteria | Relational (PostgreSQL) | Document (MongoDB) | Graph (Neo4j) |
| :--- | :--- | :--- | :--- |
| **Data Structure** | Strict tabular schema (BCNF) | Flexible nested JSON/BSON documents | Property graph (Nodes & Edges) |
| **Transaction Model** | Strict ACID guarantees | Document-level atomicity | ACID graph transactions |
| **Primary Use Case** | Core ledgers & wallet balances | Real-time session & device telemetry | Fraud rings & relationship tracking |
| **Scalability** | Vertical scale-up / Read replicas | Horizontal scale-out via auto-sharding | Scale-up / Caching graph traversal |

## 3. CAP Theorem Analysis
- **MongoDB Configuration:** Optimized for **CP (Consistency & Partition Tolerance)**. Primary-secondary replica sets ensure that write operations enforce strong consistency across active sessions.
- **PostgreSQL Configuration:** Prioritizes **CA (Consistency & Availability)** in single-node setup, transitioning to **CP** during failover routing.

## 4. Query Pattern Justification
1. **Document Embedding:** Nesting recent transactions and device arrays directly within the `user_profiles` document eliminates costly $N+1$ table joins during real-time transaction authorization.
2. **Graph Pattern Matching:** The Cypher query `MATCH path = (a:Account)-[:TRANSFERRED*3..5]->(a)` detects cyclic money laundering loops in $O(k)$ time, whereas performing the equivalent recursive CTE in SQL requires heavy join overhead across millions of rows.