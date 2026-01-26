# Load Testing & Stress Verification

Load testing answers: "Will it crash on Black Friday?" and "Why is it slow?"

## 1. Methodology

### Metrics that Matter

- **Throughput (RPS):** Requests Per Second your system handles successfully.
- **Latency (p95/p99):** "95% of requests are faster than X". Averages mean nothing; p99 is user reality.
- **Error Rate:** Should be < 0.1% under normal load.

### Types of Tests

1.  **Smoke Test:** Minimal load verifying system doesn't error immediately.
2.  **Load Test:** Simulates expected peak usage (e.g., 500 users).
3.  **Stress Test:** Finds the breaking point (ramp up until crash).
4.  **Soak Test:** Runs for hours to find memory leaks/race conditions.
5.  **Spike Test:** Sudden burst (0 -> 5000 users in 10s) to test auto-scaling speed.

---

## 2. Tools

### 2.1 k6 (Recommended)

Developer-friendly, scriptable in JS, high performance (Go-based).

**Basic Script:**

```javascript
import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  stages: [
    { duration: "30s", target: 20 }, // Ramp up
    { duration: "1m", target: 20 }, // Stay
    { duration: "10s", target: 0 }, // Ramp down
  ],
};

export default function () {
  const res = http.get("http://localhost:3000/api/health");
  check(res, { "status was 200": (r) => r.status == 200 });
  sleep(1);
}
```

**Run:**

```bash
k6 run script.js
```

### 2.2 Artillery

Great for testing complex user flows (Sequence: Login -> Search -> Add to Cart).

**Config (artillery.yml):**

```yaml
config:
  target: "http://localhost:3000"
  phases:
    - duration: 60
      arrivalRate: 5
      rampTo: 50
scenarios:
  - flow:
      - get:
          url: "/api/products"
```

**Run:**

```bash
artillery run artillery.yml
```

### 2.3 Apache Bench (ab)

Quick & dirty single-endpoint check.

```bash
# 1000 requests, concurrency 10
ab -n 1000 -c 10 http://localhost:3000/
```

---

## 3. Analysis Checklist

- [ ] **Bottleneck Identification:**
  - High CPU? -> Code issue.
  - High Memory? -> Leak or easy GC.
  - Low CPU, High Latency? -> I/O Wait (DB/External API blocking).
- [ ] **Auto-scaling:** Did new pods launch fast enough?
- [ ] **Recovery:** Did the system self-heal after the test stopped?
