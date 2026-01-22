# Horizontal Scaling Patterns

Scaling **out** (more machines) > Scaling **up** (bigger machine).

## 1. Database Scaling

### 1.1 Read Replicas

Offload `SELECT` queries to replicas.

- **Pattern:**
  - **Primary:** Accepts Writes (`INSERT`, `UPDATE`, `DELETE`). Replicates to secondaries.
  - **Replicas:** Accept Reads. Latency is non-zero (Eventual Consistency).
- **Implementation (Node.js/Prisma):**
  ```typescript
  const prisma = new PrismaClient({
    datasources: {
      db: {
        url: process.env.DATABASE_URL_PRIMARY,
      },
      readReplica: {
        url: process.env.DATABASE_URL_REPLICA, // Round-robin DNS
      },
    },
  });
  ```

### 1.2 Sharding

Partition data across multiple databases.

- **Strategies:**
  - **Key-Based:** `shard_id = user_id % num_shards`
  - **Range-Based:** Users A-M on DB1, N-Z on DB2.
  - **Geo-Based:** US users on US-East DB, EU users on Frankfurt DB.
- **Complexity:** No more `JOIN`s across shards. App layer handles aggregation.

---

## 2. Application Scaling

### 2.1 Statelessness ("The Golden Rule")

Any server must be able to handle any request.

- **Bad:** Storing session data in local memory (`req.session.user = ...`).
- **Good:** Store session in Redis/Memcached.
- **Reason:** If Server A dies, User can hit Server B with no data loss.

### 2.2 Load Balancing

Distribute traffic evenly.

- **Algorithms:**
  - **Round Robin:** Circular order.
  - **Least Connections:** Send to server with fewest active requests.
  - **IP Hash:** Sticky sessions (useful for WebSockets).

---

## 3. Queue-Based Decoupling

Don't process heavy tasks synchronously.

**Pattern:**

1.  API receives request ("Generate PDF Report").
2.  API pushes job to Queue (SQS, RabbitMQ, Bull).
3.  API responds `202 Accepted` immediately.
4.  Worker service pulls job and processes it.
5.  Worker updates status in DB / sends Webhook.
