---
name: api-design-patterns
description: Use when designing or reviewing REST/GraphQL APIs, choosing versioning strategies, implementing rate limiting, or defining API security. Covers naming conventions, error envelopes, status codes, and OpenAPI specs.
---

# API Design Patterns

> **Thinking > Copying.**
> This skill is a modular toolkit. Read only the sections relevant to your current task.

## 📑 Content Map

| Context         | File                   | Description                                 |
| :-------------- | :--------------------- | :------------------------------------------ |
| **Foundation**  | `rest.md`              | Start here. Naming, methods, status codes.  |
| **New Project** | `versioning.md`        | Plan your API evolution strategy early.     |
| **Security**    | `security.md`          | Auth (JWT/Keys), CORS, sanitization.        |
| **Performance** | `rate-limiting.md`     | Protecting endpoints from abuse.            |
| **Complex Ops** | `async-operations.md`  | Long-running tasks, webhooks, 202 Accepted. |
| **GraphQL**     | `graphql.md`           | Schema design, N+1 prevention.              |
| **Advanced**    | `advanced-patterns.md` | HATEOAS, bulk ops, circuit breakers.        |
| **Examples**    | `examples/`            | Concrete OpenAPI specs and Zod schemas.     |

## ✅ Decision Checklist

**Before writing code:**

- [ ] **Protocol**: REST vs GraphQL? (See `SKILL.md` (original) or `rest.md`/`graphql.md`)
- [ ] **Versioning**: URI (`/v1/`) or Header? (See `versioning.md`)
- [ ] **Security**: Public (API Key) or User (JWT)? (See `security.md`)
- [ ] **Errors**: Is the error envelope standard? (See `examples/response-envelope.json`)
- [ ] **Docs**: Is the OpenAPI spec started? (See `examples/openapi-template.yaml`)

## ❌ Anti-Patterns (The "Don't Do" List)

1. **Don't use Verbs in URIs**: `POST /createUser` -> `POST /users`.
2. **Don't return raw Arrays**: Always wrap in `{ data: [...] }` to allow future metadata.
3. **Don't ignore N+1**: Use DataLoader (GraphQL) or `include` (ORM) to prevent DB floods.
4. **Don't break clients**: Never rename fields without a version bump.
5. **Don't leak internals**: `500 Server Error` with a stack trace is a security risk.

## 🛠️ Tools

- **Linter**: Run `python scripts/api_linter.py <path_to_openapi.yaml>` (TODO) to check your spec.
- **Validation**: Use `examples/zod-validation.ts` as a baseline.
