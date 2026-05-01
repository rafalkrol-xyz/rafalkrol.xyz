# rafalkrol.xyz — Infrastructure

OpenTofu (Terraform-compatible) code that provisions the AWS infrastructure for [rafalkrol.xyz](https://rafalkrol.xyz).

## What's in here

| File | Purpose |
|---|---|
| `main.tf` | AWS Amplify app — builds and hosts the Astro site from GitHub |
| `route53.tf` | Public hosted zone, A/MX/TXT/CNAME records (mail, ACM validation, apex redirect) |
| `shared.tf` | Common locals: tags, project name, environment-aware domain name |
| `variables.tf` | Input variables (`env`, `aws_region`) |
| `terraform.tf` | Provider and backend configuration |
| `env/dev/` | Dev-environment backend config and variable values |
| `env/prod/` | Prod-environment backend config and variable values |

## Architecture

```
GitHub repo
    │
    ▼
AWS Amplify (build + host)
    │
    ▼
CloudFront distribution (managed by Amplify)
    │
    ▼
Route 53 public hosted zone
  ├── A record  → CloudFront (apex domain)
  ├── MX records → iCloud Mail
  ├── TXT records → Apple domain verification + SPF
  └── CNAME records → ACM certificate validation
```

State is stored in S3 with native locking (`use_lockfile = true`), in separate buckets per environment.

## Prerequisites

- [OpenTofu](https://opentofu.org/docs/intro/install/) >= 1.10
- AWS credentials configured for the target account
- [pre-commit](https://pre-commit.com/) (optional, for local linting)

## Usage

All commands are run from the `infra/` directory.

### Init

```bash
# dev
tofu init -backend-config=env/dev/s3.tfbackend

# prod
tofu init -backend-config=env/prod/s3.tfbackend
```

### Plan

```bash
# dev
tofu plan -var-file=env/dev/variables.tfvars

# prod
tofu plan -var-file=env/prod/variables.tfvars
```

### Apply

```bash
# dev
tofu apply -var-file=env/dev/variables.tfvars

# prod
tofu apply -var-file=env/prod/variables.tfvars
```

## Environments

| Environment | Domain | State bucket |
|---|---|---|
| `dev` | `dev.rafalkrol.xyz` | `armatys-dev-tfstates` |
| `prod` | `rafalkrol.xyz` | `armatys-root-tfstates` |

Both environments use the same state key: `apps/rafalkrol.xyz/terraform.tfstate`.

## Pre-commit hooks

The repo uses [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform) to enforce formatting and run security scans before every commit.

```bash
# install hooks (once)
pre-commit install

# run manually against all files
pre-commit run --all-files
```

Hooks configured:
- `terraform_fmt` — canonical formatting
- `terraform_trivy` — static security analysis
- Standard checks: trailing whitespace, YAML syntax, large files, merge conflicts, private keys, AWS credentials
