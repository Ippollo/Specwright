---
schema_version: 1.0
name: unit-testing-strategy
description: "Comprehensive unit testing patterns: TDD, mocking, fixtures, parametrization, and anti-patterns. Covers Python (pytest) and TypeScript (Jest/Vitest)."
---

# Unit Testing Strategy

This skill provides patterns for writing robust, maintainable unit tests. Unlike E2E testing (`webapp-testing`), unit tests focus on isolated logic.

---

## Core Principles

### 1. The Trinity of TDD

1.  **Red**: Write a failing test for the smallest possible unit of work.
2.  **Green**: Write just enough code to make it pass.
3.  **Refactor**: Clean up the code while keeping the test passing.

### 2. AAA Pattern

Structure every test using **Arrange, Act, Assert**:

```python
def test_calculator_add():
    # Arrange
    calc = Calculator()

    # Act
    result = calc.add(2, 2)

    # Assert
    assert result == 4
```

### 3. Isolation & Test Doubles

Unit tests must be fast and deterministic. Replace external dependencies using the appropriate test double:

| Double    | Purpose                       | Use When                                  |
| --------- | ----------------------------- | ----------------------------------------- |
| **Dummy** | Placeholder that's never used | Satisfying a required parameter           |
| **Stub**  | Returns canned data           | Simulating specific responses             |
| **Spy**   | Records interactions          | Verifying calls without changing behavior |
| **Mock**  | Verifies expectations         | Asserting specific interactions occurred  |
| **Fake**  | Working implementation        | In-memory DB, local file system           |

---

## Anti-Patterns to Avoid

### ❌ Testing Implementation Details

```python
# BAD: Tests internal state
def test_bad():
    cart = ShoppingCart()
    cart.add_item("apple")
    assert cart._items == ["apple"]  # Private attribute!

# GOOD: Tests public behavior
def test_good():
    cart = ShoppingCart()
    cart.add_item("apple")
    assert cart.get_total_items() == 1
```

### ❌ Over-Mocking

When everything is mocked, you're testing your mocks, not your code. Mock at boundaries (APIs, DBs), not internal modules.

### ❌ Flaky Tests

Tests that sometimes pass and sometimes fail destroy trust. Common causes:

- Time-dependent logic (use `freezegun` or mock `Date`)
- Race conditions (avoid `sleep`, use proper async handling)
- Shared state between tests (use fixtures for isolation)

### ❌ Test Interdependence

Each test must be able to run in isolation. Never rely on test execution order.

### ❌ Assertion Roulette

```python
# BAD: Which assertion failed?
def test_user():
    user = create_user()
    assert user.name == "Alice"
    assert user.email == "alice@example.com"
    assert user.is_active
    assert user.role == "admin"

# GOOD: One logical assertion per test, or use descriptive messages
def test_user_has_correct_name():
    user = create_user()
    assert user.name == "Alice"
```

---

## Python (pytest) Patterns

**Naming**: `test_*.py` or `*_test.py`. Functions start with `test_`.

### Basic Test

```python
import pytest
from my_module import process_data

def test_process_data_returns_clean_dict():
    input_data = "  key:value  "
    result = process_data(input_data)
    assert result == {"key": "value"}
```

### Fixtures (conftest.py)

```python
# conftest.py - shared fixtures across tests
import pytest

@pytest.fixture
def sample_user():
    """Fixture providing a test user."""
    return {"id": 1, "name": "Test User", "email": "test@example.com"}

@pytest.fixture
def db_session():
    """Fixture with setup and teardown."""
    session = create_test_session()
    yield session
    session.rollback()
    session.close()
```

### Parametrized Tests

```python
import pytest

@pytest.mark.parametrize("input,expected", [
    ("hello", "HELLO"),
    ("world", "WORLD"),
    ("PyTest", "PYTEST"),
    ("", ""),
])
def test_uppercase(input, expected):
    assert input.upper() == expected
```

### Mocking (pytest-mock)

```python
def test_api_call_is_mocked(mocker):
    # Arrange
    mock_get = mocker.patch("requests.get")
    mock_get.return_value.status_code = 200
    mock_get.return_value.json.return_value = {"data": "test"}

    # Act
    result = fetch_data()

    # Assert
    mock_get.assert_called_once_with("https://api.example.com")
    assert result == {"data": "test"}
```

### Time Mocking (freezegun)

```python
from freezegun import freeze_time

@freeze_time("2024-01-15 12:00:00")
def test_time_sensitive_function():
    result = get_current_timestamp()
    assert result == "2024-01-15T12:00:00"
```

---

## TypeScript (Jest/Vitest) Patterns

**Naming**: `*.test.ts` or `*.spec.ts`.

### Basic Test

```typescript
import { add } from "./math";

describe("Calculator", () => {
  it("should add two numbers", () => {
    expect(add(1, 2)).toBe(3);
  });
});
```

### Fixtures (beforeEach/afterEach)

```typescript
describe("UserService", () => {
  let service: UserService;
  let mockDb: jest.Mocked<Database>;

  beforeEach(() => {
    mockDb = createMockDatabase();
    service = new UserService(mockDb);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("should create a user", async () => {
    mockDb.insert.mockResolvedValue({ id: 1, name: "Test" });
    const user = await service.createUser("Test");
    expect(user.id).toBe(1);
  });
});
```

### Parametrized Tests (it.each)

```typescript
describe("Validator", () => {
  it.each([
    ["test@example.com", true],
    ["invalid-email", false],
    ["", false],
    ["user@domain.org", true],
  ])("validates email '%s' as %s", (email, expected) => {
    expect(isValidEmail(email)).toBe(expected);
  });
});
```

### Mocking

```typescript
import { sendEmail } from "./email-service";
import { execute } from "./controller";

jest.mock("./email-service");
const mockSendEmail = sendEmail as jest.MockedFunction<typeof sendEmail>;

test("executes logic and sends email", async () => {
  mockSendEmail.mockResolvedValue({ success: true });

  await execute();

  expect(mockSendEmail).toHaveBeenCalledTimes(1);
  expect(mockSendEmail).toHaveBeenCalledWith(
    expect.objectContaining({
      to: expect.any(String),
    }),
  );
});
```

### Snapshot Testing

```typescript
describe("Component", () => {
  it("renders correctly", () => {
    const output = renderComponent({ title: "Hello" });
    expect(output).toMatchSnapshot();
  });
});
```

> **Warning**: Snapshot tests can become maintenance burdens. Use sparingly for stable, well-defined outputs.

---

## Test Organization

### File Colocation vs Centralized

| Strategy        | Structure                                    | Best For                                   |
| --------------- | -------------------------------------------- | ------------------------------------------ |
| **Colocated**   | `src/user/user.ts` + `src/user/user.test.ts` | Feature-focused teams, component libraries |
| **Centralized** | `src/user/` + `tests/user/`                  | Large codebases, separation of concerns    |

### Recommended Structure (Colocated)

```
src/
├── user/
│   ├── user.service.ts
│   ├── user.service.test.ts
│   ├── user.repository.ts
│   └── user.repository.test.ts
├── order/
│   ├── order.service.ts
│   └── order.service.test.ts
└── __fixtures__/          # Shared test data
    └── users.ts
```

---

## Coverage Guidance

### When to Aim for High Coverage (80%+)

- Business-critical logic (payments, auth, calculations)
- Public APIs and library code
- Complex algorithms

### When Coverage Matters Less

- Simple getters/setters
- Framework boilerplate
- One-off scripts

### Beyond Line Coverage

- **Branch coverage**: Are all `if/else` paths tested?
- **Mutation testing**: Would changing code break tests? (Use `mutmut` for Python, `Stryker` for JS/TS)

```bash
# Python coverage
pytest --cov=src --cov-report=html

# Jest coverage
jest --coverage --coverageThreshold='{"global":{"lines":80}}'
```

---

## Quick Reference

| Task            | Python (pytest)          | TypeScript (Jest)      |
| --------------- | ------------------------ | ---------------------- |
| Run tests       | `pytest`                 | `jest` or `npm test`   |
| Run single file | `pytest path/to/test.py` | `jest path/to/test.ts` |
| Run by name     | `pytest -k "test_name"`  | `jest -t "test name"`  |
| Watch mode      | `pytest-watch`           | `jest --watch`         |
| Coverage        | `pytest --cov`           | `jest --coverage`      |
| Verbose         | `pytest -v`              | `jest --verbose`       |
