# Polymorphic Associations Pattern

Polymorphic associations allow a model to belong to more than one other model _on a single association_. Standard ForeignKey relationships connect exactly two tables. Polymorphic relationships allow one table to connect to "any" table.

**Common Use Case**: A `Comment` can belong to a `Post`, a `Video`, or a `Product`.

## Schema Design

Instead of `post_id`, `video_id`, `product_id` columns (mostly NULL), use a composite identifier.

### The Child Table (e.g., Comments)

```sql
CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT NOT NULL,

    -- The Polymorphic Link
    commentable_id UUID NOT NULL,       -- The ID of the parent
    commentable_type VARCHAR(50) NOT NULL, -- The Table Name (e.g., 'posts', 'videos')

    created_at TIMESTAMP DEFAULT NOW()
);

-- CRITICAL: Composite Index for performance
CREATE INDEX idx_comments_lookup
ON comments(commentable_type, commentable_id);
```

## Querying

### Fetch Comments for a specific Post

```sql
SELECT * FROM comments
WHERE commentable_type = 'post'
  AND commentable_id = '123-abc-post-uuid';
```

### Fetch Parent (Reverse lookup)

This is the tricky part. You can't do a simple SQL `JOIN` because the parent table varies per row.

**Option 1: Multiple Left Joins (SQL Level)**

```sql
SELECT c.*,
       p.title as post_title,
       v.title as video_title
FROM comments c
LEFT JOIN posts p ON c.commentable_id = p.id AND c.commentable_type = 'post'
LEFT JOIN videos v ON c.commentable_id = v.id AND c.commentable_type = 'video';
```

**Option 2: Application Level (ORM usually does this)**

1.  Fetch comments.
2.  Group by `commentable_type`.
3.  Run separate queries for each type: `ids` IN (...).
4.  Stitch together in memory.

## Pros & Cons

### Pros

- **DRY (Don't Repeat Yourself)**: One `comments` table serves the entire system.
- **Flexibility**: Add commenting to a new feature (`Events`) without changing the `comments` schema logic.

### Cons

- **No Foreign Key Integrity**: You typically cannot have a database-level `FOREIGN KEY` constraint that spans multiple tables. If a Post is deleted, the database won't automatically block it or cascade delete the comment (unless using triggers).
- **Complexity**: Queries are more complex to write manually.

## Alternative: Exclusive Belongs To

If you only have 2-3 parents, explicit nullable Foreign Keys are often better due to referential integrity.

```sql
CREATE TABLE comments (
    id UUID PRIMARY KEY,
    post_id UUID REFERENCES posts(id),    -- Nullable
    video_id UUID REFERENCES videos(id),  -- Nullable
    product_id UUID REFERENCES products(id), -- Nullable

    CHECK (
        (post_id IS NOT NULL)::int +
        (video_id IS NOT NULL)::int +
        (product_id IS NOT NULL)::int = 1
    ) -- Ensure exactly one parent is set
);
```

**Choose Polymorphic** when you have _many_ parent types or want to decouple modules.
**Choose Exclusive FKs** when you want strict Data Integrity and have few parent types.
