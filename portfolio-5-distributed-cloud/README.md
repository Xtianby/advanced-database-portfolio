# Portfolio 5: Distributed and Cloud Databases

## Deliverables Summary
- `docker-compose.yml`: Multi-container Docker configuration deploying PostgreSQL primary-replica streaming replication nodes.
- `distributed_cloud_analysis.md`: Technical analysis covering WAL streaming replication, horizontal sharding, CAP/PACELC trade-offs, and failover routing.
- `replication_topology_evidence.png`: Execution output artifact showing docker container creation and `pg_stat_replication` status.

## How to Reproduce
1. Run `docker compose up -d` inside `portfolio-5-distributed-cloud/`.
2. Inspect streaming replication status via `docker exec -it omnipay_pg_primary psql -U postgres -c "SELECT * FROM pg_stat_replication;"`.