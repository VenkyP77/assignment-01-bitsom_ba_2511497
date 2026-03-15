## Anomaly Analysis

### Insert Anomaly

**Problem:** We cannot add a new product to the system without creating a corresponding order transaction.

**Example:** Product P008 (Webcam, Electronics, Rs. 2100) only exists in the dataset because of order ORD1185 (row 13). If we wanted to register a new product: say P009, "Keyboard", Electronics, Rs. 1500, there is no way to store it without creating an order row with a customer, date, sales rep, and quantity. The flat table forces us to add NULL data for unrelated columns just to record a product.

---

### Update Anomaly

**Problem:** The same entity's data is repeated across many rows, so updating it requires changing every occurrence. Partial updates will lead to inconsistencies in the dataset.

**Example:** Sales rep SR01 (Deepak Joshi) has `office_address` listed as `"Mumbai HQ, Nariman Point, Mumbai - 400021"` in most rows (e.g., rows 3, 10, 11, 16, 20, etc.), but the same SR01 appears with a truncated address `"Mumbai HQ, Nariman Pt, Mumbai - 400021"` in rows 39, 58, 91, 94, etc.. This inconsistency ("Nariman Point" vs. "Nariman Pt") is a direct result of the update anomaly, because the address is duplicated across multiple rows, some were updated / entered differently, creating inconsistencies int he database.

---

### Delete Anomaly

**Problem:** Deleting an order can unintentionally delete information about other entities.

**Example:** Product P008 (Webcam, Electronics, Rs. 2100) appears in only one order: ORD1185 (row 13, customer C003 Amit Verma). If this order is deleted from the dataset, maybe because it was cancelled, we will lose all knowledge that about product P008, including its name, category, and unit price. The product information is entirely dependent on the existence of that single order row.

---

## Normalization Justification

My manager's argument that "keeping everything in one table is simpler" is understandable at first glance but falls apart under real-world conditions, as this very dataset demonstrates.

**Data inconsistency is already happening.** Sales rep SR01 (Deepak Joshi) has his office address recorded two different ways in the flat file. "Nariman Point" in most rows and "Nariman Pt" in others (e.g., rows 39 vs. 40). In a normalized schema, this address would exist in exactly one row of a `sales_reps` table. In the flat file, it is duplicated across 60+ rows, and the inconsistency proves that maintaining accuracy across redundant data is very unreliable. A single typo in any record during data entry will propagate silently.

**We cannot represent reality without workarounds.** The company sells product P008 (Webcam), but it only appears in one order (ORD1185). If that order is cancelled and consequently the record is deleted, then the product will vanish from the database entirely. Similarly, if we onboard a new customer who hasn't placed an order yet, there is literally no place to store their information. Normalization will solve both problems by giving products and customers their own master tables, independent of the orders table.

**Storage waste and update cost are real.** Every row repeats the full customer name, email, city, product name, category, price, sales rep name, email, and office address. With 186 rows, Deepak Joshi's name and email are stored over 60 times. If he changes his email, we must update every one of those rows and missing even one creates a silent inconsistency. This is not only extremely ineeficient but also error-prone. In a normalized schema, it is just a single-row update.

**Normalization is not over-engineering.**  It is the minimum safeguard against the exact problems this dataset already exhibits. The "simplicity" of one table is an illusion. It trades structural clarity for hidden data corruption, wasted storage, and a fragile deletion control. The slight additional complexity of JOINs is a small price to pay for data that is accurate, consistent, and complete. It is also efficient to update records or add new ones.
