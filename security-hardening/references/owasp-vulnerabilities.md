# OWASP Top 10 Vulnerabilities (2021)

Detailed patterns and prevention strategies for the top 10 web application security risks.

---

## A01: Broken Access Control

Failures in enforcing policies on what users can do.

### 🛑 Prevention Pattern: IDOR Check

**Principle**: Never trust an ID from the client without verifying ownership.

#### TypeScript (Next.js/Node)

```typescript
// ❌ VULNERABLE: Insecure Direct Object Reference (IDOR)
app.get("/api/invoices/:id", async (req, res) => {
  const invoice = await db.invoice.findUnique({ where: { id: req.params.id } });
  res.json(invoice); // Returns invoice even if it belongs to another user
});

// ✅ SECURE: Verify Ownership
app.get("/api/invoices/:id", async (req, res) => {
  const invoice = await db.invoice.findUnique({ where: { id: req.params.id } });

  // Explicit ownership check
  if (!invoice || invoice.userId !== req.session.userId) {
    return res.status(403).json({ error: "Access denied" });
  }

  res.json(invoice);
});
```

#### Python (FastAPI)

```python
# ✅ SECURE: Dependency Injection for checks
@app.get("/invoices/{invoice_id}")
async def get_invoice(invoice_id: int, current_user: User = Depends(get_current_user)):
    invoice = await db.fetch_invoice(invoice_id)

    if invoice.owner_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized")

    return invoice
```

---

## A02: Cryptographic Failures

Failures related to cryptography (or lack thereof), often leading to detailed data exposure.

### 🛑 Prevention Pattern: Strong Hashing

**Principle**: Use algorithms designed for passwords (slow), not fast hashing algorithms like MD5/SHA.

#### TypeScript

```typescript
import bcrypt from "bcrypt";

const SALT_ROUNDS = 12; // Minimum recommended

async function hashPassword(password: string): Promise<string> {
  return await bcrypt.hash(password, SALT_ROUNDS);
}

async function verifyPassword(
  password: string,
  hash: string,
): Promise<boolean> {
  return await bcrypt.compare(password, hash);
}
```

#### Python

```python
import bcrypt

def hash_password(password: str) -> bytes:
    # gensalt(12) creates a salt with work factor 12
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt(rounds=12))

def check_password(password: str, hashed: bytes) -> bool:
    return bcrypt.checkpw(password.encode(), hashed)
```

---

## A03: Injection

SQL, NoSQL, OS Command, ORM, LDAP, and EL injection.

### 🛑 Prevention Pattern: Parameterization

#### TypeScript (Prisma & Raw SQL)

```typescript
// ✅ Prisma (Auto-parameterized)
const user = await prisma.user.findFirst({
  where: { email: userInput },
});

// ✅ Raw SQL (Parameterized)
const query = "SELECT * FROM users WHERE email = $1";
await db.query(query, [userInput]);

// ❌ VULNERABLE
const query = `SELECT * FROM users WHERE email = '${userInput}'`;
```

#### Python (SQLAlchemy & Psycopg2)

```python
# ✅ SQLAlchemy
stmt = select(User).where(User.name == user_input)

# ✅ Psycopg2 (Raw)
cur.execute("SELECT * FROM users WHERE name = %s", (user_input,))
```

### 🛑 Prevention Pattern: NoSQL Injection (MongoDB)

#### TypeScript

```typescript
import { z } from "zod";

// ✅ Validate type to prevent object injection (Example: { "$gt": "" })
const LoginSchema = z.object({
  username: z.string(),
  password: z.string(),
});

app.post("/login", async (req, res) => {
  const { username } = LoginSchema.parse(req.body);
  // Safe because username is forced to be a string
  const user = await db.users.findOne({ username });
});
```

---

## A04: Insecure Design

Focuses on risks related to design flaws (e.g., missing logic) rather than implementation bugs.

### 🛑 Prevention Pattern: Threat Modeling

- **Map Data Flows**: Identify where sensitive data goes.
- **Trust Boundaries**: Identify where data crosses from untrusted to trusted zones.
- **Rate Limiting**: Design limits into the system early.

```typescript
// Example: Rate Limiting in Next.js Middleware with Upstash
import { Ratelimit } from "@upstash/ratelimit";
import { Redis } from "@upstash/redis";

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, "10 s"),
});

export async function middleware(req) {
  const icon = req.headers.get("x-forwarded-for") ?? "127.0.0.1";
  const { success } = await ratelimit.limit(icon);
  if (!success) return new Response("Too Many Requests", { status: 429 });
}
```

---

## A05: Security Misconfiguration

Missing appropriate security hardening across the application stack.

### 🛑 Prevention Pattern: Secure Headers & Config

#### TypeScript (Helmet)

```typescript
import helmet from "helmet";

// ✅ Sets X-DNS-Prefetch-Control, X-Frame-Options, etc.
app.use(helmet());

// ✅ Customizing for strict security
app.use(
  helmet.contentSecurityPolicy({
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "trusted.cdn.com"],
      objectSrc: ["'none'"],
      upgradeInsecureRequests: [],
    },
  }),
);
```

#### Python (FastAPI/Starlette)

```python
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from fastapi.middleware.httpsredirect import HTTPSRedirectMiddleware

app.add_middleware(TrustedHostMiddleware, allowed_hosts=["example.com", "*.example.com"])
app.add_middleware(HTTPSRedirectMiddleware)
```

---

## A06: Vulnerable and Outdated Components

Using libraries with known vulnerabilities.

### 🛑 Prevention Pattern: Automated Audit

- **Node.js**: `npm audit` or `pnpm audit`
- **Python**: `pip-audit` or `safety check`
- **CI/CD**: Run these in every pipeline.

```bash
# GitHub Action Step
- name: Security Audit
  run: npm audit --audit-level=high
```

---

## A07: Identification and Auth Failures

Issues with confirming user identity, session management, and authentication.

### 🛑 Prevention Pattern: Session Management

#### TypeScript (Express Session)

```typescript
app.use(
  session({
    name: "sid", // Don't use default 'connect.sid'
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
    cookie: {
      httpOnly: true, // Prevent JS access
      secure: process.env.NODE_ENV === "production", // HTTPS only
      sameSite: "strict", // CSRF protection
      maxAge: 1000 * 60 * 15, // 15 minutes
    },
  }),
);
```

---

## A08: Software and Data Integrity Failures

Code and infrastructure related to integrity violations (e.g., deserialization, CI/CD pipeline).

### 🛑 Prevention Pattern: XSS Sanitzation

#### TypeScript (DOMPurify)

```typescript
import DOMPurify from "isomorphic-dompurify";

// ✅ Sanitize any user-generated HTML before rendering
const dirty = "<img src=x onerror=alert(1)>";
const clean = DOMPurify.sanitize(dirty);
// Result: <img src="x">
```

---

## A09: Security Logging and Monitoring Failures

Failures to log security-critical events (login/failed login) or insufficiently monitoring checks.

### 🛑 Prevention Pattern: Structured Security Logging

#### TypeScript (Winston)

```typescript
import winston from "winston";

const logger = winston.createLogger({
  defaultMeta: { service: "auth-service" },
  transports: [new winston.transports.JsonStream()],
});

function logSecurityEvent(
  event: string,
  user: string,
  success: boolean,
  ip: string,
) {
  logger.info({
    type: "SECURITY_EVENT",
    event_name: event, // 'login', 'password_change', 'api_access'
    user_id: user,
    success,
    ip_address: ip,
    timestamp: new Date().toISOString(),
  });
}
```

---

## A10: Server-Side Request Forgery (SSRF)

Fetching a remote resource without validating the user-supplied URL.

### 🛑 Prevention Pattern: Private IP Blocking

#### TypeScript

```typescript
import { URL } from "url";
import dns from "dns/promises";

async function validateUrl(urlString: string) {
  const url = new URL(urlString);

  // 1. Allowlist Scheme
  if (!["http:", "https:"].includes(url.protocol))
    throw new Error("Invalid protocol");

  // 2. Resolve DNS to check for private IP
  const { address } = await dns.lookup(url.hostname);

  // Private IP Regex (127.0.0.1, 10.x, 192.168.x, etc)
  const privateIpRegex =
    /(^127\.)|(^192\.168\.)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^::1$)|(^[fF][cCdD])/;

  if (privateIpRegex.test(address)) {
    throw new Error("SSRF Attempt: Destination is a private IP");
  }

  return urlString;
}
```
