resource "aws_amplify_app" "main" {
  name       = local.name
  repository = "https://github.com/rafalkrol-xyz/pulumi-rafalkrol-xyz-draft" # TODO: change to https://github.com/rafalkrol-xyz/rafalkrol.xyz

  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - cd app
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: /app/dist
        files:
          - '**/*'
      cache:
        paths:
          - app/node_modules/**/*
  EOT

  custom_rule {
    source = "https://rafalkrol.xyz"
    status = "302"
    target = "https://www.rafalkrol.xyz"
  }

  environment_variables = {
    "_CUSTOM_IMAGE" = "amplify:al2"
  }
}
