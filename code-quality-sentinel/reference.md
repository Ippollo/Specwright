# Code Smells & Refactoring Catalog

This catalog supports the `code-quality-sentinel` skill. It is organized into **Universal** smells (any language) and **Framework-Specific** smells.

## 1. Universal Smells (Any Language)

These apply to JavaScript, Rust, Python, Go, etc.

| Smell                     | Description                                          | Refactoring                              |
| ------------------------- | ---------------------------------------------------- | ---------------------------------------- |
| **Long Method**           | Function > 20-30 lines or multiple responsibilities. | `Extract Method`                         |
| **Duplicate Code**        | Same logic in multiple places.                       | `Extract Method` or `Pull Up Method`     |
| **Complex Conditional**   | Deep nesting, difficult reasoning.                   | `Guard Clauses`, `Decompose Conditional` |
| **Long Parameter List**   | > 3-4 arguments.                                     | `Introduce Parameter Object`             |
| **Magic Numbers/Strings** | Hardcoded values.                                    | `Replace with Constant`                  |
| **Dead Code**             | Unreachable or unused code.                          | `Delete`                                 |

---

## 2. React / TypeScript

Specific to the React ecosystem.

| Smell                 | Description                                             | Refactoring                                      |
| --------------------- | ------------------------------------------------------- | ------------------------------------------------ |
| **God Component**     | File > 300 lines, UI + Logic + Data mixed.              | `Extract Component`, `Extract Hook`              |
| **Prop Drilling**     | Passing props through > 3 layers.                       | `Context API`, `State Management`, `Composition` |
| **Effect Chaining**   | `useEffect` triggering state that triggers `useEffect`. | `Combine Effects`, `Event-Driven Logic`          |
| **Inline Definition** | Defining components _inside_ other components.          | `Move Component Out`                             |
| **Any Types**         | Using `any` bypasses TS safety.                         | `Define Interface`, `Generics`                   |

---

## 3. Rust (Coming Soon)

| Smell            | Description                                     | Refactoring                       |
| ---------------- | ----------------------------------------------- | --------------------------------- |
| **Unwrap Abuse** | Excessive `.unwrap()` in production code.       | `Match`, `Result Propagation (?)` |
| **Clone Tax**    | Excessive `.clone()` to satisfy borrow checker. | `References`, `Arc/Rc`, `Cow`     |

---

## 4. Flutter / Dart (Coming Soon)

| Smell           | Description                               | Refactoring                |
| --------------- | ----------------------------------------- | -------------------------- |
| **Widget Hell** | Deeply nested build methods.              | `Extract Widget`           |
| **Large Build** | `build()` method doing heavy computation. | `Move to State/Controller` |

---

## 5. Python (Coming Soon)

| Smell              | Description                       | Refactoring           |
| ------------------ | --------------------------------- | --------------------- |
| **Global State**   | Excessive module-level variables. | `Encapsulate Class`   |
| **Import Tangles** | Circular or massive imports.      | `Restructure Modules` |
