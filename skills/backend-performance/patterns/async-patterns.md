# Advanced Async Patterns

Handling concurrency efficiently is key to high throughput.

## 1. Backpressure

Don't let a fast producer overwhelm a slow consumer.

**The Problem:** Reading 1GB file into memory -> Processing. Memory overflow.
**The Fix:** Streams (Pipe).

**Node.js Example:**

```javascript
// BAD: fs.readFile loads all to RAM
// GOOD: Pipeline handles backpressure automatically
const { pipeline } = require('stream');
pipeline(
  fs.createReadStream('input.csv'),
  csvParser(),
  dbInsertStream(),
  (err) => { ... }
);
```

## 2. Batching (DataLoader)

Solve the N+1 problem by coalescing requests.

**Scenario:** Fetching authors for 100 books.

- **Naive:** 1 query for books + 100 queries for authors = 101 queries.
- **Batching:** 1 query for books + 1 query for authors (`WHERE id IN (...)`) = 2 queries.

**Pattern:**

1.  Collect IDs in current Event Loop tick.
2.  `process.nextTick` -> Execute one bulk query.
3.  Resolve all Promises with mapped results.

## 3. Concurrency Control (Semaphores)

Limit parallelism to prevent resource exhaustion.

**Use Case:** processing 10,000 items. `Promise.all` attempts 10,000 at once -> Crash.

**p-limit (Node.js):**

```javascript
import pLimit from "p-limit";

const limit = pLimit(5); // Max 5 concurrent
const tasks = items.map((item) => limit(() => processItem(item)));
await Promise.all(tasks);
```

## 4. Streaming Responses

Send data as it's ready, improving specific Time-To-First-Byte (TTFB).

**Chunked Transfer Encoding:**

```javascript
res.write(JSON.stringify(header));
// ... database cursor ...
for await (const row of cursor) {
  res.write(JSON.stringify(row));
}
res.end();
```
