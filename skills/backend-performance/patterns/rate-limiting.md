# Rate Limiting & Throttling

Protect your resources from abuse and traffic spikes.

## 1. Algorithms

### 1.1 Token Bucket

- **Concept:** A bucket holds `N` tokens and refills at rate `R`. Each request costs 1 token.
- **Pros:** Allows bursts (until bucket empties), then smooths out.
- **Use Case:** General API usage.

### 1.2 Leaky Bucket

- **Concept:** Requests enter a queue and are processed at a constant rate. Overflow is dropped.
- **Pros:** Smooths out bursty traffic into reliable stream.
- **Use Case:** Writing to a database with limited IOPS.

### 1.3 Sliding Window Log

- **Concept:** Track timestamps of every request. Count requests in `[now - window, now]`.
- **Pros:** Perfectly accurate.
- **Cons:** High memory/storage cost per user.

## 2. Implementation Strategies

### 2.1 Redis (Distributed)

Essential for multi-server setups.

**Lua Script (Atomic Check-and-Set):**

```lua
-- KEYS[1]: rate_limit:user_123
-- ARGV[1]: limit (e.g., 10)
-- ARGV[2]: window (e.g., 60s)

local current = redis.call("INCR", KEYS[1])
if tonumber(current) == 1 then
    redis.call("EXPIRE", KEYS[1], ARGV[2])
end

if tonumber(current) > tonumber(ARGV[1]) then
    return 0 -- Rejected
else
    return 1 -- Allowed
end
```

### 2.2 API Gateway Level

Let infrastructure handle it (Nginx, Kong, AWS API Gateway).

**Nginx Configuration:**

```nginx
limit_req_zone $binary_remote_addr zone=mylimit:10m rate=10r/s;

server {
    location /api/ {
        limit_req zone=mylimit burst=20 nodelay;
    }
}
```

## 3. HTTP Headers

Always communicate limits to the client.

- `X-RateLimit-Limit`: 1000
- `X-RateLimit-Remaining`: 998
- `X-RateLimit-Reset`: 1600000000 (Epoch time)
- **429 Too Many Requests**: Return standard status code.
