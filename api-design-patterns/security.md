# API Security Patterns

## Authentication

### 1. Bearer Token (JWT)

Standard for modern web/mobile apps. stateless.

```http
Authorization: Bearer eyJhbGciOiJIUzI1Ni...
```

**Best Practices:**

- Short expiration (e.g., 15 mins).
- Use **Refresh Tokens** (long-lived) to rotate access tokens.
- Validate `aud` (audience) and `iss` (issuer).
- **NEVER** store sensitive data in the JWT payload (it's readable by anyone).

### 2. API Keys

For server-to-server communication or public API access.

```http
X-API-Key: sk_live_83j...
```

**Best Practices:**

- Use a header (`X-API-Key` or `Authorization: ApiKey ...`).
- **Avoid query parameters** (`?api_key=...`) as they leak in logs.
- Implement key rotation.
- Hash keys in the database (treat them like passwords).

### 3. OAuth2

For delegated access (allowing 3rd party apps to access user data).

- **Authorization Code Flow**: For server-side apps.
- **Client Credentials Flow**: For machine-to-machine.

## CORS (Cross-Origin Resource Sharing)

Configure CORS to prevent malicious websites from calling your API.

```http
Access-Control-Allow-Origin: https://app.mydomain.com
Access-Control-Allow-Methods: GET, POST, PUT, DELETE
Access-Control-Allow-Headers: Content-Type, Authorization
```

- **Don't use `*`** in production if you send credentials (cookies/auth headers).
- Handle `OPTIONS` preflight requests.

## Input Security

- **Sanitization**: Never trust input. Use schema validation (Zod, Pydantic, Joi).
- **SQL Injection**: Use parameterized queries or ORMs.
- **XSS**: Sanitize output if API data renders HTML.
