// =============================================================================
// MIT 8103 Advanced Database Systems: Portfolio 4
// Neo4j Graph Model - Fraud Ring & Circular Transfer Detection
// Case Study: OmniPay Switch Systems
// =============================================================================

// 1. CREATE NODES (Entities)
CREATE (u1:User {id: "8d936931-ec50-464a-9977-02c4c99545e2", name: "Chidi Okonkwo", kyc: 3})
CREATE (u2:User {id: "c45acb2f-79e2-41b5-a840-cb33b3bcab67", name: "Fatima Abubakar", kyc: 2})
CREATE (u3:User {id: "e12bc34a-1122-3344-5566-778899aabbcc", name: "Tunde Balogun", kyc: 1})

CREATE (a1:Account {number: "0000000001", type: "Digital Wallet"})
CREATE (a2:Account {number: "0000000002", type: "Savings"})
CREATE (a3:Account {number: "0000000003", type: "Current"})

CREATE (d1:Device {fingerprint: "DEV-MAC-99812", os: "Android"})
CREATE (ip1:IPAddress {ip: "102.89.23.45", location: "Lagos, Nigeria"})

// 2. CREATE RELATIONSHIPS (Edges)
CREATE (u1)-[:OWNS]->(a1)
CREATE (u2)-[:OWNS]->(a2)
CREATE (u3)-[:OWNS]->(a3)

CREATE (u1)-[:LOGGED_IN_FROM {timestamp: datetime()}]->(d1)
CREATE (u2)-[:LOGGED_IN_FROM {timestamp: datetime()}]->(d1) // Suspicious: Shared Device

CREATE (d1)-[:USES_IP]->(ip1)

CREATE (a1)-[:TRANSFERRED {amount: 500000, reference: "TX-901"}]->(a2)
CREATE (a2)-[:TRANSFERRED {amount: 490000, reference: "TX-902"}]->(a3)
CREATE (a3)-[:TRANSFERRED {amount: 485000, reference: "TX-903"}]->(a1) // Circular Transfer Loop

// 3. FRAUD DETECTION QUERY: Detect Circular Transfer Loops (Length 3 to 5)
MATCH path = (a:Account)-[:TRANSFERRED*3..5]->(a)
RETURN path;

// 4. SUSPICIOUS DEVICE REUSE QUERY: Users Sharing the Same Hardware Fingerprint
MATCH (u1:User)-[:LOGGED_IN_FROM]->(d:Device)<-[:LOGGED_IN_FROM]-(u2:User)
WHERE u1 <> u2
RETURN u1.name, u2.name, d.fingerprint;