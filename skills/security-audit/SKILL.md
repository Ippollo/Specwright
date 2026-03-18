---
name: security-audit
description: Systematic vulnerability hunting using multi-pass methodology with per-class reasoning chains and data flow tracing. Use when performing offensive security reviews, hunting for specific vulnerability classes, or auditing code for exploitable flaws. Covers web, API, mobile, and native application attack surfaces.
metadata:
  pattern: pipeline
---

# Security Audit — Vulnerability Hunting Methodology

Structured offensive security review methodology. This skill teaches **how to hunt** for vulnerabilities, not just what they look like.

> **Core Principle**: Vulnerabilities live in the gap between user input and trusted operations. Trace every data flow from source to sink.

> [!IMPORTANT]
> This skill is for **finding** vulnerabilities (offensive). For **preventing** them (defensive), see [security-hardening](../security-hardening/SKILL.md).

## When to Use This Skill

- User asks for a security audit, penetration test perspective, or code review
- `/security` workflow is invoked
- Reviewing a PR or codebase for exploitable flaws
- Investigating a suspected vulnerability
- Pre-deployment security sign-off

## Multi-Pass Audit Protocol

**Never** do a single-pass review. Follow this 4-phase protocol in order. Each phase builds on the previous.

---

### Phase 1: Attack Surface Mapping

**Goal**: Build a complete inventory of everything an attacker can touch.

**Output**: A structured attack surface map (written to `attack_surface.md` in the change folder if using `/security` workflow).

#### Step 1.1 — Enumerate Entry Points

Search for every way external input enters the system:

| Entry Type             | What to Search For                                              |
| ---------------------- | --------------------------------------------------------------- |
| **HTTP Routes**        | Route definitions, controller decorators, handler registrations |
| **API Endpoints**      | REST routes, GraphQL resolvers, gRPC service definitions        |
| **WebSocket Handlers** | `onMessage`, `on('message')`, channel subscription handlers     |
| **CLI Arguments**      | `argparse`, `process.argv`, `sys.argv`, CLI command definitions |
| **File Uploads**       | Multipart handlers, file storage operations, stream processors  |
| **Message Queues**     | Queue consumers, event subscribers, webhook receivers           |
| **Scheduled Tasks**    | Cron jobs, scheduled functions that process stored data         |
| **IPC / RPC**          | Inter-process communication handlers, remote procedure calls    |

**How to search** (using available tools):

```
# Find HTTP route definitions
grep_search: "app\.(get|post|put|patch|delete)\(" or "@(Get|Post|Put|Delete|Patch)"
grep_search: "router\." or "Route(" or "@route"
grep_search: "createServer|handleRequest|middleware"

# Find GraphQL resolvers
grep_search: "Resolver|resolver|@Query|@Mutation|@Subscription"

# Find WebSocket handlers
grep_search: "onMessage|on\('message'\)|handleMessage|ws\."

# Find queue consumers
grep_search: "consume|subscribe|onMessage|handleEvent|@EventHandler"
```

#### Step 1.2 — Enumerate Data Stores

Identify every place the application persists or retrieves data:

- **Databases**: SQL connections, ORM configurations, NoSQL clients
- **File System**: Read/write operations, temp files, uploads directory
- **Caches**: Redis, Memcached, in-memory caches
- **External APIs**: HTTP clients, SDK calls, third-party service integrations
- **Session Stores**: Session backends, token storage
- **Environment/Config**: `.env` files, config loaders, secret managers

#### Step 1.3 — Identify Auth Boundaries

Map the authentication and authorization architecture:

1. **Auth middleware**: What protects routes? Is it consistently applied?
2. **Role/permission checks**: Where are authorization decisions made?
3. **Public vs. protected surfaces**: Which endpoints require no auth?
4. **Token/session lifecycle**: How are credentials issued, validated, revoked?

#### Step 1.4 — Identify Trust Boundaries

Draw the line between trusted and untrusted:

- Where does user input cross into server-side processing?
- Where does internal data cross into client-visible output?
- Where does the application call external services?
- Where do privilege levels change (user → admin, service → service)?

---

### Phase 2: Data Flow Tracing

**Goal**: For every entry point found in Phase 1, trace user-controlled input through the code to every operation that acts on it.

**Output**: A data flow map documenting source → transformations → sink paths.

See [references/data-flow-tracing.md](./references/data-flow-tracing.md) for the complete step-by-step tracing methodology.

#### Core Concepts

- **Source**: Where attacker-controlled data enters (request params, headers, body, files, query strings, cookies)
- **Sink**: Where data causes an effect (DB query, shell command, file operation, HTTP response, log write, redirect)
- **Sanitizer**: Code that validates/escapes/transforms data between source and sink
- **Propagator**: Code that passes data through without meaningful transformation

#### The Tracing Loop

For each entry point from Phase 1:

1. **Identify the source** — What user input does this endpoint accept?
2. **Follow the variable** — Use `view_code_item` and `grep_search` to trace where the input flows
3. **Check each hop** — At every function call or assignment, ask: is the data validated/sanitized here?
4. **Record each sink** — Where does the data ultimately get used in a security-sensitive operation?
5. **Assess the gap** — Is there adequate sanitization between source and sink?

---

### Phase 3: Vulnerability Hunting by Class

**Goal**: Systematically test each data flow against specific vulnerability classes using targeted reasoning chains.

**Output**: Candidate findings with classification and confidence level.

For each vulnerability class below, apply the reasoning chain against the data flows mapped in Phase 2.

---

#### 3.1 — Injection (SQL, NoSQL, Command, Template, LDAP, XPath)

**Reasoning Chain**:

1. **Find sinks**: Search for database query construction, shell execution, template rendering, LDAP queries
2. **For each sink**: Trace backward — does any user input reach this sink?
3. **Check parameterization**: Is the input passed through a parameterized interface (prepared statement, ORM method) or concatenated/interpolated into the query/command?
4. **Check validation**: Even if parameterized, is the input validated for type/format/range?
5. **Check context**: Is the sink in a path that bypasses normal middleware (error handlers, admin routes, background jobs)?

**Decision Tree**:

```
User input reaches a query/command sink?
├── NO → Not vulnerable (to this class)
└── YES → Is it parameterized?
    ├── YES (prepared statement, ORM, bind variables) → Low risk, check for edge cases
    │   └── Does the parameterization cover ALL input in the query?
    │       ├── YES → Not vulnerable
    │       └── NO (e.g., table name from user, ORDER BY from user) → VULNERABLE
    └── NO (string concat, f-string, template literal) → Is input validated?
        ├── YES (allowlist, type coercion, regex) → Check validator quality
        │   └── Can the validation be bypassed? (encoding, Unicode, null bytes)
        │       ├── YES → VULNERABLE
        │       └── NO → Low risk
        └── NO → VULNERABLE (High Confidence)
```

**Specific patterns by injection subtype**:

| Subtype            | Sink Pattern                                                     | Critical Signal                         |
| ------------------ | ---------------------------------------------------------------- | --------------------------------------- |
| SQL Injection      | `execute()`, `raw()`, `query()` with string concat               | `f"SELECT...{user_input}"`              |
| NoSQL Injection    | MongoDB `find()` with unsanitized objects                        | `{ $gt: "" }` in input                  |
| Command Injection  | `exec()`, `spawn()`, `system()`, `subprocess`                    | Unquoted variable in shell string       |
| Template Injection | `render_template_string()`, `Jinja2` with user input in template | User input as template, not as variable |
| LDAP Injection     | `ldap.search()` with string concat                               | `(&(user=` + input + `))`               |
| XPath Injection    | `xpath()` with string concat                                     | User input in XPath expression          |

---

#### 3.2 — Broken Access Control

**Reasoning Chain**:

1. **Identify resource-accessing endpoints**: Any route that returns or modifies a specific resource by ID
2. **Check ownership verification**: Does the endpoint verify the requesting user owns/has access to the resource?
3. **Check for IDOR**: Can User A's ID be replaced with User B's ID to access their data?
4. **Check horizontal privilege**: Can a regular user access admin-only functionality?
5. **Check path traversal**: Can file/directory paths be manipulated to escape intended boundaries?

**Decision Tree**:

```
Endpoint accesses a resource by user-supplied identifier?
├── NO → Check for privilege escalation instead
└── YES → Does it verify ownership/authorization?
    ├── YES → Is the check on the resolved resource (not just the input)?
    │   ├── YES → Is it consistently applied (not just on GET)?
    │   │   ├── YES → Low risk
    │   │   └── NO → VULNERABLE (partial protection)
    │   └── NO → VULNERABLE (check bypass, e.g., UUID guessing)
    └── NO → VULNERABLE (High Confidence — IDOR)

Endpoint performs privileged operations?
├── Does it check user role/permissions?
│   ├── YES → Can the role check be bypassed?
│   │   ├── Client-side only → VULNERABLE
│   │   ├── Inconsistent middleware → VULNERABLE
│   │   └── Enforced server-side on every request → Low risk
│   └── NO → VULNERABLE (missing authorization)
```

---

#### 3.3 — Authentication Bypass

**Reasoning Chain**:

1. **Map the auth flow**: Login → token/session creation → validation on protected routes → logout/expiry
2. **Check token strength**: Are session IDs/JWTs sufficiently random? Are JWTs verified with strong keys?
3. **Check session lifecycle**: Can sessions be fixated? Do they expire? Can they be replayed?
4. **Check password handling**: Stored hashed (bcrypt/argon2)? Any timing oracle on comparison?
5. **Check recovery flows**: Password reset tokens — are they single-use, time-limited, hashed in DB?
6. **Check race conditions**: Can concurrent requests bypass rate limiting or account lockout?

**Decision Tree**:

```
Authentication mechanism type?
├── JWT
│   ├── Is the signing key strong (not hardcoded/default)? → Check
│   ├── Is the algorithm enforced (no `alg: none` bypass)? → Check
│   ├── Is expiration validated? → Check
│   └── Is the token revocable (logout)? → Check
├── Session Cookie
│   ├── HttpOnly flag? → Check
│   ├── Secure flag? → Check
│   ├── SameSite attribute? → Check
│   ├── Session ID entropy sufficient? → Check
│   └── Session fixation possible? → Check
└── API Key
    ├── Transmitted securely (HTTPS, header not URL)? → Check
    ├── Rotatable? → Check
    └── Scoped (not god-mode)? → Check
```

---

#### 3.4 — SSRF / Open Redirect

**Reasoning Chain**:

1. **Find URL-consuming sinks**: Any code that makes HTTP requests, loads resources, or redirects based on user input
2. **Check URL validation**: Is the target URL validated against an allowlist?
3. **Check for private IP**: Can the URL resolve to internal/private addresses (127.0.0.1, 10.x, 169.254.x, metadata endpoints)?
4. **Check redirect targets**: Are redirect URLs validated to prevent open redirects?

**Decision Tree**:

```
Application makes HTTP requests with user-supplied URL?
├── NO → Check for open redirects separately
└── YES → Is there URL validation?
    ├── YES → Is it an allowlist (not blocklist)?
    │   ├── YES → Can it be bypassed? (DNS rebinding, URL parsing differences, redirects)
    │   │   ├── YES → VULNERABLE
    │   │   └── NO → Low risk
    │   └── NO (blocklist) → VULNERABLE (blocklists are nearly always bypassable)
    └── NO → VULNERABLE (High Confidence)
```

---

#### 3.5 — Cross-Site Scripting (XSS)

**Reasoning Chain**:

1. **Identify output sinks**: Where does user input appear in HTML responses? (`innerHTML`, `document.write`, template variables, `dangerouslySetInnerHTML`, `v-html`)
2. **Classify the XSS type**: Is the input reflected immediately (reflected), stored and rendered later (stored), or processed entirely in the browser (DOM-based)?
3. **Check output encoding**: Is the output HTML-escaped? Is it escaped for the correct context (HTML body vs. attribute vs. JavaScript vs. URL)?
4. **Check CSP**: Does a Content-Security-Policy header block inline scripts? Is it strict enough?
5. **Check framework auto-escaping**: React auto-escapes by default (except `dangerouslySetInnerHTML`), Angular sanitizes, but raw template engines may not.

**Decision Tree**:

```
User input appears in HTML output?
├── NO → Not vulnerable to XSS
└── YES → What context?
    ├── HTML body (between tags) → Is it HTML-escaped?
    │   ├── YES (framework auto-escape, explicit escape) → Low risk
    │   └── NO → VULNERABLE
    ├── HTML attribute → Is it quoted AND attribute-escaped?
    │   ├── YES → Low risk
    │   └── NO → VULNERABLE
    ├── JavaScript context (inside <script> or event handler) → Is it JS-escaped?
    │   ├── YES → Check for bypass (template literals, eval)
    │   └── NO → VULNERABLE (High Confidence)
    ├── URL context (href, src) → Is it validated (scheme check)?
    │   ├── YES → Low risk
    │   └── NO → VULNERABLE (javascript: scheme injection)
    └── CSS context → Is it sanitized?
        ├── YES → Low risk
        └── NO → VULNERABLE (expression injection)
```

> **Stored XSS** is especially dangerous — trace user input that gets saved to a database and later rendered to OTHER users. The sink and source are in completely different request flows.

---

#### 3.6 — Cross-Site Request Forgery (CSRF)

**Reasoning Chain**:

1. **Identify state-changing endpoints**: POST/PUT/DELETE routes that modify data
2. **Check CSRF protection**: Are tokens, `SameSite` cookies, or `Origin` header validation in place?
3. **Check authentication method**: Cookie-based auth is vulnerable; token-based (Bearer) is inherently CSRF-resistant
4. **Check for sensitive GET endpoints**: GETs should never cause state changes

**Decision Tree**:

```
State-changing endpoint uses cookie-based auth?
├── NO (Bearer token, API key in header) → Not vulnerable to CSRF
└── YES → Is there CSRF protection?
    ├── YES → What kind?
    │   ├── Synchronizer token (hidden form field) → Is it validated server-side? → Check
    │   ├── SameSite=Strict/Lax cookie → Check browser support requirements
    │   ├── Origin/Referer header check → Can be bypassed in some scenarios
    │   └── Double-submit cookie → Check for subdomain vulnerabilities
    └── NO → VULNERABLE
```

---

#### 3.7 — Path Traversal

**Reasoning Chain**:

1. **Find file-accessing sinks**: `open()`, `readFile()`, `writeFile()`, `path.join()`, `send_file()`, `sendFile()`
2. **Check if path includes user input**: Is any part of the file path derived from request parameters?
3. **Check path sanitization**: Is `../` stripped? Is the path resolved and checked against an allowed directory?
4. **Check for null byte injection**: Can `%00` or null bytes truncate the path?

**Decision Tree**:

```
File path includes user-controlled input?
├── NO → Not vulnerable
└── YES → Is the path restricted to an allowed directory?
    ├── YES → How?
    │   ├── Resolved path checked with startsWith(baseDir) → Low risk
    │   ├── Regex/string replacement of "../" → VULNERABLE (bypass: ....// or URL-encoded)
    │   └── Chroot/sandbox → Low risk
    └── NO → VULNERABLE (High Confidence)
```

---

#### 3.8 — File Upload Vulnerabilities

**Reasoning Chain**:

1. **Check file type validation**: Is the MIME type AND file extension validated? Server-side or client-side only?
2. **Check storage location**: Are uploaded files stored in a web-accessible directory? Can they be executed?
3. **Check filename handling**: Is the original filename used? Can it contain path traversal sequences?
4. **Check file content**: Is the content scanned for embedded scripts, polyglots, or malware?
5. **Check size limits**: Is there a maximum file size? Can large uploads cause DoS?

**Decision Tree**:

```
Application accepts file uploads?
├── NO → Not applicable
└── YES → Is file type validated server-side?
    ├── YES → Is it allowlist-based (not blocklist)?
    │   ├── YES → Are uploaded files stored outside webroot?
    │   │   ├── YES → Is filename sanitized (no user-supplied name used)?
    │   │   │   ├── YES → Low risk
    │   │   │   └── NO → VULNERABLE (path traversal via filename)
    │   │   └── NO → VULNERABLE (uploaded file execution)
    │   └── NO (blocklist) → VULNERABLE (bypassable with double extensions, null bytes)
    └── NO → VULNERABLE (High Confidence — unrestricted file upload)
```

---

#### 3.9 — Insecure Deserialization

**Reasoning Chain**:

1. **Find deserialization sinks**: `pickle.loads`, `yaml.load` (without SafeLoader), `JSON.parse` on complex objects, `unserialize()`, `ObjectInputStream`
2. **Check if input is user-controlled**: Can an attacker supply the serialized data?
3. **Check if there are gadget chains**: Are there classes in scope whose `__reduce__`, `__setstate__`, or constructor methods have dangerous side effects?
4. **Check alternatives**: Is deserialization necessary, or could a safer format (JSON with schema validation) be used?

---

#### 3.10 — Business Logic Flaws

**Reasoning Chain**:

1. **Identify state machines**: Workflows with sequential steps (checkout, approval, onboarding)
2. **Check step enforcement**: Can steps be skipped, reordered, or replayed?
3. **Check numeric boundaries**: Can quantities, prices, or counts go negative? Can rounding be exploited?
4. **Check race conditions**: Can concurrent requests create inconsistent state? (double-spend, double-vote)
5. **Check trust assumptions**: Does the server trust client-side calculations (price, discount, quantity)?

---

#### 3.11 — Secrets and Configuration

**Reasoning Chain**:

1. **Search for hardcoded secrets**: API keys, passwords, tokens in source code or config files
2. **Check secret management**: Are secrets loaded from environment/vault, or committed to the repo?
3. **Check for exposed debug modes**: `DEBUG=true`, verbose error pages in production config
4. **Check for default credentials**: Default admin accounts, test users, sample data still active
5. **Check error handling**: Do error responses leak stack traces, internal paths, or database schema?

---

#### 3.12 — Dependency Vulnerabilities

**Reasoning Chain**:

1. **Identify dependency manifests**: `package.json`, `requirements.txt`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Gemfile`, etc.
2. **Check lock file freshness**: Is there a lock file? Is it committed? When was it last updated?
3. **Check for known CVEs**: Run `npm audit`, `pip-audit`, `cargo audit`, or equivalent
4. **Check for unmaintained dependencies**: Are any critical dependencies abandoned or archived?
5. **Check for supply chain risk**: Any unusual install scripts, postinstall hooks, or typosquatting candidates?

---

#### 3.13 — Cryptographic Weaknesses

**Reasoning Chain**:

1. **Find crypto usage**: Hashing, encryption, signing, random number generation
2. **Check algorithm choices**: MD5/SHA1 for security purposes? ECB mode? Custom crypto?
3. **Check key management**: Hardcoded keys? Insufficient key length? No key rotation?
4. **Check randomness**: `Math.random()` or `random.random()` for security purposes (tokens, IDs)?
5. **Check TLS configuration**: Minimum TLS version? Certificate validation disabled?

---

#### 3.14 — Mobile / Native Specific

**Reasoning Chain**:

1. **Check local storage**: Are sensitive values stored in plaintext (SharedPreferences, UserDefaults, localStorage)?
2. **Check certificate pinning**: Is it implemented? Can it be bypassed trivially?
3. **Check IPC**: Are intents/URL schemes/deep links validated for origin and content?
4. **Check binary protections**: Is code obfuscated? Are anti-tampering checks present?
5. **Check API communication**: Are API keys embedded in the binary? Can they be extracted?

---

### Phase 4: Findings Verification

**Goal**: For each candidate finding from Phase 3, construct a proof-of-concept reasoning chain and classify confidence.

**Output**: Final `security_report.md` with verified findings.

#### Verification Steps

For each candidate finding:

1. **Reproduce the path**: Walk through the exact code path from source to sink, citing specific files and line numbers
2. **Construct the attack scenario**: Describe what an attacker would send and what would happen
3. **Assess exploitability**: Can it be triggered in a realistic scenario? What preconditions are needed?
4. **Classify severity and confidence**:

| Confidence | Criteria                                                                                    |
| ---------- | ------------------------------------------------------------------------------------------- |
| **High**   | Clear, unparameterized path from user input to dangerous sink, no validation                |
| **Medium** | Path exists but has partial validation, or requires specific conditions                     |
| **Low**    | Theoretical risk, unusual conditions required, or defense-in-depth may prevent exploitation |

| Severity     | Criteria                                                                   |
| ------------ | -------------------------------------------------------------------------- |
| **Critical** | Remote code execution, full data breach, authentication bypass             |
| **High**     | Unauthorized data access, privilege escalation, stored XSS                 |
| **Medium**   | Information disclosure, CSRF, reflected XSS, partial access control bypass |
| **Low**      | Information leakage (versions, paths), missing best practices              |

#### Findings Report Format

Each verified finding MUST use this structure:

```markdown
### [SEVERITY] [VulnClass] — Short Description

**Confidence**: High | Medium | Low
**Affected Code**: `path/to/file.ext` L123-L145
**OWASP Category**: A01-A10

**Data Flow**:

1. Source: [where attacker input enters]
2. Propagation: [how it flows through code]
3. Sink: [where it causes the security-sensitive operation]

**Attack Scenario**:
[Concrete description of what an attacker would do]

**Proof of Concept Reasoning**:
[Step-by-step explanation of why this is exploitable]

**Remediation**:
[Specific fix with code suggestion]
```

---

## Quick-Start: Minimal Audit

When time is limited, prioritize this subset:

1. **Auth bypass**: Check the 3 most critical endpoints — can you access them without valid credentials?
2. **IDOR**: Pick 3 resource-accessing endpoints — can User A access User B's data?
3. **Injection**: Find all raw query/command construction — is any user input concatenated?
4. **Secrets**: Grep for hardcoded secrets, API keys, and passwords
5. **Dependencies**: Run the appropriate audit tool for the package manager

This is the 80/20 — these 5 checks catch the majority of real-world exploitable vulnerabilities.

---

## References

- [Hunting Patterns](./references/hunting-patterns.md) — Deep grep patterns and decision trees per vulnerability class
- [Data Flow Tracing](./references/data-flow-tracing.md) — Step-by-step data flow analysis methodology
- [OWASP Vulnerabilities](../security-hardening/references/owasp-vulnerabilities.md) — Prevention code patterns (sibling skill)
