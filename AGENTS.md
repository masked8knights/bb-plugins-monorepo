# bb-plugins-monorepo — agent conventions

This is a pnpm workspace of bb plugins (`packages/bb-plugin-*`). Each package
is a standard bb plugin and is installable directly (`bb plugin install <dir>`).

## Rules

- Keep each plugin self-contained: its own `package.json` (bb metadata,
  `server.ts`/`app.tsx`/`host.ts` as needed) and no cross-package imports.
- Vendored packages are snapshots refreshed by automation. When updating a
  package, prefer syncing from its upstream source rather than hand-editing,
  and keep the vendored copy faithful (no local drift beyond the intended fix).
- Use the same conventions as the upstream plugin repos: TypeScript, the
  `@bb/plugin-sdk` / `@get-bb/plugin-sdk` types, `bb plugin build` to compile.
- Run `pnpm build` and `pnpm typecheck` after changes; add/adjust tests with
  the package's own test runner (vitest for `bb-plugin-usage`).