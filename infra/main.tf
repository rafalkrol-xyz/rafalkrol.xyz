# NB, to avoid generating a GitLab Personal Access Token (PAT),
# this Amplify app was created through the AWS Console, and then imported:
# import {
#   to =  aws_amplify_app.main
#   id = "d3bb6k6j340kgg" # prod
# }

resource "aws_amplify_app" "main" {
  name       = local.name
  repository = "https://github.com/rafalkrol-xyz/rafalkrol.xyz"

  build_spec = <<-EOT
version: 1
applications:
  - frontend:
      phases:
        preBuild:
          commands:
            - npm ci --cache .npm --prefer-offline
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: dist
        files:
          - '**/*'
      cache:
        paths:
          - .npm/**/*
    appRoot: app
  EOT

  custom_rule {
    source = "https://rafalkrol.xyz"
    status = "301"
    target = "https://www.rafalkrol.xyz"
  }

  # FIXME: due to a known bug in the provider (https://github.com/hashicorp/terraform-provider-aws/issues/34318),
  # custom_headers will show a diff on every plan/apply.
  # Once the issue is fixed, remove the `// keep` comment and the `lifecycle` block.
  lifecycle {
    ignore_changes = [custom_headers]
  }
  custom_headers = <<-EOT
    customHeaders:
      - pattern: '**/*'
        headers:
          - key: 'Strict-Transport-Security'
            value: 'max-age=63072000; includeSubDomains; preload'
          - key: 'X-Content-Type-Options'
            value: 'nosniff'
          - key: 'X-Frame-Options'
            value: 'DENY'
          - key: 'Referrer-Policy'
            value: 'strict-origin-when-cross-origin'
          - key: 'Permissions-Policy'
            value: 'camera=(), microphone=(), geolocation=()'
          - key: 'Content-Security-Policy'
            value: "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' https://images.credly.com data:; connect-src 'self'; frame-ancestors 'none';"
  EOT

  environment_variables = {
    "AMPLIFY_DIFF_DEPLOY"       = "false"
    "AMPLIFY_MONOREPO_APP_ROOT" = "app"
  }
}
