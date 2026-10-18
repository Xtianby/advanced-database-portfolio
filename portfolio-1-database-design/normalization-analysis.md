# Relational Normalization Proof: OmniPay Switch Systems

## 1. Unnormalized Form (UNF)
In an unnormalized payment log, customer data, account balances, and transaction histories are stored in a single flat file with repeating groups:
`UNF_Record(CustomerID, FirstName, LastName, Email, BankPlatform, AccountNumber, AccountType, Balance, Status, TxID, TxAmount, TxStatus, LedgerEntries[EntryID, Type, Amount])`

## 2. First Normal Form (1NF)
- **Rule:** Eliminate repeating groups and ensure atomic values for every column.
- **Action:** Extracted multi-valued ledger arrays into separate rows and defined composite key `{TxID, EntryID}`.
- **Schema:** `Transaction_1NF(CustomerID, FirstName, LastName, Email, AccountNumber, Balance, TxID, EntryID, EntryType, EntryAmount)`

## 3. Second Normal Form (2NF)
- **Rule:** Satisfy 1NF and remove partial dependencies (where a non-key attribute depends on only part of a composite primary key).
- **Action:** Extracted customer profile fields and account balances into independent relations because they depend on `CustomerID` or `AccountNumber`, not the transaction key.
- **Functional Dependencies:**
  - $FD1: \text{CustomerID} \rightarrow \{\text{FirstName}, \text{LastName}, \text{Email}\}$
  - $FD2: \text{AccountNumber} \rightarrow \{\text{CustomerID}, \text{BankPlatform}, \text{Balance}, \text{Status}\}$

## 4. Third Normal Form (3NF)
- **Rule:** Satisfy 2NF and eliminate transitive dependencies ($X \rightarrow Y$ and $Y \rightarrow Z$).
- **Action:** Removed calculated balances and counterparty details from individual transaction records. Financial audit history is enforced strictly via double-entry bookkeeping in `ledger_entries`.

## 5. Boyce-Codd Normal Form (BCNF)
- **Rule:** A relation is in BCNF if for every non-trivial functional dependency $X \rightarrow Y$, $X$ is a **Super Key**.
- **Proof Across Entities:**
  1. `users`: Functional dependency $user\_id \rightarrow \{national\_id, full\_name, email, phone\_number\}$. Determinant `user_id` is the Primary Key.
  2. `accounts`: Functional dependency $account\_id \rightarrow \{user\_id, account\_number, balance\}$. Determinant `account_id` is the Primary Key.
  3. `transactions`: Functional dependency $transaction\_id \rightarrow \{source\_account\_id, destination\_account\_id, amount\}$. Determinant `transaction_id` is the Primary Key.
  4. `ledger_entries`: Functional dependency $entry\_id \rightarrow \{transaction\_id, account\_id, entry\_type, amount\}$. Determinant `entry_id` is the Primary Key.

**Conclusion:** All functional determinants across all core tables are candidate keys. The schema strictly satisfies **BCNF**.