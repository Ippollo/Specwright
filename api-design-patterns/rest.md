# REST API Design Standards

## Resource Naming

- **Nouns, not Verbs**: Use `/users` to refer to resources, not `/getUsers` or `/create-user`. The HTTP verb tells the story.
- **Pluralization**: Group resources in plural collections: `/articles/123`, not `/article/123`.
- **Kebab-case**: Use dashes for URIs (`/user-profiles`) for readability and SEO. Use camelCase for JSON keys (`userProfiles`).
- **Nesting limit**: Keep nesting to a maximum of 2 levels deep.
  - Good: `/users/123/posts`
  - Bad: `/users/123/posts/456/comments/789` (Flatten to `/posts/456/comments` or `/comments/789`)

## HTTP Methods & Status Codes

| Method     | Status Success | Status Error    | Behavior                                                                                |
| :--------- | :------------- | :-------------- | :-------------------------------------------------------------------------------------- |
| **GET**    | 200 OK         | 404 Not Found   | Retrieve data. **Idempotent**.                                                          |
| **POST**   | 201 Created    | 400 Bad Request | Create new resource. Returns `Location` header or created object.                       |
| **PUT**    | 200 OK         | 404 Not Found   | **Full replacement**. Idempotent. If you send `{name: "Bob"}`, the old address is gone. |
| **PATCH**  | 200 OK         | 400 Bad Request | **Partial update**. Not necessarily idempotent (e.g. `count++`).                        |
| **DELETE** | 204 No Content | 404 Not Found   | Remove resource. Idempotent (calling twice is fine).                                    |

### Common Error Codes

- **400 Bad Request**: Validation failed (client error).
- **401 Unauthorized**: Authentication missing/invalid.
- **403 Forbidden**: Authenticated, but permissions denied.
- **429 Too Many Requests**: Rate limit exceeded.
- **500 Internal Server Error**: Bug/crash on server.

## Pagination

Use **cursor-based** pagination for feeds and strict order requirements; use **offset-based** for admin tables where jumping to "Page 5" is needed.

### 1. Cursor-based (Recommended for Performance)

```http
GET /items?limit=25&cursor=eyJpZCI6MjQ1fQ
```

- **Pros**: Scalable, handles realtime data additions well (no duplicate items).
- **Cons**: Can't jump to specific page.

### 2. Offset-based

```http
GET /items?limit=25&page=2
```

- **Pros**: Easy to implement, familiar UI pattern.
- **Cons**: Slow on large datasets (`OFFSET 1000000`), unstable with realtime inserts.

## Filtering & Sorting

### Filtering

Allow filtering by query parameters. Support operators if necessary.

```http
GET /users?status=active&role=admin
GET /products?price_min=10&price_max=100
```

### Sorting

Use a `sort` parameter. Use `-` prompt for descending.

```http
GET /users?sort=-created_at       // Descending
GET /users?sort=name              // Ascending
```

### Field Selection (Partial Response)

Allow clients to request only what they need (GraphQL-lite).

```http
GET /users/123?fields=id,name,avatar_url
```
