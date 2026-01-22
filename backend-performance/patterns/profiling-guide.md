# Profiling & Diagnostics Guide

> "You cannot optimize what you cannot measure."

This guide covers tool-specific instructions for profiling CPU, memory, and event loop blocking in Node.js, Python, and Go.

## 1. Node.js Profiling

### 1.1 Clinic.js (Recommended)

The standard for Node.js diagnostics.

**Installation:**

```bash
npm install -g clinic
```

**Usage:**

- **Doctor** (First Step): Diagnoses CPU spikes, I/O waits, and event loop delays.

  ```bash
  clinic doctor -- node start-server.js
  ```

  _Output:_ HTML report recommending checking CPU or Event Loop.

- **Bubbleprof** (Async Latency): Visualizes where async requests spend time.

  ```bash
  clinic bubbleprof -- node start-server.js
  ```

- **Flame** (CPU Hotpaths): Finds which functions consume the most CPU.
  ```bash
  clinic flame -- node start-server.js
  ```

### 1.2 Built-in Profiler (Zero Dependency)

Useful for quick checks in production.

```bash
node --prof start-server.js
# ... run load test ...
# Process the isolated-0xnnnn.log file
node --prof-process isolate-0xnnnnnnnn-v8.log > profiled.txt
```

---

## 2. Python Profiling

### 2.1 py-spy (Production Safe)

A sampling profiler that runs without modifying your code. Low overhead.

**Installation:**

```bash
pip install py-spy
```

**Usage:**

- **Top (Live View):**

  ```bash
  py-spy top --pid <PID>
  ```

- **Flame Graph:**
  ```bash
  py-spy record -o profile.svg --pid <PID>
  ```

### 2.2 cProfile (Standard Lib)

Deterministic profiling for scripts. Warning: High overhead.

```bash
python -m cProfile -o output.pstats my_script.py
```

_Visualize with snakeviz:_

```bash
pip install snakeviz
snakeviz output.pstats
```

---

## 3. Go Profiling

### 3.1 pprof (Standard)

Go has world-class profiling built-in.

**Setup:**
Import `net/http/pprof` in your main package.

```go
import _ "net/http/pprof"

func main() {
    go func() {
        log.Println(http.ListenAndServe("localhost:6060", nil))
    }()
    // ... app code ...
}
```

**Usage:**

- **Interactive Web UI:**

  ```bash
  go tool pprof -http=:8080 http://localhost:6060/debug/pprof/profile
  ```

- **Flame Graph (with Go 1.11+):**
  Navigate to `http://localhost:8080/ui/flamegraph` after launching the tool.

---

## 4. Reading Flame Graphs

Flame graphs visualize the call stack.

- **X-Axis:** The population of samples (width = frequency). **Wider is slower.**
- **Y-Axis:** Stack depth.
- **Optimization Strategy:** Look for "wide plateaus" at the top of the stacks. These are functions running frequently on the CPU.
