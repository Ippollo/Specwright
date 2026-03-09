# Hunting Patterns — Vulnerability Detection Sensors

Deep grep/search patterns organized by vulnerability class. Each section provides:

- **Search patterns** to run against the codebase
- **What to investigate** when a pattern matches
- **Language-specific variants** covering TypeScript/JavaScript, Python, Go, Java, C/C++, Ruby, PHP

> Use these patterns during **Phase 1** (attack surface mapping) and **Phase 3** (vulnerability hunting) of the audit protocol.

---

## 1. Injection Patterns

### 1.1 SQL Injection

**Goal**: Find any place where user input is concatenated or interpolated into SQL queries.

#### Search Patterns

```
# String concatenation in SQL (all languages)
grep_search: "SELECT.*\+.*req\." or "SELECT.*\+.*params" or "SELECT.*\+.*input"
grep_search: "INSERT.*\+.*req\." or "UPDATE.*\+.*req\." or "DELETE.*\+.*req\."

# Python f-strings / format in SQL
grep_search: "execute\(f['\"]" or "execute\(.*\.format\("
grep_search: "cursor\.execute\(.*%" (old-style string formatting)
grep_search: "text\(f['\"]" (SQLAlchemy text() with f-string)

# JavaScript/TypeScript template literals in SQL
grep_search: "query\(`.*\$\{" or "execute\(`.*\$\{"
grep_search: "raw\(`.*\$\{" (ORM raw queries)

# Go string concatenation in SQL
grep_search: "db\.Query\(.*\+" or "db\.Exec\(.*\+"
grep_search: "fmt\.Sprintf.*SELECT" or "fmt\.Sprintf.*INSERT"

# Java string concatenation in SQL
grep_search: "Statement.*execute.*\+" or "createQuery\(.*\+"
grep_search: "nativeQuery.*\+" (JPA native queries)

# Ruby string interpolation in SQL
grep_search: "where\(\".*#\{" or "execute\(\".*#\{"

# PHP string concatenation in SQL
grep_search: "mysql_query\(.*\." or "mysqli_query\(.*\$"
grep_search: "->query\(.*\." or "->prepare" (check if ACTUALLY parameterized)
```

#### Investigation Protocol

When a pattern matches:

1. **Trace the interpolated variable** backward to its origin — is it from user input?
2. **Check if there's an ORM layer** between the raw query and the route handler — sometimes raw queries are in utility functions called safely
3. **Check for type coercion** — if the input is cast to `int` before interpolation, injection risk is greatly reduced
4. **Check for allowlists** — if the variable is matched against a finite set of allowed values (e.g., valid column names for ORDER BY)
5. **Grade**: Unparameterized + from user input + no validation = **Critical**

---

### 1.2 Command Injection

**Goal**: Find shell execution functions that include user-controlled input.

#### Search Patterns

```
# Python
grep_search: "os\.system\(" or "os\.popen\(" or "subprocess\.call\(.*shell=True"
grep_search: "subprocess\.Popen\(.*shell=True" or "subprocess\.run\(.*shell=True"
grep_search: "exec\(" or "eval\(" (code injection variant)

# JavaScript/TypeScript
grep_search: "child_process" or "exec\(" or "execSync\(" or "spawn\("
grep_search: "eval\(" or "Function\(" or "setTimeout\(.*string"

# Go
grep_search: "exec\.Command\(" or "os/exec"
grep_search: "sh.*-c" (shell invocation via sh -c with user input)

# Java
grep_search: "Runtime\.getRuntime\(\)\.exec\(" or "ProcessBuilder\("

# C/C++
grep_search: "system\(" or "popen\(" or "execvp\(" or "execl\("

# Ruby
grep_search: "system\(" or "exec\(" or "`.*#\{" (backtick execution with interpolation)
grep_search: "IO\.popen\(" or "Open3\."

# PHP
grep_search: "shell_exec\(" or "passthru\(" or "system\(" or "exec\("
grep_search: "proc_open\(" or "popen\("
```

#### Investigation Protocol

1. **Is `shell=True`?** (Python) or is the command a single string rather than an array? Single strings are parsed by the shell and allow chaining
2. **What's in the command string?** If user input is anywhere in the string, it's likely vulnerable
3. **Is the input quoted/escaped?** `shlex.quote()` (Python), `shellescape` (Ruby) — these help but can still be bypassed in edge cases
4. **Is the function necessary?** Often shell calls can be replaced with library calls (e.g., `shutil.copy` instead of `cp`)
5. **Grade**: User input in shell command string + no escaping = **Critical**

---

### 1.3 Template Injection (SSTI)

#### Search Patterns

```
# Python (Jinja2, Mako)
grep_search: "render_template_string\(" (almost always vulnerable if user input involved)
grep_search: "Template\(.*request" or "Template\(.*input"
grep_search: "from_string\(" (Jinja2 Environment.from_string)

# JavaScript (EJS, Pug, Handlebars)
grep_search: "ejs\.render\(.*req\." or "compile\(.*req\."
grep_search: "res\.render\(.*req\." (if first arg is user-controlled, it's path traversal too)

# Java (Thymeleaf, Freemarker)
grep_search: "process\(.*new StringTemplateResolver"
grep_search: "new Template\(.*getName\("
```

#### Investigation Protocol

1. **Is user input IN the template itself** (not just a template variable)? That's the critical distinction
2. Template engines mostly escape _output_ — they don't protect against _template code_ in user input
3. Test payload reasoning: `{{ 7*7 }}` → if it renders `49`, it's vulnerable
4. **Grade**: User input as template content = **Critical**; user input as template variable = Normal/safe usage

---

### 1.4 NoSQL Injection

#### Search Patterns

```
# MongoDB
grep_search: "find\(\{.*req\." or "findOne\(\{.*req\." or "findOneAndUpdate\(\{.*req\."
grep_search: "aggregate\(\[.*req\." or "\$where"

# Check for object injection (client sends {$gt: ""})
grep_search: "req\.body\." followed by direct use in query without type validation
```

#### Investigation Protocol

1. **Is the query parameter validated as a string?** MongoDB operators like `$gt`, `$ne`, `$regex` are objects — if user input can be an object (parsed from JSON body), it's injectable
2. **Check for schema validation**: Zod, Joi, Mongoose schema — if input is forced to string type, it's safe
3. **Grade**: Direct use of parsed JSON body in MongoDB query without type validation = **High**

---

## 2. XSS Patterns

### 2.1 Reflected / Stored XSS

**Goal**: Find where user input is rendered in HTML output without adequate escaping.

#### Search Patterns

```
# Dangerous DOM sinks (JavaScript)
grep_search: "innerHTML|outerHTML|document\.write\(|document\.writeln\("
grep_search: "dangerouslySetInnerHTML" (React)
grep_search: "v-html" (Vue)
grep_search: "{!!.*!!}" (Blade/Laravel raw output)
grep_search: "\|safe" or "\|raw" or "{% autoescape false" (Jinja2/Django raw output)
grep_search: "<%=.*%>" vs "<%-.*%>" (EJS — unescaped vs escaped)

# Server-side rendering without escaping
grep_search: "res\.send\(.*req\." or "res\.write\(.*req\." (Express reflecting input)
grep_search: "Response\(.*request\." (Flask/Django reflecting input)
grep_search: "render_template" (safe if using template variables, check for |safe filter)

# User input in URL contexts (javascript: scheme)
grep_search: "href=.*req\.|href=.*user|src=.*req\.|src=.*user"
grep_search: "window\.location.*=|document\.location.*="
```

#### Investigation Protocol

1. **Is the output in raw HTML or does the framework auto-escape?** React/Angular auto-escape; raw template engines and `innerHTML` do not
2. **What context is the output in?** HTML body, attribute, JavaScript, URL, or CSS — each needs different escaping
3. **For stored XSS**: Trace where user input is stored, then find all places it's rendered — the sink may be in a completely different part of the app
4. **Check CSP headers**: Even if XSS exists, a strict CSP can block exploitation
5. **Grade**: User input → raw HTML output without escaping = **High**; stored and rendered to other users = **Critical**

### 2.2 DOM-Based XSS

#### Search Patterns

```
# JavaScript sources (client-side user input)
grep_search: "location\.hash|location\.search|location\.href"
grep_search: "document\.referrer|document\.URL|document\.documentURI"
grep_search: "window\.name|postMessage"
grep_search: "URLSearchParams|url\.searchParams"

# JavaScript sinks
grep_search: "eval\(|setTimeout\(.*,|setInterval\(.*," (with string args)
grep_search: "\.innerHTML.*=|\.outerHTML.*="
grep_search: "document\.write|document\.writeln"
grep_search: "jQuery\.html\(|\$\(.*\)\.html\(" (jQuery)
```

#### Investigation Protocol

1. **Does client-side code read from a source** (URL, hash, referrer, message) **and write to a sink** (innerHTML, eval, document.write)?
2. **Is there sanitization between source and sink?** DOMPurify is robust; custom regex is not
3. **Grade**: Client-side source → DOM sink without sanitization = **High**

---

## 3. CSRF Patterns

#### Search Patterns

```
# Check for CSRF middleware/protection
grep_search: "csrf|CSRF|xsrf|XSRF" (any CSRF token implementation)
grep_search: "csrfProtection|csurf|csrf_exempt|@csrf_protect"
grep_search: "SameSite" (cookie attribute)
grep_search: "Origin.*check|Referer.*check" (header validation)

# State-changing routes WITHOUT CSRF protection
# Cross-reference POST/PUT/DELETE routes with CSRF middleware presence
grep_search: "app\.post\(|app\.put\(|app\.delete\(" and check for csrf middleware
grep_search: "@csrf_exempt" (Django — explicitly exempted routes)
grep_search: "verify.*false|csrf.*false|csrf.*disable" (disabled CSRF)
```

#### Investigation Protocol

1. **Is the app cookie-based?** API-token-based apps are inherently CSRF-resistant
2. **Is CSRF middleware globally applied or per-route?** Per-route is easy to forget
3. **Are there exemptions?** `@csrf_exempt` routes need extra scrutiny
4. **Grade**: State-changing endpoint + cookie auth + no CSRF protection = **Medium**

---

## 4. Access Control Patterns

### 2.1 Missing Authorization

#### Search Patterns

```
# Find all route definitions, then check which ones lack auth middleware
# Step 1: List all routes
grep_search: "app\.(get|post|put|delete)\(" or "@(app\.)?(route|get|post|put|delete)"
grep_search: "router\.(get|post|put|delete)\("

# Step 2: Check for auth middleware
grep_search: "requireAuth|isAuthenticated|authorize|@login_required|@requires_auth"
grep_search: "passport\.authenticate|jwt\.verify|verifyToken|authMiddleware"

# Step 3: Cross-reference — routes WITHOUT auth middleware patterns are candidates.
```

#### Investigation Protocol

1. **List all routes** and tag each as auth-required or public
2. **Check if there's global middleware** that applies auth to all routes (then look for explicit exemptions)
3. **Check for gaps**: New routes added without auth, test routes left active, admin routes without role checks
4. **Grade**: Sensitive endpoint without any auth check = **Critical**

### 2.2 IDOR

#### Search Patterns

```
# Resources fetched by ID from URL params
grep_search: "params\.(id|userId|orderId|invoiceId)" or "req\.params\["
grep_search: "request\.args\.get\(" or "request\.form\.get\("

# Then check: is there an ownership check?
# Look for patterns like: if record.owner_id != current_user.id
grep_search: "owner|user_id|userId|created_by|belongsTo"
```

#### Investigation Protocol

1. **Find resource-by-ID endpoints** (any endpoint with `:id`, `{id}`, or similar)
2. **For each**: Does it verify the requesting user has access to that specific resource?
3. **Check both read AND write**: Often reads are protected but updates/deletes aren't
4. **Grade**: Resource access by ID without ownership check = **High**

---

## 3. Authentication Patterns

### 3.1 Weak JWT

#### Search Patterns

```
grep_search: "jwt\.sign\(" or "jwt\.encode\(" or "jwt\.verify\(" or "jwt\.decode\("
grep_search: "algorithm.*none" or "algorithms.*\[" (check if 'none' is in allowed algorithms)
grep_search: "secret.*=.*['\"]" (hardcoded JWT secret)
grep_search: "HS256|RS256|ES256" (check algorithm choice)
grep_search: "expiresIn|exp" (check if expiration is set)
```

#### Investigation Protocol

1. **Is the secret hardcoded?** Check for string literals in sign/verify calls
2. **Is `none` algorithm allowed?** Some libraries accept `alg: none` if not explicitly blocked
3. **Is expiration enforced?** JWTs without expiration are permanent credentials
4. **Is the secret strong enough?** Short or common strings can be brute-forced
5. **Grade**: Hardcoded secret = **Critical**; no expiration = **High**; `none` allowed = **Critical**

### 3.2 Weak Password Handling

#### Search Patterns

```
grep_search: "md5\(|sha1\(|sha256\(" (used for passwords — these are too fast)
grep_search: "bcrypt|argon2|scrypt|pbkdf2" (correct algorithms)
grep_search: "password.*==|password.*===|password.*equals" (timing-safe comparison?)
grep_search: "compareSync|compare\(" (bcrypt compare — good)
```

---

## 5. Path Traversal Patterns

#### Search Patterns

```
# File operations with user input
grep_search: "path\.join\(.*req\.|path\.join\(.*params|path\.resolve\(.*req\."
grep_search: "open\(.*req\.|open\(.*params|open\(.*input"
grep_search: "readFile\(.*req\.|readFileSync\(.*req\."
grep_search: "send_file\(.*request\.|sendFile\(.*req\."
grep_search: "os\.path\.join\(.*request" (Python)
grep_search: "filepath\.Join\(.*r\." (Go)

# Direct file access patterns
grep_search: "\.\./|%2e%2e|%252e" (traversal sequences — check if these appear in tests or docs)
grep_search: "__file__|__dir__" (reference to current file/dir — may indicate file serving logic)
```

#### Investigation Protocol

1. **Is any URL parameter used to construct a file path?** Endpoints like `/download?file=x` or `/images/:name`
2. **Is the path resolved to absolute** and then checked against a base directory?
3. **Does `path.join()` prevent traversal?** It does NOT — `path.join('/base', '../../../etc/passwd')` resolves to `/etc/passwd`
4. **Grade**: User input in file path + no base directory check = **High**

---

## 6. File Upload Patterns

#### Search Patterns

```
# Upload handlers
grep_search: "multer|formidable|busboy|multiparty" (Node.js upload middleware)
grep_search: "request\.files|FileField|ImageField" (Python/Django)
grep_search: "\$_FILES|move_uploaded_file" (PHP)
grep_search: "@RequestPart|MultipartFile" (Java/Spring)

# File type checks
grep_search: "mimetype|content-type|file\.type" (check if validated)
grep_search: "extension|extname|path\.ext" (check if validated)
grep_search: "allowedTypes|acceptedTypes|ALLOWED_EXTENSIONS" (allowlist exists?)

# Storage location
grep_search: "public/|static/|uploads/|www/" (web-accessible directories)
grep_search: "originalname|original_filename" (using user-supplied filename)
```

#### Investigation Protocol

1. **Is file type validated?** Both extension AND content (magic bytes) should be checked
2. **Is validation server-side?** Client-side `accept=` attributes are trivially bypassed
3. **Where are files stored?** In webroot = executable; outside webroot = safer
4. **Is the original filename used?** It can contain `../` for path traversal
5. **Grade**: No type validation + webroot storage = **Critical**; no filename sanitization = **High**

---

## 7. SSRF / Open Redirect Patterns

#### Search Patterns

```
# Server-side requests with user input
grep_search: "fetch\(.*req\." or "axios\(.*req\." or "requests\.get\(.*request\."
grep_search: "http\.get\(.*req\." or "urllib\.request\." or "curl_exec\("
grep_search: "HttpClient|WebClient|RestTemplate" (Java)

# Redirects
grep_search: "redirect\(.*req\." or "res\.redirect\(.*req\."
grep_search: "Location.*req\." or "301|302|307|308.*req\."
grep_search: "window\.location.*=.*param|document\.location.*=.*param" (client-side)

# Cloud metadata endpoints (SSRF target)
grep_search: "169\.254\.169\.254" or "metadata\.google" or "metadata\.aws"
```

#### Investigation Protocol

1. **Is the URL user-controlled?** Fully or partially (scheme, host, path, query)?
2. **Is there an allowlist?** Blocklists are insufficient (DNS rebinding, IP encoding bypasses)
3. **Can it reach internal services?** Cloud metadata endpoints are the highest-value SSRF target
4. **Grade**: Full URL from user input + no validation = **Critical**; redirect without validation = **Medium**

---

## 8. Secrets and Configuration Patterns

#### Search Patterns

```
# Hardcoded secrets
grep_search: "(api_key|apikey|api_secret|secret_key|password|token|credential)\s*=\s*['\"]" --case-insensitive
grep_search: "AKIA[0-9A-Z]{16}" (AWS access key pattern)
grep_search: "ghp_[a-zA-Z0-9]{36}" (GitHub personal access token)
grep_search: "sk-[a-zA-Z0-9]{48}" (OpenAI API key pattern)
grep_search: "-----BEGIN (RSA |EC )?PRIVATE KEY-----" (private keys)

# Debug/development mode in production configs
grep_search: "DEBUG\s*=\s*True" or "NODE_ENV.*development" (check if in production configs)
grep_search: "FLASK_DEBUG|DJANGO_DEBUG"

# Default credentials
grep_search: "admin.*password|password.*admin|root.*password|test.*password"
```

---

## 9. Cryptographic Weakness Patterns

#### Search Patterns

```
# Weak hashing
grep_search: "md5\(|MD5\.|hashlib\.md5|DigestUtils\.md5"
grep_search: "sha1\(|SHA1\.|hashlib\.sha1|DigestUtils\.sha1"

# Weak randomness
grep_search: "Math\.random\(\)" or "random\.random\(\)" or "rand\(\)" (for security-sensitive use)
grep_search: "uuid" (check if v4/random or v1/time-based)

# Weak encryption
grep_search: "DES|3DES|RC4|Blowfish" (legacy ciphers)
grep_search: "ECB" (electronic codebook mode — patterns preserved)
grep_search: "AES.*CBC" (ok, but check for padding oracle)

# TLS configuration
grep_search: "verify=False|verify_ssl=False|rejectUnauthorized.*false|InsecureSkipVerify"
grep_search: "TLSv1[^.]|SSLv3|SSLv2" (legacy TLS versions)
```

---

## 10. Deserialization Patterns

#### Search Patterns

```
# Python
grep_search: "pickle\.loads\(" or "pickle\.load\(" or "yaml\.load\(" (without SafeLoader)
grep_search: "marshal\.loads\(" or "shelve\."
grep_search: "yaml\.safe_load" (safe — but verify it's used consistently)

# Java
grep_search: "ObjectInputStream|readObject\(|Serializable"
grep_search: "XMLDecoder|XStream|SnakeYAML"

# PHP
grep_search: "unserialize\(" or "maybe_unserialize\("

# Ruby
grep_search: "Marshal\.load\(" or "YAML\.load\("

# .NET
grep_search: "BinaryFormatter|SoapFormatter|NetDataContractSerializer"
grep_search: "JsonConvert\.DeserializeObject.*TypeNameHandling"
```

---

## 11. Business Logic Patterns

#### Search Patterns

```
# State machine / workflow indicators
grep_search: "status.*=.*|state.*=.*|step.*=.*|phase.*=" (state transitions)
grep_search: "checkout|payment|approval|verify|confirm|finalize"

# Numeric operations on user-controlled values
grep_search: "quantity.*req\.|amount.*req\.|price.*req\.|discount.*req\."
grep_search: "parseInt\(req\.|parseFloat\(req\.|Number\(req\."
grep_search: "int\(request\.|float\(request\." (Python)

# Race condition indicators
grep_search: "transaction|atomic|lock|mutex|semaphore" (check if present — their absence in concurrent code is a finding)
grep_search: "balance.*-=|stock.*-=|count.*-=" (decrement operations without locks)
```

#### Investigation Protocol

1. **Are workflow steps enforced server-side?** Or can calling step 3 without completing steps 1-2 succeed?
2. **Does the server trust client-side values?** If price/discount/quantity comes from the client, can it be negative?
3. **Are concurrent requests handled?** Two simultaneous purchases on the last item in stock — what happens?
4. **Grade**: Client-trusted price = **Critical**; skippable workflow steps = **High**; missing transaction locks = **Medium**

---

## 12. Dependency Vulnerability Patterns

#### Search Patterns

```
# Package manifests
grep_search: "package\.json|requirements\.txt|pyproject\.toml|Gemfile|go\.mod|Cargo\.toml|pom\.xml|build\.gradle"

# Lock files (should exist and be committed)
grep_search: "package-lock\.json|yarn\.lock|pnpm-lock\.yaml|Pipfile\.lock|poetry\.lock|Gemfile\.lock|go\.sum|Cargo\.lock"

# Suspicious install hooks
grep_search: "preinstall|postinstall|prepare" (in package.json scripts — check for suspicious commands)

# Wildcard or unpinned versions
grep_search: "\"\*\"|latest|>=" (in dependency versions — indicates unpinned dependencies)
```

#### Investigation Protocol

1. **Run the audit tool**: `npm audit`, `pip-audit`, `cargo audit`, `bundle audit`, `govulncheck`
2. **Check lock file**: Is it committed? Is it recent? Large gaps between lock file updates = accumulated vulnerabilities
3. **Check postinstall scripts**: These run arbitrary code during `npm install` — a supply chain attack vector
4. **Grade**: Known critical CVE in direct dependency = **Critical**; outdated lock file = **Medium**

---

## 13. Mobile / Native Patterns

#### Search Patterns

```
# Insecure local storage (Android)
grep_search: "SharedPreferences|getSharedPreferences" (check if storing sensitive data)
grep_search: "MODE_WORLD_READABLE|MODE_WORLD_WRITABLE"

# Insecure local storage (iOS)
grep_search: "UserDefaults|NSUserDefaults" (check if storing sensitive data)
grep_search: "Keychain" (correct — but verify usage)

# Certificate pinning (or lack thereof)
grep_search: "TrustManager|X509TrustManager|checkServerTrusted" (Android — check for empty implementations)
grep_search: "ATS|App Transport Security|NSAppTransportSecurity" (iOS plist)
grep_search: "certificatePinner|ssl_pinning|pinning"

# WebView vulnerabilities
grep_search: "setJavaScriptEnabled\(true\)|addJavascriptInterface|loadUrl.*javascript:"
grep_search: "WKWebView|UIWebView|WebView" (check for JavaScript bridge security)

# Deep link / URL scheme
grep_search: "intent-filter|scheme=|CFBundleURLSchemes|deeplink|universal-links"

# Embedded API keys
grep_search: "BuildConfig\.|API_KEY|apiKey|api_key" (in mobile source)
```

---

## Usage Notes

- **Run Phase 1 patterns first** to map the attack surface broadly
- **Then run Phase 3 patterns** selectively based on the technology stack identified
- **Always investigate matches** — a pattern match is a _lead_, not a confirmed vulnerability
- **Cross-reference with Phase 2** — a dangerous sink is only a vulnerability if attacker-controlled input reaches it
