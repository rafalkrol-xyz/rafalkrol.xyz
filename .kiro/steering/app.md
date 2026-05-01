---
inclusion: fileMatch
fileMatchPattern: "app/**"
---

# App — Astro static site

Located in `app/`. All commands must be run from `app/`, not the repo root.

## Stack

- Astro v2 static site (portfolio / landing page)
- TypeScript strict mode via `"extends": "astro/tsconfigs/strict"`
- No test suite, no linter/formatter config, no CI workflow

## Commands

| Task | Command |
|---|---|
| Dev server | `bun dev` (locally) or `npm run dev` |
| Build | `bun run build` or `npm run build` |

Output goes to `app/dist/`.

## Package manager

Both `bun.lock` and `package-lock.json` exist. Use `bun` locally. The AWS Amplify build uses `npm ci`.

## Project layout

- `app/src/content/` — content collections (Markdown)
- `app/src/pages/` — file-based routes
- `app/src/components/` — Astro components
- `app/src/layouts/` — page layouts
- `app/src/styles/` — global CSS
- `app/public/` — static assets served as-is
