---
name: security-hardening
description: Use when performing security audits, implementing authentication/authorization, hardening an app for production, or reviewing code for OWASP Top 10 vulnerabilities. Covers CSP headers, auth strategy decision trees, and pre-deployment security checklists.
metadata:
  pattern: reviewer
---

# Security Hardening Checklist

Guard against skipping critical security controls. Detailed references are in `references/`.

> **Core Principle**: Security is not a feature; it's a baseline requirement. Implement these controls _during_ development, not after.

## Pre-Deployment Checklist

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
- [ ] SQL queries parameterized (no string concat)
- [ ] XSS prevented (CSP + auto-escaping)
- [ ] JSON body size limited (prevent DoS)
- [ ] File uploads validated (type + size + malware scan)

### Infrastructure
- [ ] HTTPS enforced (HSTS)
- [ ] Secrets managed via env vars (not committed)
- [ ] `npm audit` passes with 0 critical
- [ ] Production logs do not contain PII/Secrets
- [ ] `NODE_ENV=production` set; debug mode off
- [ ] API does not return stack traces to clients

## Reference Files

- OWASP Top 10 details → `references/owasp-vulnerabilities.md`
- Auth strategy patterns → `references/auth-patterns.md`
- CSP deep dive → `references/csp-deep-dive.md`
- Security logging → `references/security-logging.md`
- Audit script → `scripts/security-audit.sh`

For full vulnerability hunting methodology, use the `security-audit` skill.
