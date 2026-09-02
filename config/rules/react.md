---
paths:
  - "**/*.tsx"
  - "**/*.jsx"
---

# React / frontend

Reference implementation: `~/projects/booklibre/frontend`. React 19 + TS + Vite + Vitest.

## No `useEffect` for logic

- First data load: `useOnInit(() => recargar())` from `utils/hooks.ts` (`useEffect(cb, [])` wrapped). This is the ONLY sanctioned effect-without-deps. Then hold data in `useState`.
- Reload on a real dependency change: a `useEffect([deps])` guarded by a `useRef(isInitial)` so it does not fire on mount.
- No effect for derived values (compute in render), for responses to events (use the handler), or for state a parent owns.

## Data loading lives in a custom hook

- One hook per screen/resource (`useDetalleLibro`, `useHomeCatalog`). It owns: `useState` for data / `loading` / `error`; a `useCallback` `recargar` that does the fetch; the `useOnInit` first call; the guarded reload effect. Returns `{ data, setData, loading, error, recargar }`.
- `catch` → `setError(obtenerMensajeError(err))` (`utils/errorHandler.ts`), never a raw string. That helper narrows `AxiosError` and maps HTTP status → user message, preferring the backend message.

## Frontend domain objects

- `classes/` holds domain classes (`Libro`, `Auth`, `LibroForm`): typed fields, `constructor(data: Partial<T>)` with explicit defaults, `static fromJson` / `fromXxxJson` factories, domain methods (`estaDevuelto`, `calcularBibliokarma`), private helpers. Derived/business logic and its error control live here, not in components.
- `services/` are axios clients that return domain-class instances, not raw DTOs. `models/` holds DTO types + filter state + constants.

## Components

- Presentational, grouped by feature (`components/home/`, `detalleLibros/`, `ui/`). Pages compose hooks + components; components take props. Context via a `useXContext()` wrapper.
- One responsibility per component; split when a component both fetches and renders a tree.
- Accessible markup by default: labels, roles, keyboard paths.

## Tests — Vitest + React Testing Library + jsdom

- `test/*.test.ts` — domain class: build DTO fixtures, run the factory, assert fields + method results.
- `test/*.test.tsx` — component: `vi.mock` the service module, render inside the real `AuthContext.Provider` + `MemoryRouter`/`Routes`, `waitFor`, assert spinner → data.
- `pnpm lint` passes with `--max-warnings 0`; `pnpm test` green. New component/hook ships with a test.

For scalable structure use `react-scalable-frontend`; for component review `react-component-validator`.
