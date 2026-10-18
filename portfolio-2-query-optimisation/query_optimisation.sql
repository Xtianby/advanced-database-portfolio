-- =============================================================================
-- MIT 8103 Advanced Database Systems: Portfolio 2
-- Query Processing and Optimisation Script
-- Case Study: OmniPay Switch Systems
-- =============================================================================

-- 1. UNOPTIMIZED QUERY PROFILING
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT 
    u.full_name,
    a.account_number,
    a.bank_platform,
    COUNT(t.transaction_id) AS total_successful_transfers,
    SUM(t.amount) AS total_volume_ngn
FROM transactions t
JOIN accounts a ON t.source_account_id = a.account_id
JOIN users u ON a.user_id = u.user_id
WHERE t.status = 'SUCCESSFUL' 
  AND t.created_at >= NOW() - INTERVAL '30 days'
GROUP BY u.full_name, a.account_number, a.bank_platform
ORDER BY total_volume_ngn DESC
LIMIT 10;

-- 2. INDEX OPTIMIZATION ENGINEERING
CREATE INDEX idx_transactions_perf 
ON transactions (created_at) 
INCLUDE (source_account_id, amount) 
WHERE status = 'SUCCESSFUL';

CREATE INDEX idx_accounts_user_lookup 
ON accounts (account_id, user_id);

-- 3. OPTIMIZED QUERY RE-PROFILING
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT 
    u.full_name,
    a.account_number,
    a.bank_platform,
    COUNT(t.transaction_id) AS total_successful_transfers,
    SUM(t.amount) AS total_volume_ngn
FROM transactions t
JOIN accounts a ON t.source_account_id = a.account_id
JOIN users u ON a.user_id = u.user_id
WHERE t.status = 'SUCCESSFUL' 
  AND t.created_at >= NOW() - INTERVAL '30 days'
GROUP BY u.full_name, a.account_number, a.bank_platform
ORDER BY total_volume_ngn DESC
LIMIT 10;