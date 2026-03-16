## ETL Decisions

### Decision 1: Date Format Standardization

**Problem:** The raw `date` column contained three inconsistent formats: `DD/MM/YYYY` (e.g., `29/08/2023`), `DD-MM-YYYY` (e.g., `12-12-2023`), and `YYYY-MM-DD` (e.g., `2023-02-05`). Loading these directly into a DATE column would cause errors or incorrect dates to be recorded. (e.g., `11-12-2023` could be misread as November 12 or an invalid format depending on the database).

**Resolution:** All dates were parsed according to their original format and converted to `YYYY-MM-DD` (ISO 8601), which is the SQL standard DATE literal format. The `dim_date` dimension table stores the full date along with pre-computed attributes (day, month, quarter, year, day of week) to avoid repeated date parsing in queries.

### Decision 2: Missing Store City Values

**Problem:** Several rows had NULL/empty `store_city` values while the `store_name` was still present (e.g., `store_name = 'Mumbai Central'` with `store_city` blank). This affected 12 rows across all five stores in the dataset.

**Resolution:** Since each store name uniquely maps to a single city (Chennai Anna to Chennai, Delhi South to Delhi, Bangalore MG to Bangalore, Mumbai Central to Mumbai, Pune FC Road to Pune), the missing city values were inferred from the store name. The `dim_store` dimension table was then populated with the complete store-to-city mapping, eliminating NULLs entirely.

### Decision 3: Inconsistent Category Naming and Casing

**Problem:** The `category` column had two types of inconsistencies. First, casing varied between lowercase and title case (e.g., `electronics` vs `Electronics`). Second, the same category appeared under different names: grocery items were labeled as both `Grocery` and `Groceries` across different rows.

**Resolution:** All category values were standardized to title case and unified under a single canonical name: `electronics`/`Electronics` to `Electronics`, and `Grocery`/`Groceries` to `Groceries`. The `dim_product` dimension table stores each product with its cleaned category, ensuring consistent grouping in analytical queries.
