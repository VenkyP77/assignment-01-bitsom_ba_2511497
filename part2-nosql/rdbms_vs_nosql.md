## Database Recommendation

For a healthcare startup building a patient management system, I would recommend **MySQL** (or a relational database with full ACID compliance) as the primary database. Here is why, and how the recommendation evolves if fraud detection is added.

**Why MySQL for patient management:**

Healthcare data demands absolute correctness. A patient's medical records, prescriptions, lab results, billing, and insurance claims are highly structured and deeply interrelated. ACID properties (Atomicity, Consistency, Isolation, Durability) are non-negotiable here. If a doctor updates a prescription and the system crashes mid-write, atomicity guarantees the change either fully commits or fully rolls back, there is no half-written prescription. Consistency ensures that foreign key relationships (e.g., a prescription must reference an existing patient and a valid drug) are always enforced. In healthcare, corrupted or inconsistent data can literally be life-threatening.

From the CAP theorem perspective, a patient management system prioritizes **Consistency and Availability (CA)**. When a nurse pulls up a patient's allergy list before administering medication, the data must be current and correct, not "eventually consistent." MySQL, running on a single cluster or with synchronous replication, delivers exactly this. MongoDB follows the BASE model (Basically Available, Soft state, Eventually consistent), which means there is a window where different nodes might return different versions of a patient record. That is an unacceptable risk in healthcare.

**Would adding fraud detection change the recommendation?**

Partially. Fraud detection involves analyzing large volumes of unstructured or semi-structured data: claim patterns, behavioral logs, anomaly signals, and real-time event streams. This is where MongoDB (or a similar NoSQL store) excels, its flexible schema can ingest varied data shapes without rigid migrations, and it scales horizontally for high-throughput reads. However, this does not replace MySQL; it complements it. The recommended architecture becomes a **polyglot approach**: MySQL remains the system of record for patient data, billing, and clinical records (where ACID guarantees matter most), while MongoDB serves as the analytics and fraud-detection layer, ingesting event data and powering pattern-matching queries. This way, the startup gets the reliability of RDBMS where correctness is critical and the flexibility and scale of NoSQL where analytical throughput matters.
