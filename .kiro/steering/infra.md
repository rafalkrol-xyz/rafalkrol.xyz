---
inclusion: fileMatch
fileMatchPattern: "infra/**"
---

# Infra — OpenTofu on AWS

Located in `infra/`. All commands must be run from `infra/`.

## Stack

- OpenTofu (`tofu`) >= 1.10 — **not** `terraform`
- AWS provider ~> 6.0, region `eu-west-1`
- S3 backend with native locking (`use_lockfile = true`)
- Two environments: `dev` → `dev.rafalkrol.xyz`, `prod` → `rafalkrol.xyz`

## Commands

Every command requires env-specific flags. Replace `dev` with `prod` for production.

```bash
tofu init   -backend-config=env/dev/s3.tfbackend
tofu plan   -var-file=env/dev/variables.tfvars
tofu apply  -var-file=env/dev/variables.tfvars
```

## Architecture

GitHub repo → AWS Amplify (build + host) → CloudFront → Route 53 public hosted zone

## File layout

| File | Purpose |
|---|---|
| `main.tf` | AWS Amplify app |
| `route53.tf` | Public hosted zone and all DNS records |
| `shared.tf` | Common locals (tags, name, domain) |
| `variables.tf` | Input variables (`env`, `aws_region`) |
| `terraform.tf` | Provider and S3 backend config |
| `env/dev/` | Dev backend config and tfvars |
| `env/prod/` | Prod backend config and tfvars |

## Pre-commit hooks

Config is at `infra/.pre-commit-config.yaml`. Install from `infra/`:

```bash
pre-commit install
pre-commit run --all-files  # run manually
```

Hooks: `terraform_fmt`, `terraform_trivy`, plus standard file checks (trailing whitespace, YAML, large files, merge conflicts, private keys, AWS credentials).

## Route 53 import ID format

OpenTofu record IDs use a single underscore as separator:

```
{zone_id}_{record_name}_{type}
```

Example: `ZNZ46LNSVQ4RA_sig1._domainkey.rafalkrol.xyz_CNAME`

The AWS console displays `__` (double underscore) — that format is **not** valid for import block IDs.
