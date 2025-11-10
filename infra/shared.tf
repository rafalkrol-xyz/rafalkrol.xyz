locals {
  tags = {
    Environment   = var.env
    GitHubRepoUrl = "https://github.com/rafalkrol-xyz/rafalkrol.xyz"
    Project       = "rafalkrol.xyz"
  }
  rafalkrol_xyz_phz = "${var.env == "prod" ? "" : "dev."}rafalkrol.xyz"
}
