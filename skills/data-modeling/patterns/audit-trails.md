# Audit Trails Pattern

Audit trails track **who** changed **what**, **when**, and **why**. This is essential for security, compliance, and debugging data integrity issues.

## Strategies

### 1. Application-Level Auditing

The application code explicitly writes to an audit log table whenever a mutation occurs.

**Pros**:

- Database agnostic.
- Can capture "business context" (e.g., "User changed password via reset flow" vs "User changed password via profile").
- Easier to manage in ORM.

**Cons**:

- Can be bypassed if someone uses raw SQL or another tool to access the DB.
- Adds latency to application requests.

### 2. Database-Level Auditing (Triggers)

The database automatically captures changes using Triggers.

**Pros**:

- Guarantees capture of ALL changes, even from raw SQL console.
- Zero extra logic in application code.

**Cons**:

- Harder to capture "User ID" if the DB connection is shared/pooled (generic `db_user`).
- Syntax is database-specific (PL/pgSQL for Postgres, T-SQL for SQL Server).

---

## Schema Design

A versatile `audit_logs` table structure.

```sql
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,         -- ID of the changed record
    action TEXT NOT NULL,            -- INSERT, UPDATE, DELETE
    old_values JSONB,                -- Snapshot before change
    new_values JSONB,                -- Snapshot after change
    changed_by_user_id UUID,         -- Application user ID
    changed_at TIMESTAMP DEFAULT NOW(),
    client_ip TEXT,
    user_agent TEXT
);

CREATE INDEX idx_audit_record ON audit_logs(table_name, record_id);
```

---

## Postgres Trigger Implementation (Reference)

This is a robust "catch-all" trigger function for Postgres.

```sql
CREATE OR REPLACE FUNCTION trigger_audit_log() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_logs (
        table_name,
        record_id,
        action,
        old_values,
        new_values,
        changed_at
    )
    VALUES (
        TG_TABLE_NAME,
        COALESCE(NEW.id::text, OLD.id::text),
        TG_OP,                           -- Operation: INSERT/UPDATE/DELETE
        to_jsonb(OLD),                   -- Previous state
        to_jsonb(NEW),                   -- New state
        NOW()
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

**Attach to a Table:**

```sql
CREATE TRIGGER audit_users
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW EXECUTE FUNCTION trigger_audit_log();
```

---

## Best Practices

1.  **JSONB for Flexibility**: Storing `old_values` and `new_values` as JSONB allows you to audit different tables with different schemas in a single central log without strict column mapping.
2.  **Separate Retention Policy**: Audit logs grow FAST. Implement a retention policy (e.g., move to cold storage (S3/Data Lake) after 1 year, delete after 7 years).
3.  **Read-Only Access**: Ensure the application user typically _cannot_ UPDATE or DELETE from the `audit_logs` table to prevent tampering.
4.  **Dont Audit Everything**: Exclude high-velocity, low-value tables (like `user_sessions` or `cache_entries`) to save space.
