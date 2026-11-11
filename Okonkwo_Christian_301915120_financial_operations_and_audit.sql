-- =============================================================================
-- MIT 8103 Advanced Database Systems: Financial Ledger Engine
-- Operations: Transfer Funds, Reverse Failed Transactions, Audit Account Balances
-- Engine: PostgreSQL 15+ | Case Study: OmniPay Switch Systems
-- =============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- -----------------------------------------------------------------------------
-- 1. TRANSFER FUNDS FUNCTION (ACID Double-Entry Ledger)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION process_fund_transfer(
    p_source_acc UUID,
    p_dest_acc UUID,
    p_amount NUMERIC(18,4),
    p_reference VARCHAR(64)
) RETURNS VOID AS $$
DECLARE
    v_source_balance NUMERIC(18,4);
    v_tx_id UUID;
BEGIN
    -- Enforce deterministic lock ordering (prevents race-condition deadlocks)
    IF p_source_acc < p_dest_acc THEN
        PERFORM balance FROM accounts WHERE account_id = p_source_acc FOR UPDATE;
        PERFORM balance FROM accounts WHERE account_id = p_dest_acc FOR UPDATE;
    ELSE
        PERFORM balance FROM accounts WHERE account_id = p_dest_acc FOR UPDATE;
        PERFORM balance FROM accounts WHERE account_id = p_source_acc FOR UPDATE;
    END IF;

    -- Verify source account balance
    SELECT balance INTO v_source_balance FROM accounts WHERE account_id = p_source_acc;
    IF v_source_balance < p_amount THEN
        RAISE EXCEPTION 'Insufficient Funds: Available NGN %, Required NGN %', v_source_balance, p_amount;
    END IF;

    -- Create Main Transaction Record
    INSERT INTO transactions (source_account_id, destination_account_id, amount, transaction_type, status, reference)
    VALUES (p_source_acc, p_dest_acc, p_amount, 'TRANSFER', 'SUCCESSFUL', p_reference)
    RETURNING transaction_id INTO v_tx_id;

    -- Update Account Balances
    UPDATE accounts SET balance = balance - p_amount WHERE account_id = p_source_acc;
    UPDATE accounts SET balance = balance + p_amount WHERE account_id = p_dest_acc;

    -- Double-Entry Ledger Entries
    INSERT INTO ledger_entries (transaction_id, account_id, entry_type, amount)
    VALUES 
        (v_tx_id, p_source_acc, 'DEBIT', p_amount),
        (v_tx_id, p_dest_acc, 'CREDIT', p_amount);

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Transaction aborted and rolled back automatically. Error: %', SQLERRM;
    RAISE;
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------------------------------
-- 2. REVERSE FAILED / DISPUTED TRANSACTION FUNCTION
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION reverse_transaction(
    p_original_tx_id UUID,
    p_reversal_reference VARCHAR(64)
) RETURNS VOID AS $$
DECLARE
    v_source_acc UUID;
    v_dest_acc UUID;
    v_amount NUMERIC(18,4);
    v_status VARCHAR(15);
    v_reversal_tx_id UUID;
BEGIN
    -- Fetch original transaction details and lock record
    SELECT source_account_id, destination_account_id, amount, status
    INTO v_source_acc, v_dest_acc, v_amount, v_status
    FROM transactions 
    WHERE transaction_id = p_original_tx_id 
    FOR UPDATE;

    IF v_status <> 'SUCCESSFUL' THEN
        RAISE EXCEPTION 'Cannot reverse transaction %: Status is %', p_original_tx_id, v_status;
    END IF;

    -- Lock both accounts in deterministic order
    IF v_source_acc < v_dest_acc THEN
        PERFORM balance FROM accounts WHERE account_id = v_source_acc FOR UPDATE;
        PERFORM balance FROM accounts WHERE account_id = v_dest_acc FOR UPDATE;
    ELSE
        PERFORM balance FROM accounts WHERE account_id = v_dest_acc FOR UPDATE;
        PERFORM balance FROM accounts WHERE account_id = v_source_acc FOR UPDATE;
    END IF;

    -- Record Reversal Transaction
    INSERT INTO transactions (source_account_id, destination_account_id, amount, transaction_type, status, reference)
    VALUES (v_dest_acc, v_source_acc, v_amount, 'WITHDRAWAL', 'SUCCESSFUL', p_reversal_reference)
    RETURNING transaction_id INTO v_reversal_tx_id;

    -- Reverse Balances (Credit original source, Debit original destination)
    UPDATE accounts SET balance = balance + v_amount WHERE account_id = v_source_acc;
    UPDATE accounts SET balance = balance - v_amount WHERE account_id = v_dest_acc;

    -- Double-Entry Ledger Reversal Audit Entries
    INSERT INTO ledger_entries (transaction_id, account_id, entry_type, amount)
    VALUES 
        (v_reversal_tx_id, v_dest_acc, 'DEBIT', v_amount),
        (v_reversal_tx_id, v_source_acc, 'CREDIT', v_amount);

    -- Mark Original Transaction as REVERSED
    UPDATE transactions SET status = 'FAILED' WHERE transaction_id = p_original_tx_id;

END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------------------------------
-- 3. AUDIT ACCOUNT BALANCES FUNCTION (Ledger Reconciliation)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION audit_account_balances()
RETURNS TABLE (
    account_id UUID,
    account_number VARCHAR(20),
    recorded_balance NUMERIC(18,4),
    calculated_ledger_balance NUMERIC(18,4),
    discrepancy NUMERIC(18,4),
    audit_status VARCHAR(20)
) AS $$
BEGIN
    RETURN QUERY
    WITH ledger_summary AS (
        SELECT 
            le.account_id,
            SUM(CASE WHEN le.entry_type = 'CREDIT' THEN le.amount ELSE -le.amount END) AS net_ledger_amount
        FROM ledger_entries le
        GROUP BY le.account_id
    )
    SELECT 
        a.account_id,
        a.account_number,
        a.balance AS recorded_balance,
        COALESCE(ls.net_ledger_amount, 0.0000) AS calculated_ledger_balance,
        (a.balance - COALESCE(ls.net_ledger_amount, 0.0000)) AS discrepancy,
        CASE 
            WHEN (a.balance - COALESCE(ls.net_ledger_amount, 0.0000)) = 0.0000 THEN 'BALANCED'
            ELSE 'DISCREPANCY_DETECTED'
        END AS audit_status
    FROM accounts a
    LEFT JOIN ledger_summary ls ON a.account_id = ls.account_id;
END;
$$ LANGUAGE plpgsql;
