---
name: data-modeling
description: Use when designing database schemas, adding tables/collections, choosing SQL vs NoSQL, writing migration scripts, or optimizing query performance via indexing. Covers normalization, relationship patterns, ORM best practices, and zero-downtime migrations.
---

# Data Modeling & Persistence

This skill ensures your data layer is scalable, consistent, and maintainable. It covers schema design, relationship patterns, and safe migration workflows.

## When to Use

- Designing a new database schema
- Adding features that require new tables/collections
- Choosing a database technology (SQL vs NoSQL)
- Writing migration scripts
- Optimizing query performance via indexing

## 1. Schema Design Principles (SQL)

### Normalization

- **1NF**: Atomic values (no comma-separated lists in columns).
- **2NF**: No partial dependencies (everything depends on Primary Key).
- **3NF**: No transitive dependencies (no non-key columns depending on other non-key columns).
- **Denormalization**: Only strictly for read-performance (e.g., `cached_user_name` on `comments` table).

### Naming Conventions

- **Tables**: Plural snake_case (`users`, `order_items`).
- **Columns**: specific snake_case (`created_at`, `is_active`, `user_id`).
- **Primary Keys**: `id` (UUIDv7 or BigInt preferred over random UUIDv4 for indexing).
- **Foreign Keys**: `[table]_id` or `[entity]_id`.

### Field Types

- **Timestamps**: Always include `created_at` and `updated_at`.
- **Booleans**: Prefix with `is_` or `has_` (e.g., `is_published`).
- **Enums**: Use native Enums for fixed sets, or reference tables for dynamic sets.

## 2. Relationship Patterns

### One-to-One (1:1)

- **Use Case**: User Profile, Config Settings.
- **Pattern**: Unique Foreign Key on the "child" table.
  ```sql
  CREATE TABLE profiles (
      user_id UUID UNIQUE REFERENCES users(id)
  );
  ```

### One-to-Many (1:N)

- **Use Case**: User -> Posts, Team -> Players.
- **Pattern**: Foreign Key on the "Many" side.
  ```sql
  CREATE TABLE posts (
      author_id UUID REFERENCES users(id)
  );
  ```

### Many-to-Many (M:N)

- **Use Case**: Students <-> Classes, Tags <-> Articles.
- **Pattern**: Junction (Join) Table.
  ```sql
  CREATE TABLE article_tags (
      article_id UUID REFERENCES articles(id),
      tag_id UUID REFERENCES tags(id),
      PRIMARY KEY (article_id, tag_id)
  );
  ```

## 3. Indexing Strategies

Proper indexing is the #1 factor in database performance.

### Index Types

| Type       | Use Case                               | Example                            |
| ---------- | -------------------------------------- | ---------------------------------- |
| **B-tree** | Default. Equality (=) and Range (<, >) | `created_at`, `user_id`, `email`   |
| **Hash**   | Equality only. Smaller size.           | Exact UUID lookups (Postgres only) |
| **GIN**    | JSONB, Arrays, Full-text search        | `metadata` JSONB column            |
| **GiST**   | Geometric data, generic ranges         | Location data, Time ranges         |

### Guidelines

- **Primary Keys**: Indexed automatically.
- **Foreign Keys**: ALWAYS index these. Most joins happen here.
- **Filters**: Index columns frequently used in `WHERE` clauses.
- **Composite**: Index `(a, b)` if you query `WHERE a = x AND b = y`. Order matters (left-to-right).
- **Partial**: Index subset of data. `CREATE INDEX idx_active_users ON users(email) WHERE status = 'active'`.

### When NOT to Index

- **Low Cardinality**: Columns with few unique values (e.g., `gender`, `is_active` boolean) relative to table size. The optimizer will ignore them in favor of a table scan.
- **Write-Heavy Tables**: Every index slows down `INSERT`/`UPDATE` operations. DELETE unused indexes.

## 4. ORM Best Practices

### Prisma / Drizzle / TypeORM

- **Selection**: Select only fields you need.
  - ❌ `findMany()` (selects _all_)
  - ✅ `findMany({ select: { id: true, name: true } })`
- **Transactions**: Wrap multiple related writes in a transaction.
- **N+1 Prevention**: Use `include` or `with` to fetch relations in a single query.
  - ❌ Loop over users and fetch profile for each.
  - ✅ Fetch users `with` profiles in one go.

## 5. Migration Workflow

Evolving the schema without downtime or data loss.

1.  **Modify Schema**: Update `schema.prisma` or Drizzle schema.
2.  **Generate Migration**: Create SQL file. `npx prisma migrate dev --name add_profile`.
3.  **Review SQL**: Check for destructive actions (DROPs).
4.  **Apply**: Run migration.
5.  **Regenerate Client**: Update Typescript types.

### Zero-Downtime Strategies

- **Adding Required Column**:
  1. Add column as `NULL`.
  2. Backfill data for existing rows.
  3. Alter column to `NOT NULL`.
- **Renaming Column**:
  1. Add new column.
  2. Double-write to both old and new columns in app.
  3. Backfill old data to new column.
  4. Switch reads to new column.
  5. Remove old column.

## 6. Query Performance

### Explain Analyze

Before optimizing, measure.

```sql
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'test@example.com';
```

Look for `Seq Scan` (bad) vs `Index Scan` (good) on large tables.

### Common Performance Killers

- **SELECT \***: Fetches unnecessary data (especially bad with JSONB/Text columns).
- **N+1 Queries**: See ORM section.
- **Unindexed Joins**: Joining on columns without indexes forces a full table hash join.
- **Deep Offset Pagination**: `OFFSET 100000` scans and discards 100k rows. Use Cursor/Keyset pagination instead (`WHERE created_at < last_seen_date`).

## 7. NoSQL Patterns (MongoDB / DynamoDB)

### MongoDB Aggregation Pipelining

Move logic to the DB, not the app.

```js
db.orders.aggregate([
  { $match: { status: "completed" } },
  { $group: { _id: "$customerId", total: { $sum: "$amount" } } },
]);
```

### DynamoDB Indexing (GSI)

- **Partition Key (PK)**: Uniform distribution is key.
- **Sort Key (SK)**: Enables range queries and sorting.
- **Global Secondary Index (GSI)**: Create a "view" of your data with a different PK/SK to support alternative access patterns.
  - _Main Table PK_: `UserId`.
  - _GSI PK_: `Email`.
  - Allows lookup by UserID AND Email.

## 8. Advanced Patterns

Deep-dive patterns located in `patterns/`:

- **[Soft Deletes](patterns/soft-delete.md)**: Safely "archiving" data instead of permanent deletion.
- **[Audit Trails](patterns/audit-trails.md)**: tracking who changed what and when.
- **[Polymorphic Associations](patterns/polymorphic-associations.md)**: Relationships that can point to multiple table types.

## Deployment Checklist

- [ ] **Indexes** created for all Foreign Keys and query filters?
- [ ] **Unique Constraints** enforced at DB level?
- [ ] **Cascade rules** (Delete/Update) defined?
- [ ] **Data types** appropriate (e.g., Decimal for money, UUID for IDs)?
- [ ] **Migration safety** checked (no locking of large tables)?
