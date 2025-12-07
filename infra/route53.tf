# TODO: move public hosted zone and amplify hosting to a production workload account // currently in the organization management account

### PUBLIC HOSTED ZONE - START
resource "aws_route53_zone" "rafalkrol_xyz" {
  name = local.rafalkrol_xyz_phz

  lifecycle {
    prevent_destroy = true
  }
}
### PUBLIC HOSTED ZONE - END

### DNS RECORDS - START
# A Record - Apex domain to CloudFront distribution
resource "aws_route53_record" "apex" {
  zone_id = aws_route53_zone.rafalkrol_xyz.zone_id
  name    = local.rafalkrol_xyz_phz
  type    = "A"

  alias {
    name                   = "dmxdeoyuzd0lj.cloudfront.net" # TODO: import the amplify resource
    zone_id                = "Z2FDTNDATAQYW2" # CloudFront hosted zone ID originating from an Amplify app # TODO: import the amplify resource
    evaluate_target_health = false
  }
}
