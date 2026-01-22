# GraphQL Design Standards

## Schema Design

- **Naming**: camelCase for fields (`firstName`), PascalCase for Types (`UserProfile`).
- **Nullability**: Mark fields non-null (`String!`) by default. Only make fields nullable if logically optional or if fetching failure shouldn't break the whole query.
- **Mutations**: Use the Verb-Noun pattern.
  - `createUser(input: CreateUserInput!): UserPayload!`
  - `addCommentToPost(...)`
- **Inputs**: Always use `Input` types for arguments, never scalar lists for complex data.
- **Payloads**: Return a payload object, not just the resource. This allows future metadata (like `userErrors`) without breaking changes.

```graphql
type CreateUserPayload {
  user: User # The created resource
  clientMutationId: String
  errors: [UserError!]!
}
```

## Performance & N+1 Prevention

The N+1 problem is the #1 killer of GraphQL performance.

- **DataLoader**: **MANDATORY** usage. Batch database lookups in the resolution layer.
  - _Scenario_: User has many Posts.
  - _Without DataLoader_: 1 query for User + 50 queries for 50 Posts.
  - _With DataLoader_: 1 query for User + 1 query for ALL 50 Posts (`WHERE id IN (...)`).

- **Query Complexity**: Implement depth limits and complexity analysis.
  - Prevent DoS attacks like `author { posts { author { posts { ... } } } }`.
  - Use libraries (e.g., `graphql-query-complexity`) to reject expensive queries.

## Error Handling

GraphQL generally returns `200 OK` even for errors. Inspect the `errors` array.

- **Top-level errors**: System/server errors (Internal Server Error, connection lost).
- **User-level errors**: Validation errors should be part of the **schema**, not the `errors` array.

```graphql
# Good Schema Error Handling
type Mutation {
  register(email: String!): RegisterPayload!
}

union RegisterPayload = RegisterSuccess | RegisterFailure

type RegisterFailure {
  reason: String!
  field: String
}
```
