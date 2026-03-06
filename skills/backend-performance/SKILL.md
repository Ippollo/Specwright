---
name: backend-performance
description: Use when diagnosing slow endpoints, optimizing database queries, setting up caching (Redis), running load tests, or profiling Node.js/Python/Go services. Covers N+1 fixes, connection pooling, and horizontal scaling.
---

# Backend Performance Optimization

This skill focuses on making backend services fast, scalable, and efficient. It transforms "it works" into "it scales."

## 🎭 Performance Review Protocol

Act as a **Performance Engineer** when optimizing. Follow this protocol:

1.  **Measure First:** Never optimize without a baseline. Use [Profiling Tools](patterns/profiling-guide.md).
2.  **Identify Bottlenecks:** Is it CPU? Memory? I/O? Database?
3.  **Hypothesize & Test:** "Adding an index will fix this." -> Verify with `EXPLAIN ANALYZE`.
4.  **Stress Test:** Verify the fix holds under load using [Load Testing](patterns/load-testing.md).

---

## ⛔ Anti-Patterns to Avoid

| ❌ Anti-Pattern             | ✅ Better Approach                                                                        |
| --------------------------- | ----------------------------------------------------------------------------------------- |
| **N+1 Queries**             | Use `IN (...)` or DataLoaders. See [N+1 Fix Example](examples/n-plus-one-fix.md).         |
| **Sync I/O in Main Thread** | Offload to Worker Threads or use Async APIs.                                              |
| **Missing DB Indexes**      | Index FKs and query predicates. See [Query Optimization](examples/query-optimization.md). |
| **No Rate Limiting**        | Implement [Rate Limiting](patterns/rate-limiting.md) to prevent abuse.                    |
| **Unlimited Arrays**        | Use pagination or streams. Never `findAll()`.                                             |
| **JSON.parse(hugeString)**  | Stream parsing or offload to worker (blocks Event Loop).                                  |

---

## 1. Caching Strategies

"The fastest query is the one you don't make."

- **Patterns:** Cache-Aside, Write-Through, Stale-While-Revalidate.
- **Implementation:** [Redis Cache Wrapper](templates/redis-cache-wrapper.ts) | [Example](examples/cache-implementation.md)
- **Golden Rule:** Always set a TTL (Time-To-Live).

## 2. Database Optimization

- **Indexing:** Use Composite Indexes for multi-column queries.
- **Connection Pooling:** Maintain a healthy pool size (`Core Count * 2`).
- **Read Replicas:** Offload heavy `SELECT` traffic. See [Horizontal Scaling](patterns/horizontal-scaling.md).
- **Deep Dive:** [Query Optimization Example](examples/query-optimization.md)

## 3. Language-Specific Tuning

### Node.js

- **Event Loop:** Don't block it. Use [Async Patterns](patterns/async-patterns.md).
- **Memory:** Handle leaks with [Memory Debugging](patterns/memory-debugging.md).
- **Concurrency:** Use `Promise.all` but limit concurrency with `p-limit`.

### Python

- **GIL:** Python is single-threaded. Use `multiprocessing` or `gunicorn` workers for CPU tasks.
- **Async:** Use `asyncio` for I/O bound tasks.
- **Profiling:** Use `py-spy` or `cProfile`.

### Go

- **Goroutines:** Cheap, but not free. Avoid leak by ensuring they exit.
- **GC Tuning:** Adjust `GOGC` for memory vs CPU trade-offs.
- **Pprof:** Built-in world-class profiling.

## 4. Bottleneck Analysis

Use the right tool for the job. See [Profiling Guide](patterns/profiling-guide.md).

- **CPU Limited?** Flame Graphs, `clinic flame`, `pprof`.
- **Memory Leaking?** Heap Snapshots, GC logs.
- **Slow Requests?** Distributed Tracing (OpenTelemetry), APM.

## 5. Scaling & Reliability

- **Horizontal Scaling:** Sharding, Replicas, Statelessness. [Read Guide](patterns/horizontal-scaling.md).
- **Load Testing:** Validate capacity with k6/Artillery. [Guide](patterns/load-testing.md).
- **Rate Limiting:** Protect your API. [Guide](patterns/rate-limiting.md).

---

## 🛠️ Optimization Checklist

- [ ] **N+1 Queries** eliminated?
- [ ] **Indexes** exist for all `WHERE` and `JOIN` columns?
- [ ] **Caching** implemented for expensive, frequent reads?
- [ ] **Rate Limiting** enabled on public endpoints?
- [ ] **Compression** (Gzip/Brotli) enabled?
- [ ] **Payloads** minimized (no `SELECT *`)?
- [ ] **Connection Pool** sized correctly?
- [ ] **Memory Leaks** checked (heap usage stable)?

---

## 📂 Resources

### Patterns

- [Profiling Guide](patterns/profiling-guide.md)
- [Load Testing](patterns/load-testing.md)
- [Memory Debugging](patterns/memory-debugging.md)
- [Horizontal Scaling](patterns/horizontal-scaling.md)
- [Rate Limiting](patterns/rate-limiting.md)
- [Async Patterns](patterns/async-patterns.md)

### Code Examples

- [N+1 Fix](examples/n-plus-one-fix.md)
- [Query Optimization](examples/query-optimization.md)
- [Cache Implementation](examples/cache-implementation.md)

### Templates

- [k6 Load Test Script](templates/k6-load-test.js)
- [Redis Cache Wrapper](templates/redis-cache-wrapper.ts)
- [Express Rate Limiter](templates/rate-limiter-express.ts)
