# rafalkrol.xyz — App

Astro static site for [rafalkrol.xyz](https://rafalkrol.xyz). Portfolio and landing page.

## Stack

- [Astro](https://astro.build) v6
- TypeScript (strict mode)
- Deployed via AWS Amplify → CloudFront (see `../infra/`)

## Commands

All commands run from `app/`, not the repo root.

| Command | Action |
|---|---|
| `bun dev` | Start dev server at `localhost:4321` |
| `bun run build` | Build to `dist/` |
| `bun run preview` | Preview the production build locally |

The Amplify build uses `npm ci` + `npm run build` — both lockfiles are committed.

## Project layout

```
app/
├── public/          # Static assets (images, favicon)
├── src/
│   ├── components/  # Astro components
│   ├── content/
│   │   └── work/    # Portfolio entries (Markdown)
│   ├── layouts/     # Page layouts
│   ├── pages/       # File-based routes
│   └── styles/      # Global CSS
└── dist/            # Build output (gitignored)
```

## Adding portfolio entries

Create a Markdown file in `src/content/work/`. The content schema is defined in `src/content/config.ts`.
