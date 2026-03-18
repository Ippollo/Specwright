---
name: vue-svelte-patterns
description: Master Vue and Svelte component patterns including composables, provide/inject, slots, runes, and reusable component architecture. Use when building UI component libraries or design systems with Vue or Svelte. For React patterns, see react-best-practices.
metadata:
  pattern: tool-wrapper
---

# Vue & Svelte Component Patterns

Build reusable, maintainable UI components using Vue and Svelte with clean composition patterns and styling approaches.

> **Note**: For React component patterns and performance optimization, use [`react-best-practices`](../react-best-practices/SKILL.md).

## When to Use This Skill

- Building Vue or Svelte component libraries
- Implementing slots, provide/inject, or composables (Vue)
- Using Svelte 5 runes and snippets
- Designing reusable component APIs for Vue/Svelte
- Refactoring legacy Vue Options API to Composition API

## Core Concepts

### 1. Component Composition Patterns

**Slots (Named Content Injection)**

Vue and Svelte use slots for flexible content composition:

```vue
<template>
  <Card>
    <template #header>Title</template>
    <template #content>Body text</template>
    <template #footer><Button>Action</Button></template>
  </Card>
</template>
```

```svelte
<!-- Svelte named slots -->
<Card>
  <h2 slot="header">Title</h2>
  <p slot="content">Body text</p>
  <Button slot="footer">Action</Button>
</Card>
```

**Provide/Inject (Vue) - Dependency Injection**

Share data across component trees without prop drilling:

```vue
<script setup lang="ts">
import { provide, inject, ref, type InjectionKey, type Ref } from "vue";

// Define typed key
interface ThemeContext {
  theme: Ref<"light" | "dark">;
  toggle: () => void;
}

const ThemeKey: InjectionKey<ThemeContext> = Symbol("theme");

// Provider component
const theme = ref<"light" | "dark">("light");
provide(ThemeKey, {
  theme,
  toggle: () => {
    theme.value = theme.value === "light" ? "dark" : "light";
  },
});

// Consumer component (in child)
const { theme, toggle } = inject(ThemeKey)!;
</script>
```

**Context (Svelte) - Using Stores**

```svelte
<!-- Parent.svelte -->
<script lang="ts">
  import { setContext } from 'svelte';
  import { writable } from 'svelte/stores';

  const theme = writable<'light' | 'dark'>('light');
  setContext('theme', theme);
</script>

<!-- Child.svelte -->
<script lang="ts">
  import { getContext } from 'svelte';
  import type { Writable } from 'svelte/store';

  const theme = getContext<Writable<'light' | 'dark'>>('theme');
</script>
```

### 2. CSS & Styling Approaches

| Solution            | Approach             | Best For                          |
| ------------------- | -------------------- | --------------------------------- |
| **Tailwind CSS**    | Utility classes      | Rapid prototyping, design systems |
| **CSS Modules**     | Scoped CSS files     | Existing CSS, gradual adoption    |
| **Scoped Styles**   | Vue `<style scoped>` | Vue single-file components        |
| **Svelte Styles**   | Built-in scoping     | Svelte components (automatic)     |
| **Vanilla Extract** | Zero-runtime         | Performance-critical apps         |
| **UnoCSS**          | Atomic CSS engine    | Vue/Svelte with Vite              |

---

## Vue 3 Patterns

### Composables (Reusable Logic)

Extract and share stateful logic across components:

```typescript
// composables/useFetch.ts
import { ref, watchEffect, type Ref } from "vue";

export function useFetch<T>(url: Ref<string>) {
  const data = ref<T | null>(null);
  const error = ref<Error | null>(null);
  const loading = ref(true);

  watchEffect(async () => {
    loading.value = true;
    try {
      const res = await fetch(url.value);
      data.value = await res.json();
    } catch (e) {
      error.value = e as Error;
    } finally {
      loading.value = false;
    }
  });

  return { data, error, loading };
}
```

```vue
<script setup lang="ts">
import { ref } from "vue";
import { useFetch } from "@/composables/useFetch";

const url = ref("/api/users");
const { data, loading, error } = useFetch<User[]>(url);
</script>
```

### Compound Components with Provide/Inject

```vue
<!-- Tabs.vue -->
<script setup lang="ts">
import { provide, ref, type InjectionKey, type Ref } from "vue";

interface TabsContext {
  activeTab: Ref<string>;
  setActive: (id: string) => void;
}

export const TabsKey: InjectionKey<TabsContext> = Symbol("tabs");

const activeTab = ref("");
provide(TabsKey, {
  activeTab,
  setActive: (id: string) => {
    activeTab.value = id;
  },
});
</script>

<template>
  <div class="tabs">
    <slot />
  </div>
</template>
```

```vue
<!-- Tab.vue -->
<script setup lang="ts">
import { inject, computed } from "vue";
import { TabsKey } from "./Tabs.vue";

const props = defineProps<{ id: string; label: string }>();
const tabs = inject(TabsKey)!;
const isActive = computed(() => tabs.activeTab.value === props.id);
</script>

<template>
  <button @click="tabs.setActive(id)" :class="{ active: isActive }">
    {{ label }}
  </button>
</template>
```

### v-model with Composables

```vue
<script setup lang="ts">
const model = defineModel<string>();
</script>

<template>
  <input v-model="model" />
</template>
```

---

## Svelte 5 Patterns

### Runes ($props, $state, $derived)

```svelte
<script lang="ts">
  interface Props {
    variant?: 'primary' | 'secondary';
    size?: 'sm' | 'md' | 'lg';
    onclick?: () => void;
    children: import('svelte').Snippet;
  }

  let { variant = 'primary', size = 'md', onclick, children }: Props = $props();

  // Derived state
  const classes = $derived(`btn btn-${variant} btn-${size}`);
</script>

<button class={classes} {onclick}>
  {@render children()}
</button>
```

### Snippets (Reusable Template Fragments)

```svelte
<script lang="ts">
  import type { Snippet } from 'svelte';

  interface Props {
    header?: Snippet;
    footer?: Snippet<[{ close: () => void }]>;
    children: Snippet;
  }

  let { header, footer, children }: Props = $props();

  function close() {
    // close modal
  }
</script>

<div class="modal">
  {#if header}
    <header>{@render header()}</header>
  {/if}

  <main>{@render children()}</main>

  {#if footer}
    <footer>{@render footer({ close })}</footer>
  {/if}
</div>
```

### $effect for Side Effects

```svelte
<script lang="ts">
  let count = $state(0);

  $effect(() => {
    // Runs when count changes
    console.log(`Count is now ${count}`);

    // Cleanup function (like useEffect return)
    return () => {
      console.log('Cleaning up...');
    };
  });
</script>
```

### Stores (Shared State)

```typescript
// stores/counter.ts
import { writable, derived } from "svelte/store";

export const count = writable(0);

export const doubled = derived(count, ($count) => $count * 2);

// Actions
export function increment() {
  count.update((n) => n + 1);
}

export function reset() {
  count.set(0);
}
```

---

## Component API Design Principles

**TypeScript Props Interface**:

```typescript
// Vue
interface ButtonProps {
  variant?: "primary" | "secondary" | "ghost";
  size?: "sm" | "md" | "lg";
  loading?: boolean;
  disabled?: boolean;
}

// Svelte
interface Props {
  variant?: "primary" | "secondary" | "ghost";
  size?: "sm" | "md" | "lg";
  loading?: boolean;
  disabled?: boolean;
  children: Snippet;
  onclick?: () => void;
}
```

**Principles**:

- Use semantic prop names (`loading` vs `isLoading`)
- Provide sensible defaults
- Support composition via slots/snippets
- Allow style overrides via `class` prop

---

## Best Practices

1. **Single Responsibility**: Each component does one thing well
2. **Prop Drilling Prevention**: Use provide/inject (Vue) or context (Svelte)
3. **Accessible by Default**: Include ARIA attributes, keyboard support
4. **Controlled vs Uncontrolled**: Support both patterns when appropriate
5. **Scoped Styles**: Use Vue's `<style scoped>` or Svelte's automatic scoping

## Common Issues

- **Prop Explosion**: Too many props - consider composition instead
- **Style Conflicts**: Use scoped styles (automatic in Vue/Svelte)
- **Reactivity Pitfalls**: Understand Vue's reactivity caveats, Svelte's runes
- **Accessibility Gaps**: Test with screen readers and keyboard navigation
- **Bundle Size**: Use tree-shaking, lazy load heavy components

## Resources

- [Vue Composition API Guide](https://vuejs.org/guide/reusability/composables.html)
- [Svelte 5 Runes Documentation](https://svelte.dev/docs/svelte/$state)
- [VueUse - Collection of Vue Composables](https://vueuse.org/)
- [Svelte Component Documentation](https://svelte.dev/docs/svelte-components)
