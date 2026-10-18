// =============================================================================
// MIT 8103 Advanced Database Systems: Portfolio 4
// MongoDB Implementation & Aggregation Pipeline
// Case Study: OmniPay Switch Systems
// =============================================================================

// Connect to omnipay_nosql database
db = db.getSiblingDB('omnipay_nosql');

// 1. Drop existing collection for clean setup
db.user_profiles.drop();

// 2. Insert Sample Documents
db.user_profiles.insertMany([
  {
    user_id: "8d936931-ec50-464a-9977-02c4c99545e2",
    national_id: "CUST-00001",
    full_name: "Chidi Okonkwo",
    email: "chidi.okonkwo@omnipay.io",
    kyc_level: 3,
    accounts: [
      { account_number: "0000000001", currency: "NGN", balance: 350000.50, status: "ACTIVE" }
    ],
    device_fingerprints: [
      { device_id: "DEV-MAC-99812", ip_address: "102.89.23.45", last_login: new Date("2026-10-15T10:30:00Z") }
    ],
    recent_transactions: [
      { transaction_id: "TX-101", destination_account: "0000000002", amount: 150000.00, risk_score: 0.12, timestamp: new Date("2026-10-16T12:00:00Z") },
      { transaction_id: "TX-102", destination_account: "0000000003", amount: 250000.00, risk_score: 0.85, timestamp: new Date("2026-10-18T08:15:00Z") }
    ]
  },
  {
    user_id: "c45acb2f-79e2-41b5-a840-cb33b3bcab67",
    national_id: "CUST-00002",
    full_name: "Fatima Abubakar",
    email: "fatima.abubakar@omnipay.io",
    kyc_level: 2,
    accounts: [
      { account_number: "0000000002", currency: "NGN", balance: 120000.00, status: "ACTIVE" }
    ],
    device_fingerprints: [
      { device_id: "DEV-MAC-99812", ip_address: "102.89.23.45", last_login: new Date("2026-10-17T14:20:00Z") }
    ],
    recent_transactions: [
      { transaction_id: "TX-103", destination_account: "0000000001", amount: 450000.00, risk_score: 0.92, timestamp: new Date("2026-10-18T11:00:00Z") }
    ]
  }
]);

// 3. Create Compound Index for Rapid Fraud Lookups
db.user_profiles.createIndex({ "device_fingerprints.ip_address": 1, kyc_level: -1 });

// 4. REAL-TIME FRAUD AGGREGATION PIPELINE
// Identifies high-risk transactions (>0.75 risk score) grouped by user
print("--- HIGH RISK TRANSACTION AGGREGATION RESULT ---");
var highRiskReport = db.user_profiles.aggregate([
  { $unwind: "$recent_transactions" },
  { $match: { "recent_transactions.risk_score": { $gte: 0.75 } } },
  {
    $group: {
      _id: "$full_name",
      email: { $first: "$email" },
      high_risk_tx_count: { $sum: 1 },
      total_high_risk_volume: { $sum: "$recent_transactions.amount" },
      max_risk_score: { $max: "$recent_transactions.risk_score" }
    }
  },
  { $sort: { total_high_risk_volume: -1 } }
]);

printjson(highRiskReport.toArray());