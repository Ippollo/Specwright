# Example: Fixing N+1 Queries

The N+1 problem occurs when data is fetched in a loop, resulting in `1` query for the parent and `N` queries for children.

## 🔴 Before (Slow)

Retrieving latest posts for 50 users.
**Total Queries:** 1 (users) + 50 (posts) = **51 queries**.

```javascript
const users = await db.query("SELECT * FROM users LIMIT 50");

for (const user of users) {
  // ⚠️ CRITICAL: Await in loop causes serial database requests
  user.posts = await db.query("SELECT * FROM posts WHERE user_id = ?", [
    user.id,
  ]);
}
```

## 🟢 After (Fast)

Using "IN" clause to batch fetch.
**Total Queries:** 1 (users) + 1 (posts) = **2 queries**.

```javascript
/* 1. Fetch Users */
const users = await db.query("SELECT * FROM users LIMIT 50");
if (users.length === 0) return [];

/* 2. Collect IDs */
const userIds = users.map((u) => u.id);

/* 3. Fetch All Related Posts in ONE query */
const allPosts = await db.query("SELECT * FROM posts WHERE user_id IN (?)", [
  userIds,
]);

/* 4. Map Posts back to Users (In-Memory Join) */
const postsByUserId = _.groupBy(allPosts, "user_id");

for (const user of users) {
  user.posts = postsByUserId[user.id] || [];
}
```

## ⚠️ Gotchas

- **Max Packet Size:** `IN (...)` clause has a limit (often 64MB). If ID list is massive (e.g., 10,000+), batch into chunks of 1000.
