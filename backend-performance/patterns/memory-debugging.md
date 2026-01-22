# Memory Debugging & Leak Detection

Memory leaks kill long-running processes. This guide details how to find and fix them.

## 1. Symptoms of a Leak

- **Sawtooth Pattern:** Memory usage grows, GC kicks in (drops), but the baseline keeps rising.
- **OOM Crashes:** "Heap limit allocation failed" or system OOM kills.
- **Sluggishness:** GC runs too frequently, stealing CPU cycles.

---

## 2. Node.js

### 2.1 Heap Snapshots (Chrome DevTools)

1.  **Start Inspection:**
    ```bash
    node --inspect index.js
    ```
2.  Open Chrome: `chrome://inspect`.
3.  Click "inspect" on your remote target.
4.  **Memory Tab:** Take a "Heap Snapshot".
5.  **Comparison:** Take snapshot A, perform action (request), take snapshot B. Filter by "Objects allocated between Snapshot 1 and 2".

### 2.2 Leak Detection Packages

- **heapdump:** Programmatically write snapshots to disk on signal.
  ```javascript
  const heapdump = require("heapdump");
  // usage: kill -USR2 <pid>
  ```

### 2.3 Common Node.js Leaks

- **Global Variables/Caches:** Infinite `Map` growth without `.clear()`.
- **Closures:** Event listeners attached but never removed (`socket.on(...)`).
- **Timers:** `setInterval` that is never cleared.

---

## 3. Python

### 3.1 tracemalloc (Built-in)

Trace memory blocks allocation.

```python
import tracemalloc

tracemalloc.start()
# ... run code ...
snapshot = tracemalloc.take_snapshot()
top_stats = snapshot.statistics('lineno')

for stat in top_stats[:10]:
    print(stat)
```

### 3.2 objgraph

Visualize object references to find what is holding an object in memory.

```python
import objgraph
# Show what references list objects
objgraph.show_backrefs(obj, max_depth=3)
```

---

## 4. Go (Golang)

### 4.1 pprof Heap

Go runtime profiling is excellent.

```bash
go tool pprof -http=:8080 http://localhost:6060/debug/pprof/heap
```

- **inuse_space:** Memory currently held.
- **alloc_space:** Total memory allocated (includes freed).

### 4.2 Escape Analysis

Check if variables properly stay on stack vs moving to heap.

```bash
go build -gcflags="-m" main.go
```

---

## 5. Garbage Collection (GC) Tuning

Sometimes the default GC isn't aggressive enough (or is too aggressive).

- **Node.js:**
  - `--max-old-space-size=4096`: Set heap limit explicitely (essential for containers).
- **Go:**
  - `GOGC=100` (default). Lowering (e.g., 50) triggers GC more often (lower RAM, higher CPU). Raising (200) delays GC (higher RAM, lower CPU).
