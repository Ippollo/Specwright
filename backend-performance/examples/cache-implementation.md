# Example: Caching Implementation (Cache-Aside)

Implementing the standard "Cache-Aside" pattern for a User Profile service.

## Flow

1.  Check Cache (Redis).
2.  If Found (Hit) -> Return.
3.  If Missing (Miss) -> Fetch DB -> Write Key to Cache -> Return.

## Code (Node.js/Redis)

```typescript
import { createClient } from "redis";
const redis = createClient();

async function getUserProfile(userId: string) {
  const cacheKey = `user:${userId}:profile`;

  // 1. Try Cache
  const cached = await redis.get(cacheKey);
  if (cached) {
    console.log("Cache Hit");
    return JSON.parse(cached);
  }

  // 2. Fetch from DB (Cache Miss)
  console.log("Cache Miss");
  const user = await db.users.findById(userId);

  if (!user) return null;

  // 3. Write to Cache (with TTL!)
  // EX = Expiry in seconds (3600s = 1h)
  await redis.set(cacheKey, JSON.stringify(user), {
    EX: 3600,
  });

  return user;
}
```

## Key Considerations

1.  **TTL is Mandatory:** Never cache without expiry. Old data causes bugs that are impossible to reproduce.
2.  **Invalidation:** If the user updates their profile, you MUST delete the cache key.
    ```typescript
    async function updateUser(userId, data) {
      await db.users.update(userId, data);
      await redis.del(`user:${userId}:profile`); // Burst cache
    }
    ```
