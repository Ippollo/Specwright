# Data Flow Tracing — Systematic Analysis Methodology

Step-by-step methodology for manually tracing data flows from user input (sources) through application code to security-sensitive operations (sinks). This is the core technique of Phase 2 in the audit protocol.

---

## Core Model

Every exploitable vulnerability follows this pattern:

```
SOURCE → [propagation] → [propagation] → ... → SINK
         ↑ no sanitization or insufficient sanitization ↑
```

If there's a **complete, unbroken path** from source to sink with no adequate sanitization, there's a vulnerability. Your job is to find these paths.

---

## Step 1: Catalogue Sources

Sources are where attacker-controlled data enters the application. Identify all sources for the entry point you're analyzing.

### Web Application Sources

| Source                  | Where It Appears                                     | Trust Level |
| ----------------------- | ---------------------------------------------------- | ----------- |
| **URL path parameters** | `/users/:id`, `request.args`                         | Untrusted   |
| **Query string**        | `?search=foo`, `req.query`                           | Untrusted   |
| **Request body**        | JSON/form data, `req.body`                           | Untrusted   |
| **HTTP headers**        | `Host`, `Referer`, `X-Forwarded-For`, custom headers | Untrusted   |
| **Cookies**             | `req.cookies`, `document.cookie`                     | Untrusted   |
| **File uploads**        | Multipart data, filename, content                    | Untrusted   |
| **WebSocket messages**  | `ws.onMessage` data                                  | Untrusted   |

### How to Find Sources

For a given endpoint/handler, read the function signature and body to identify which parameters come from external input.

```
# Find where request data is accessed
grep_search: "req\.(body|params|query|headers|cookies|files)" (Express/Node)
grep_search: "request\.(args|form|json|data|headers|files|cookies)" (Flask/Django)
grep_search: "r\.FormValue\(|r\.URL\.Query\(\)|r\.Header\.Get\(" (Go)
grep_search: "@RequestParam|@PathVariable|@RequestBody|@RequestHeader" (Java/Spring)
```

---

## Step 2: Catalogue Sinks

Sinks are where data causes a security-sensitive effect. Find all sinks reachable from your current code path.

### Sink Categories

| Sink Type                 | Examples                                             | Vulnerability if Reached              |
| ------------------------- | ---------------------------------------------------- | ------------------------------------- |
| **Database query**        | `execute()`, `find()`, `query()`, ORM methods        | SQL/NoSQL injection                   |
| **Shell command**         | `exec()`, `system()`, `subprocess`, `child_process`  | Command injection                     |
| **File operation**        | `open()`, `readFile()`, `writeFile()`, `path.join()` | Path traversal, arbitrary file access |
| **HTTP response body**    | `res.send()`, `render()`, `innerHTML`                | XSS (reflected/stored)                |
| **HTTP redirect**         | `res.redirect()`, `Location` header                  | Open redirect                         |
| **Outbound HTTP request** | `fetch()`, `requests.get()`, `http.get()`            | SSRF                                  |
| **Template rendering**    | `render_template_string()`, `Template()`             | Server-side template injection        |
| **Logging**               | `logger.info()`, `console.log()`, `print()`          | Log injection, info disclosure        |
| **Deserialization**       | `pickle.load()`, `JSON.parse()` on complex types     | Insecure deserialization              |
| **Eval/Code exec**        | `eval()`, `Function()`, `exec()`                     | Remote code execution                 |

### How to Find Sinks

```
# Database sinks
grep_search: "\.execute\(|\.query\(|\.find\(|\.findOne\(|\.aggregate\("
grep_search: "\.raw\(|\.extra\(|connection\.cursor" (ORM escape hatches)

# Shell sinks
grep_search: "subprocess|child_process|os\.system|exec\(|spawn\("

# File sinks
grep_search: "open\(|readFile|writeFile|createReadStream|fs\."
grep_search: "path\.join\(|path\.resolve\(" (check if user input in path)

# Response sinks (XSS)
grep_search: "innerHTML|dangerouslySetInnerHTML|v-html|{!!.*!!}"
grep_search: "\.send\(|\.render\(|\.write\(" (check if user input reflected)
```

---

## Step 3: Trace the Path

For each source identified in Step 1, follow the data through the code to see if it reaches any sink from Step 2.

### Tracing Technique

1. **Start at the source**: Identify the variable name holding user input (e.g., `const userId = req.params.id`)
2. **Follow assignments**: Use `grep_search` to find everywhere `userId` is used
3. **Enter function calls**: When `userId` is passed to a function, use `view_code_item` to read that function and continue tracing
4. **Check for transformations**: At each step, note if the data is:
   - **Validated**: Type-checked, regex-matched, allowlisted → reduces risk
   - **Sanitized**: HTML-escaped, SQL-parameterized, shell-quoted → reduces risk
   - **Passed through**: Assigned to another variable, returned from a function → continue tracing
   - **Amplified**: Used to construct a larger string (query, command) → increases risk
5. **Stop at sinks**: When the data reaches a sink operation, record the complete path

### Example Trace

```
ENTRY POINT: app.get("/users/:id", getUser)

[SOURCE] req.params.id
    ↓ assigned to: userId (line 15)
    ↓ passed to: userService.findById(userId) (line 16)
        ↓ enters: userService.findById(id) (line 42 of userService.js)
        ↓ passed to: db.query(`SELECT * FROM users WHERE id = ${id}`) (line 45)
[SINK] db.query() — SQL execution with string interpolation

PATH: req.params.id → userId → userService.findById(id) → db.query(interpolated SQL)
SANITIZATION: NONE
VERDICT: SQL Injection — High Confidence
```

### Tracing Across Boundaries

Data often crosses these boundaries during its journey — don't stop tracing:

| Boundary                        | What Happens                                          | How to Continue                               |
| ------------------------------- | ----------------------------------------------------- | --------------------------------------------- |
| **Function call**               | Variable is passed as argument                        | Read the called function, trace the parameter |
| **Database roundtrip**          | User input stored, then retrieved elsewhere           | Search for reads of the same table/field      |
| **HTTP response → new request** | Data returned to client, sent back in another request | Map the client-side flow                      |
| **Message queue**               | Data published to queue, consumed elsewhere           | Find the consumer/subscriber                  |
| **File storage**                | Written to file, read later                           | Find all readers of that file/path            |

> [!IMPORTANT]
> **Stored data reuse** is the most commonly missed boundary. If user input is stored in a database and later retrieved and used in a query/template/command _without_ sanitization at the point of use, it's a **stored injection** vulnerability. Always check: is data sanitized at the point of _use_, not just at the point of _storage_?

---

## Step 4: Assess Sanitization

When you find sanitization between source and sink, evaluate its quality:

### Sanitization Quality Checklist

| Question                                            | Good Sign                                                    | Bad Sign                                          |
| --------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------- |
| Is it the right type of sanitization for this sink? | HTML escaping for HTML output, parameterized queries for SQL | HTML escaping used for SQL (wrong context)        |
| Is it applied consistently?                         | Every path through the code sanitizes                        | Some branches skip sanitization                   |
| Is it applied at the right layer?                   | Sanitization immediately before the sink                     | Sanitization at input, but data transformed after |
| Can it be bypassed?                                 | Uses well-tested library functions                           | Custom regex or string replacement                |
| Does it handle encoding?                            | Handles Unicode, null bytes, double-encoding                 | Only checks ASCII patterns                        |

### Common Sanitization Bypasses

| Sanitization                | Bypass Technique                                                           |
| --------------------------- | -------------------------------------------------------------------------- |
| **Blocklist of characters** | Unicode equivalents, double-encoding, null byte injection                  |
| **Regex validation**        | Anchoring issues (`^...$` vs `...`), multiline bypass, ReDoS               |
| **Client-side validation**  | Ignored entirely — always re-validate server-side                          |
| **Input-time sanitization** | Data transformed after sanitization (e.g., decoded, split, concatenated)   |
| **Single encoding layer**   | Double encoding: `%253C` → `%3C` (after first decode) → `<` (after second) |

---

## Step 5: Document the Flow

For each traced path, record it in this format:

```markdown
### Flow: [Entry Point] → [Sink]

**Source**: [Where user input enters] — `file:line`
**Sink**: [Where it causes an effect] — `file:line`
**Sink Type**: [DB query | Shell | File | HTTP response | Redirect | ...]

**Path**:

1. `req.params.id` (source) — `routes/users.js:15`
2. → `userService.findById(id)` — `routes/users.js:16`
3. → `db.query(...)` (sink) — `services/userService.js:45`

**Sanitization**: [None | Partial — describe | Complete — describe]
**Verdict**: [Vulnerable | Needs Investigation | Safe]
**Confidence**: [High | Medium | Low]
```

---

## Efficiency Tips

1. **Start with high-value sinks**: Prioritize DB queries, shell execution, and file operations over logging sinks
2. **Use `view_code_item`** to read whole functions rather than individual lines — you need the full context
3. **Batch by sink type**: Trace all SQL sinks first, then all shell sinks — you'll develop pattern recognition
4. **Don't trace obvious safe paths**: If input goes through a well-tested ORM method (e.g., `Model.findByPk(id)`) with no raw SQL, note it as safe and move on
5. **Focus on escape hatches**: When an ORM or framework is used, focus on `.raw()`, `.extra()`, `.execute()` — the places developers bypass the safety layer
