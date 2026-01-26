# Content Security Policy (CSP) Deep Dive

CSP is the most effective defense against Cross-Site Scripting (XSS). It tells the browser exactly what resources are allowed to load.

---

## 1. Anatomy of a Directive

`Content-Security-Policy: <directive> <source>; <directive> <source>; ...`

| Directive     | Controls                      | Example                         |
| ------------- | ----------------------------- | ------------------------------- |
| `default-src` | Fallback for other directives | `'self'`                        |
| `script-src`  | JavaScript sources            | `'self' https://trusted.com`    |
| `style-src`   | CSS sources                   | `'self' 'unsafe-inline'`        |
| `img-src`     | Images                        | `'self' data: https://blob:`    |
| `connect-src` | FETCH/XHR requests            | `'self' https://api.stripe.com` |

---

## 2. Modern Approaches: Nonces (Recommended)

Allowing inline scripts is risky (`'unsafe-inline'`), but modern frameworks (Next.js) often need them. The solution is a **Nonce** (Number used ONCE).

### Flow

1. Server generates a random cryptographic string (nonce).
2. Server sends header: `script-src 'nonce-RANDOM123'`.
3. HTML includes script: `<script nonce="RANDOM123">...</script>`.
4. Browser executes ONLY scripts with the matching nonce.

### Next.js Implementation

```typescript
// middleware.ts
import { NextResponse } from "next/server";

export function middleware(request: Request) {
  const nonce = Buffer.from(crypto.randomUUID()).toString("base64");

  // Create CSP Header
  const cspHeader = `
    default-src 'self';
    script-src 'self' 'nonce-${nonce}' 'strict-dynamic';
    style-src 'self' 'nonce-${nonce}';
    img-src 'self' blob: data:;
    font-src 'self';
    object-src 'none';
    base-uri 'self';
    form-action 'self';
    frame-ancestors 'none';
    block-all-mixed-content;
    upgrade-insecure-requests;
  `
    .replace(/\s{2,}/g, " ")
    .trim();

  const requestHeaders = new Headers(request.headers);
  requestHeaders.set("x-nonce", nonce); // Pass to app
  requestHeaders.set("Content-Security-Policy", cspHeader);

  const response = NextResponse.next({
    request: { headers: requestHeaders },
  });

  response.headers.set("Content-Security-Policy", cspHeader);
  return response;
}
```

---

## 3. CSP Reporting

Don't guess if your CSP breaks things. Use `report-only` first, then enforce.

### Report-Only Mode

`Content-Security-Policy-Report-Only: default-src 'self'; report-uri /api/csp-report;`

Browser will load the resource but send a JSON POST to `/api/csp-report`.

### Report Endpoint (Node.js)

```typescript
app.post(
  "/api/csp-report",
  bodyParser.json({ type: "application/csp-report" }),
  (req, res) => {
    const report = req.body["csp-report"];
    console.warn(`[CSP VIOLATION]`, {
      blocked: report["blocked-uri"],
      violated: report["violated-directive"],
      page: report["document-uri"],
    });
    res.status(204).end();
  },
);
```

---

## 4. Common Pitfalls

| Mistake                 | Risk                              | Fix                                   |
| ----------------------- | --------------------------------- | ------------------------------------- |
| `script-src: *`         | Allows any script from anywhere   | Use specific domains or nonces        |
| `unsafe-inline`         | Allows XSS loops                  | Use nonces                            |
| `data:` in `script-src` | Attackers can encode malicious JS | Remove `data:` from script/object src |
| Missing `object-src`    | Flash/Java applet injection       | Always set `object-src 'none'`        |
