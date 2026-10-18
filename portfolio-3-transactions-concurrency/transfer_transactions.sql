-- =============================================================================
-- MIT 8103 Advanced Database Systems: Portfolio 3
-- Transactions and Concurrency Script
-- Case Study: OmniPay Switch Systems
-- =============================================================================

-- 1. PL/PGSQL ACID FUND TRANSFER FUNCTION
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
    IF p_source_acc < p_dest_acc THEN
        PERFORM balance FROM accounts WHERE account_id = p_source_acc FOR UPDATE;
        PERFORM balance FROM accounts WHERE account_id = p_dest_acc FOR UPDATE;
    ELSE
        PERFORM balance FROM accounts WHERE account_id = p_dest_acc FOR UPDATE;
        PERFORM balance FROM accounts WHERE account_id = p_source_acc FOR UPDATE;
    END IF;

    SELECT balance INTO v_source_balance FROM accounts WHERE account_id = p_source_acc;
    IF v_source_balance < p_amount THEN
        RAISE EXCEPTION 'Insufficient Funds: Available NGN %, Required NGN %', v_source_balance, p_amount;
    END IF;

    INSERT INTO transactions (source_account_id, destination_account_id, amount, transaction_type, status, reference)
    VALUES (p_source_acc, p_dest_acc, p_amount, 'TRANSFER', 'SUCCESSFUL', p_reference)
    RETURNING transaction_id INTO v_tx_id;

    UPDATE accounts SET balance = balance - p_amount WHERE account_id = p_source_acc;
    UPDATE accounts SET balance = balance + p_amount WHERE account_id = p_dest_acc;

    INSERT INTO ledger_entries (transaction_id, account_id, entry_type, amount)
    VALUES 
        (v_tx_id, p_source_acc, 'DEBIT', p_amount),
        (v_tx_id, p_dest_acc, 'CREDIT', p_amount);

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Transaction aborted and rolled back. Error: %', SQLERRM;
    RAISE;
END;
$$ LANGUAGE plpgsql;

-- 2. ISOLATION LEVEL DEMONSTRATION
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT balance FROM accounts WHERE account_number = '0000000001';
COMMIT;