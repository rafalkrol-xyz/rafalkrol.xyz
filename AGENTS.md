# AGENTS.md

## Repo layout

Two independent top-level directories — there is no root package.json or workspace config.

- `app/` — Astro v2 static site (portfolio / landing page)
- `infra/` — OpenTofu (Terraform-compatible) IaC for AWS

## App (`app/`)

- **All commands run from `app/`, not the repo root.**
- Both `bun.lock` and `package-lock.json` exist. Use bun locally; the Amplify build uses `npm ci`.
- Dev: `bun dev` (or `npm run dev`) — starts Astro dev server
- Build: `bun run build` (or `npm run build`) — outputs to `app/dist/`
- TypeScript strict mode via `"extends": "astro/tsconfigs/strict"`.
- No test suite, no linter/formatter config, no CI workflow for the app.
- Content lives in `app/src/content/`; pages in `app/src/pages/`.

## Infra (`infra/`)

- **Uses OpenTofu (`tofu`), not `terraform`.** Requires >= 1.10.
- AWS provider ~> 6.0, region `eu-west-1`.
- S3 backend — every command needs env-specific flags:
  ```
  tofu init -backend-config=env/dev/s3.tfbackend
  tofu plan -var-file=env/dev/variables.tfvars
  tofu apply -var-file=env/dev/variables.tfvars
  ```
  Replace `dev` with `prod` for production.
- **Pre-commit hooks** are configured in `infra/.pre-commit-config.yaml` (not repo root). Install with `pre-commit install` from `infra/`. Runs `terraform_fmt`, `terraform_trivy`, and standard file checks.
- Two environments: `dev` → `dev.rafalkrol.xyz`, `prod` → `rafalkrol.xyz`.
- Deploys via AWS Amplify (builds from GitHub), fronted by CloudFront, DNS in Route 53.
