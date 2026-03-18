---
name: security-hardening
description: Use when performing security audits, implementing authentication/authorization, hardening an app for production, or reviewing code for OWASP Top 10 vulnerabilities. Covers CSP headers, auth strategy decision trees, and pre-deployment security checklists.
metadata:
  pattern: reviewer
---

# Security Hardening & Best Practices

Comprehensive protocols for "Secure by Design" development.

> **Core Principle**: Security is not a feature; it's a baseline requirement. Implement these controls _during_ development, not after.

## Table of Contents

- [OWASP Top 10 Quick Reference](#1-owasp-top-10-quick-reference)
- [Security Audit Protocol](#2-security-audit-protocol-workflow)
- [Auth Strategy Decision Tree](#3-auth-strategy-decision-tree)
- [Pre-Deployment Checklist](#6-enhanced-pre-deployment-checklist)

---

## 1. OWASP Top 10 Quick Reference

Full implementation details in [references/owasp-vulnerabilities.md](./references/owasp-vulnerabilities.md).

| Rank    | Vulnerability             | Prevention Summary                                     |
| ------- | ------------------------- | ------------------------------------------------------ |
| **A01** | Broken Access Control     | Verify ownership on _every_ request (IDOR checks).     |
| **A02** | Cryptographic Failures    | Use `bcrypt`/`argon2` (cost 12+), Encrypt at rest.     |
| **A03** | Injection                 | Parameterized queries (SQL), Input validation (NoSQL). |
| **A04** | Insecure Design           | Threat modeling, Rate limiting, Secure defaults.       |
| **A05** | Security Misconfiguration | Hardened headers (Helmet), No default credentials.     |
| **A06** | Vulnerable Components     | `npm audit`, `pip-audit`, Dependency pinning.          |
| **A07** | Auth Failures             | MFA, Session management, Complexity rules.             |
| **A08** | Integrity Failures        | Signatures, `DOMPurify` for XSS.                       |
| **A09** | Logging Failures          | Log security events, Monitor spikes.                   |
| **A10** | SSRF                      | Private IP blocking, URL allowlists.                   |

---

## 2. Security Audit Protocol (Workflow)

Follow this process when reviewing an application for security gaps.

### Phase 1: Reconnaissance

1.  **Identify Entry Points**: List all API routes (`/api/*`) and public pages.
2.  **Identify Data Flows**: Where does user input go? (DB, Logs, External API).
3.  **Check Tech Stack**: Run `./scripts/security-audit.sh` to find low-hanging fruit (secrets, eval).

### Phase 2: Vulnerability Scanning

1.  **Dependencies**: Run `npm audit` / `pip check`.
2.  **Static Analysis**: Check for commonly misused functions (`dangerouslySetInnerHTML`, `exec`).
3.  **Configuration**: Review `.env.example` (no real secrets?) and `next.config.js`.

### Phase 3: Logic Review (High Risk)

1.  **AuthZ**: Pick 3 critical endpoints (e.g., `GET /invoice/:id`). Can User A access User B's data?
2.  **AuthN**: Try to bypass login. Is the session cookie `HttpOnly`?
3.  **Injection**: Check 3 search/filter inputs. Are they parameterized?

---

## 3. Auth Strategy Decision Tree

For detailed patterns, see [references/auth-patterns.md](./references/auth-patterns.md).

```mermaid
graph TD
    A[Start] --> B{Need User Accounts?}
    B -- No --> C[Public / API Key Only]
    B -- Yes --> D{Frontend Type?}
    d -- SPA / Mobile App --> E{Provider?}
    E -- 3rd Party (Google/GitHub) --> F[OAuth 2.0 + JWT Session]
    E -- Email/Pass --> G[JWT (Access + Refresh)]
    D -- Traditional / SSR (Next.js) --> H[Cookie-based Session (HttpOnly)]
```

---

## 4. CSP & Headers

HTTP Headers are your first line of defense.
See [references/csp-deep-dive.md](./references/csp-deep-dive.md).

- **Strict-Transport-Security (HSTS)**: Force HTTPS.
- **Content-Security-Policy (CSP)**: Prevent XSS.
- **X-Content-Type-Options**: Prevent MIME sniffing.

---

## 5. Logging & Monitoring

"You cannot fight what you cannot see."
See [references/security-logging.md](./references/security-logging.md).

- **Log**: Failed logins, Access denied, Sudo actions.
- **Do Not Log**: Passwords, API Keys, PII.

---

## 6. Enhanced Pre-Deployment Checklist

### Authentication

- [ ] Passwords hashed with `bcrypt`/`argon2` (cost ≥ 12)
- [ ] Session cookies are `httpOnly`, `secure`, `sameSite=strict`
- [ ] Password reset tokens hashed in DB
- [ ] MFA available for admin accounts

### Authorization

- [ ] IDOR checks on all resource-accessing endpoints
- [ ] API routes protected by middleware
- [ ] CORS restricted to specific production domains

### Input/Output

- [ ] SQL queries parameterized (No string concat)
- [ ] XSS prevented (CSP + Auto-escaping)
- [ ] JSON body size limited (prevent DoS)
- [ ] File uploads validated (type + size + malware scan)

### Infrastructure

- [ ] HTTPS enforced (HSTS)
- [ ] Secrets managed via env vars (not committed)
- [ ] `npm audit` passes with 0 critical
- [ ] Production logs do not contain PII/Secrets

---

## 7. Production Gotchas

Real-world issues that often slip through:

1.  **Debug Mode Left On**: Ensure `NODE_ENV=production` is set.
2.  **Verbose Error Messages**: API should not return stack traces to clients.
3.  **Default Admin Accounts**: Delete or change default CMS credentials.
4.  **Staging vs Prod**: Ensure staging secrets are different from production secrets.
5.  **Missing Rate Limits**: One API call is fast; 10k/sec will crash you.
