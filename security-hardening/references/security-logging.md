# Security Logging & Monitoring

"You cannot fight what you cannot see."

---

## What to Log (The Good)

Log events that seem "suspicious" or security-relevant.

| Event Type         | Examples                                                |
| ------------------ | ------------------------------------------------------- |
| **Authentication** | Login success/fail, logout, password change, 2FA prompt |
| **Authorization**  | Access denied (403), IDOR attempts, role changes        |
| **Input Errors**   | SQL syntax errors (possible injection), malformed XML   |
| **System**         | Server start/stop, config reload, dependency failure    |

---

## What NOT to Log (The Bad)

Logging these creates a new vulnerability (Information Disclosure).

- ❌ Passwords (plain or hashed)
- ❌ API Keys / Secrets
- ❌ Session IDs / Tokens
- ❌ PII (Social Security, Credit Card) unless masked
- ❌ Entire `req.body` (often contains passwords)

---

## Implementation Pattern: Structured Logging

Use JSON logs for machine readability (Splunk/Datadog friendly).

### TypeScript (Winston)

```typescript
import winston from "winston";

const logger = winston.createLogger({
  level: "info",
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json(), // Mandatory for production
  ),
  transports: [new winston.transports.Console()],
});

// ✅ Specialized Security Logger Wrapper
export const SecurityLogger = {
  authFailure: (email: string, ip: string, reason: string) => {
    logger.warn({
      type: "SEC_AUTH_FAIL",
      email, // Safe to log email (usually), but never password
      ip,
      reason,
      timestamp: new Date().toISOString(),
    });
  },

  accessDenied: (userId: string, resource: string, action: string) => {
    logger.warn({
      type: "SEC_ACCESS_DENIED",
      userId,
      resource,
      action,
    });
  },
};
```

---

## Monitoring & Alerts

Logs are useless if nobody looks at them. Set up alerts for:

1. **Velocity Spikes**: 50 failed logins from one IP in 1 minute.
2. **New Admins**: Whenever a user is promoted to 'admin'.
3. **WAF Triggers**: High volume of XSS/SQLi blocked requests.
4. **Billing**: Sudden spike in usage (cloud API key compromised).
