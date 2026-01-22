# Authentication & Authorization Patterns

Secure implementations for common identity flows.

---

## JWT Strategy (Access + Refresh Token)

The most common stateless auth pattern.

- **Access Token**: Short-lived (15m), holds permissions.
- **Refresh Token**: Long-lived (7d), securely stored, used to get new access tokens.

### TypeScript Implementation

```typescript
import jwt from "jsonwebtoken";

interface Tokens {
  accessToken: string;
  refreshToken: string;
}

function generateTokens(userId: string): Tokens {
  // 1. Access Token: Short expiry, contains user claim
  const accessToken = jwt.sign({ userId }, process.env.JWT_SECRET!, {
    expiresIn: "15m",
  });

  // 2. Refresh Token: Long expiry, strictly for renewal
  const refreshToken = jwt.sign(
    { userId, type: "refresh" },
    process.env.JWT_REFRESH_SECRET!,
    { expiresIn: "7d" },
  );

  return { accessToken, refreshToken };
}
```

### 🔒 Security Critical: Refresh Token Rotation

When a refresh token is used, **revoke it and issue a new pair**. This prevents stolen refresh tokens from being used indefinitely.

---

## Secure Password Reset

Avoids user enumeration and timing attacks.

### Principles

1. **Don't reveal user existence**: Always say "If that email exists, we sent a link."
2. **Short expiry**: 15-60 minutes max.
3. **Hash the token**: Store hash in DB, send raw token to user.

### Implementation Pattern

```typescript
import crypto from "crypto";

async function initiatePasswordReset(email: string) {
  const user = await db.users.findByEmail(email);

  // 🛑 SECURITY: Return normally even if user not found (Time-constant preferred)
  if (!user) return;

  // 1. Generate high-entropy token
  const token = crypto.randomBytes(32).toString("hex");

  // 2. Hash it before storage (Leaked DB won't compromise reset links)
  const hashedToken = crypto.createHash("sha256").update(token).digest("hex");

  // 3. Store hash + expiry
  await db.passwordResets.create({
    userId: user.id,
    token: hashedToken,
    expiresAt: new Date(Date.now() + 60 * 60 * 1000), // 1 hour
  });

  // 4. Send RAW token via email
  await sendEmail(email, `Reset link: https://app.com/reset?token=${token}`);
}
```

---

## Multi-Factor Authentication (TOTP)

Using Time-based One-Time Passwords (e.g., Google Authenticator).

### TypeScript Implementation (otplib)

```typescript
import { authenticator } from "otplib";
import QRCode from "qrcode";

// 1. Setup Phase
async function setupMFA(userId: string) {
  const secret = authenticator.generateSecret();
  const otpauth = authenticator.keyuri(userId, "MyApp", secret);

  // Generate QR for user to scan
  const qrCode = await QRCode.toDataURL(otpauth);

  // Store ENCRYPTED secret in DB
  await db.users.update(userId, { mfaSecret: encrypt(secret) });

  return { qrCode, secret }; // User must confirm code immediately
}

// 2. Verify Phase
function verifyMFA(token: string, secret: string): boolean {
  return authenticator.verify({ token, secret });
}
```

---

## OAuth 2.0 Security Checklist

If using "Login with Google/GitHub":

- [ ] **State Parameter**: Always use `state` to prevent CSRF during callback.
- [ ] **PKCE**: Use Proof Key for Code Exchange (PKCE) for mobile/SPA apps.
- [ ] **Scope Minimization**: Request only what you need (`user:email`), not full repo access.
- [ ] **Redirect URI Validation**: Strict matching on provider side.
