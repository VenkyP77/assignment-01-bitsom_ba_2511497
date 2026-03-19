## Storage Systems

Each of the four goals demands a different data access pattern, so a single storage system would be insufficient.

**Goal 1 - Predict patient readmission risk:** A Data Lakehouse (e.g., Apache Spark on the Central Data Lake) stores historical treatment records in Parquet format within the curated zone. This gives the ML pipeline direct access to large volumes of structured and semi-structured patient data without expensive ETL into a traditional warehouse. Feature engineering and model training run efficiently on columnar files at scale.

**Goal 2 - Plain English patient history queries:** A Vector Database (e.g., Pinecone or Weaviate) stores embeddings of clinical notes, discharge summaries, and past diagnoses. When a doctor asks "Has this patient had a cardiac event before?", the query is embedded and a similarity search retrieves the most relevant records. This is paired with a PostgreSQL operational database that holds structured patient history (diagnoses codes, dates, medications) for precise lookups when the NLP layer identifies specific entities.

**Goal 3 - Monthly management reports:** A Data Warehouse layer (OLAP cubes or a star schema in a system like Amazon Redshift or DuckDB) aggregates bed occupancy, department-wise costs, and revenue metrics. Pre-aggregated fact tables with date, department, and facility dimensions enable fast, repeatable reporting without scanning raw data each time.

**Goal 4 - Real-time ICU vitals:** A Time-Series Database (e.g., InfluxDB or Apache Kafka paired with TimescaleDB) ingests high-frequency sensor data from ICU monitors. Time-series databases are optimized for append-heavy, timestamp-indexed writes and support windowed queries (e.g., "average heart rate over the last 10 minutes") that relational databases handle poorly at this velocity.

## OLTP vs OLAP Boundary

The OLTP boundary encompasses the Hospital Management System and the Health/Medical Records System shown at the Data Sources layer. These operational systems handle real-time patient admissions, discharges, prescription updates, and billing transactions. They prioritize row-level reads and writes with ACID guarantees.

The OLAP boundary begins at the Central Data Lake's curated and consumption zones. Once raw data passes through the Data Ingestion and Processing layer (Batch ETL and Stream Processor), it is cleaned, de-duplicated, and written into the Data Quality Layer. From this point onward, data is read-optimized and organized for analytical workloads: the ML engine trains readmission models, the warehouse serves aggregated reports, and the vector database supports semantic search. The ingestion layer acts as the explicit boundary, transforming transactional row-oriented data into analytical columnar and embedded formats.

## Trade-offs

**Trade-off: System complexity vs. specialized performance.** Using four distinct storage technologies (relational DB, data lake, vector DB, time-series DB) delivers optimal performance for each goal but introduces significant operational overhead. Each system requires separate monitoring, backup strategies, schema management, and expertise.

**Mitigation:** The Central Data Lake serves as a single source of truth. All raw data lands in one place before being distributed to specialized stores, ensuring consistency. A unified metadata catalog tracks lineage across systems, and the Data Quality Layer enforces schema validation at ingestion time, preventing inconsistencies from propagating downstream. This hub-and-spoke pattern keeps the architecture maintainable despite the number of components.
