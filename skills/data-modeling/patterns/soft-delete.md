# Soft Delete Pattern

The "Soft Delete" pattern allows you to mark records as deleted without actually removing them from the database. This is crucial for data recovery, auditing, and maintaining referential integrity in history-sensitive applications.

## Core Concept

Instead of running `DELETE FROM table WHERE id = 1`, you perform an `UPDATE` on a specific column (usually `deleted_at`) to a timestamp.

### Schema Change

Add a nullable timestamp column to your table.

```sql
ALTER TABLE users ADD COLUMN deleted_at TIMESTAMP NULL;
```

- `NULL`: Record is active.
- `TIMESTAMP`: Record was deleted at this time.

## Implementation

### 1. Deleting a Record

```sql
UPDATE users
SET deleted_at = NOW()
WHERE id = 'user_123';
```

### 2. Querying Active Records (The Filter)

You MUST filter every query to exclude deleted records.

```sql
SELECT * FROM users
WHERE deleted_at IS NULL;
```

### 3. Restoring a Record

```sql
UPDATE users
SET deleted_at = NULL
WHERE id = 'user_123';
```

## Best Practices

### Create a View for Convenience

To avoid forgetting the `deleted_at IS NULL` clause, create a view for active records.

```sql
CREATE VIEW active_users AS
SELECT * FROM users WHERE deleted_at IS NULL;
```

Now you can query `active_users` without worrying about hidden deleted data.

### Unique Constraints

**Problem**: If you have a unique email constraint, you can't have two "deleted" users with the same email if you use a standard unique index.
**Solution**: Use a partial unique index.

```sql
-- Postgres
CREATE UNIQUE INDEX idx_unique_email_active
ON users(email)
WHERE deleted_at IS NULL;
```

This allows multiple deleted records with the same email, but ensures only one dictionary active user has that email.

### Cascade Implications

If you soft-delete a parent (e.g., `User`), you likely need to handle its children (e.g., `Posts`).

1.  **Application Logic**: Your active record pattern / ORM might handle this (e.g., Prisma `interactiveTransactions`).
2.  **Soft Delete Children**: Also set `deleted_at` on all child records.
3.  **Leave Children**: Sometimes you want to keep posts visible but show "Deleted User" as the author.

## ORM Examples

### Prisma Middleware / Extension

```typescript
// Example of a Prisma Client extension for soft delete
const prisma = new PrismaClient().$extends({
  query: {
    user: {
      async delete({ args }) {
        return prisma.user.update({
          ...args,
          data: { deleted_at: new Date() },
        });
      },
      async findMany({ args }) {
        args.where = { ...args.where, deleted_at: null };
        return prisma.user.findMany(args);
      },
    },
  },
});
```

## When NOT to use

- **GDPR / Right to be Erasure**: If a user requests deletion for privacy, you typically must _Hard Delete_ (actually remove) the data, or anonymize it completely.
- **High Volume Logs**: For logging tables that grow indefinitely, just delete old data. Soft deleting logging data is usually confusing and wastes space.
