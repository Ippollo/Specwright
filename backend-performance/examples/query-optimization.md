# Example: Database Query Optimization

A real-world breakdown of optimizing a slow SQL query.

## The Problem

**Goal:** Find active orders for a specific user, sorted by date.
**Query:**

```sql
SELECT * FROM orders
WHERE user_id = 452
  AND status = 'active'
ORDER BY created_at DESC;
```

**Execution Time:** 1200ms (Slow!)

## Step 1: EXPLAIN ANALYZE

Running `EXPLAIN ANALYZE` reveals the database execution plan.

```sql
EXPLAIN ANALYZE SELECT ...
```

**Output (Before):**

```
Seq Scan on orders  (cost=0.00..15432.00 rows=523 width=128)
  Filter: ((user_id = 452) AND (status = 'active'::text))
```

- **Seq Scan:** The DB is reading 1,000,000 rows one by one to find matches. This is disaster.

## Step 2: Adding an Index

We search by `user_id` and `status`.

```sql
CREATE INDEX idx_orders_user_status ON orders (user_id, status);
```

**Output (After - Attempt 1):**

```
Bitmap Heap Scan on orders ...
  Recheck Cond: ((user_id = 452) AND (status = 'active'::text))
  -> Bitmap Index Scan on idx_orders_user_status ...
Sort Method: quicksort  Memory: 25kB
```

**Time:** 80ms.
**Note:** It's faster, but still doing a "Sort" operation in memory because our Index didn't cover the `ORDER BY`.

## Step 3: Perfecting the Index (Composite + Sort)

Include the sort column in the index.

```sql
DROP INDEX idx_orders_user_status;
CREATE INDEX idx_orders_perf ON orders (user_id, status, created_at DESC);
```

**Output (Final):**

```
Index Scan using idx_orders_perf on orders ...
```

**Time:** 5ms. 🚀

## Lesson

Indexes must cover:

1.  **Columns in WHERE** (Equality first, then Ranges).
2.  **Columns in ORDER BY** (to avoid sorting).
