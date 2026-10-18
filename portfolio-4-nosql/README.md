# Portfolio 4: NoSQL and Advanced Data Models

## Deliverables Summary
- `nosql_schema.json`: JSON Schema validation definition for user fraud profiles.
- `graph_model.cypher`: Neo4j Cypher script modeling accounts, devices, and circular transfer detection.
- `nosql_implementation.js`: MongoDB script setting up collections, indexes, and real-time risk aggregation pipelines.
- `nosql_suitability_analysis.md`: Technical report evaluating polyglot persistence, CAP theorem, and query suitability.
- `nosql_query_evidence.png`: Execution output screenshot.

## How to Reproduce
1. Run `mongosh < nosql_implementation.js` to execute the MongoDB collection setup and aggregation pipeline.
2. Load `graph_model.cypher` into Neo4j Browser to visualize entity relationships.