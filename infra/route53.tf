### PUBLIC HOSTED ZONE - START
resource "aws_route53_zone" "rafalkrol_xyz" {
  name = local.rafalkrol_xyz_phz

  lifecycle {
    prevent_destroy = true
  }
}
### PUBLIC HOSTED ZONE - END
