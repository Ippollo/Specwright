# Antigravity Agentic Toolkit

Comprehensive library of Skills, Agents, and Workflows for autonomous AI development.

## Structure

- **[Agents](./agents/)**: Specialized personas (e.g., `project-planner`, `frontend-specialist`) that embody expert roles.
- **[Workflows](./workflows/)**: Standard operating procedures (e.g., `/plan`, `/debug`) for common tasks.
- **[Skills](./skills/)**: Atomic capabilities (e.g., `api-design-patterns`, `react-best-practices`) used by Agents.

## Getting Started

1.  **Principles**: Set project guardrails.
    ```bash
    /constitution
    ```
2.  **Ideate**: Compare high-level options.
    ```bash
    /brainstorm "Authentication approach"
    ```
3.  **Investigate**: Deep-dive into existing code (if needed).
    ```bash
    /investigate "Current auth implementation"
    ```
4.  **New Change**: Initialize isolated change folder.
    ```bash
    /new feature-name
    ```
5.  **Plan**: Choose your pace.
    ```bash
    /ff  # Fast: Generate all planning docs at once
    # OR
    /specify -> /clarify -> /plan  # Meticulous: Step-by-step
    ```
6.  **Execute**: Implement from task list.
    ```bash
    # Work through changes/feature-name/tasks.md
    /design "Implementation details"
    ```
7.  **Verify & Archive**:
    ```bash
    /test "Functionality"
    /final-polish
    /archive feature-name
    ```

## Catalog

See [CATALOG.md](./CATALOG.md) for a full index of available capabilities.
