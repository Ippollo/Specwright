# Async Operations & Webhooks

For standard requests that take >500ms, consider async patterns.

## The "202 Accepted" Pattern

Don't keep the connection open for long tasks (PDF generation, vide processing).

1. **Client sends request**:
   ```http
   POST /videos/process
   ```
2. **Server responds immediately**:
   ```http
   HTTP/1.1 202 Accepted
   Location: /videos/process/job-123
   ```
3. **Client polls status** (or waits for webhook):

   ```http
   GET /videos/process/job-123

   { "status": "processing", "progress": 45 }
   ```

4. **Completion**:
   ```http
   { "status": "completed", "resource_url": "/videos/999" }
   ```

## Webhooks

Push notifications for server-to-server events.

- **Retry Logic**: If delivery fails (non-200), retry with exponential backoff (1m, 5m, 1h).
- **Signatures**: Security is critical. Sign payloads with a shared secret (HMAC).
  - Header: `X-Webhook-Signature: sha256=a9c8...`
  - Client verifies hash matches payload.

## Idempotency Keys

Critical for payments and "non-repeatable" actions.

**Scenario**: Client clicks "Pay", network drops. Did it charge? Client retries.

**Solution**:

1. Client generates UUID: `Idempotency-Key: uuid-123`.
2. Server checks Redis: "Have I seen uuid-123?"
   - **Yes**: Return the _cached response_ from the first attempt. Do NOT process again.
   - **No**: Process payment, save response with UUID key.

```http
POST /charges
Idempotency-Key: 7b3e1...
```
