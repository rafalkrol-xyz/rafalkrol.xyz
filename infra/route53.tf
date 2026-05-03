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
# A Record (Alias) - Apex domain to CloudFront distribution (managed by Amplify domain association)
resource "aws_route53_record" "apex" {
  count = var.env == "prod" ? 1 : 0

  zone_id = aws_route53_zone.rafalkrol_xyz.zone_id
  name    = local.rafalkrol_xyz_phz
  type    = "A"

  alias {
    # sub_domain.dns_record is in the format " CNAME <target>" — split and trim to get the CloudFront hostname
    name = trimspace(
      # 3. Splits the " CNAME DISTRO_ID.cloudfront.net" string into a list with two elements and takes the second one (index [1])
      split(
        "CNAME",
        # 1. Iterates over all sub_domain blocks in the domain association and returns only the dns_record of the one where prefix == "" (the apex, not www).
        # Result is a list with one element, e.g.:
        # [" CNAME DISTRO_ID.cloudfront.net"]
        [for s in aws_amplify_domain_association.rafalkrol_xyz[count.index].sub_domain : s.dns_record if s.prefix == ""]
        # 2. Grabs the first (and only) element from that list:
        [0]
      )[1]
    )
    # The CloudFront hosted zone ID is fixed for all CloudFront distributions:
    # https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-properties-route53-recordset-aliastarget.html
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

# CNAME - WWW subdomain to CloudFront distribution (managed by Amplify domain association)
resource "aws_route53_record" "www" {
  count = var.env == "prod" ? 1 : 0

  zone_id = aws_route53_zone.rafalkrol_xyz.zone_id
  name    = "www.${local.rafalkrol_xyz_phz}"
  type    = "CNAME"
  ttl     = 500
  # sub_domain.dns_record is in the format " CNAME <target>" — split and trim to get the CloudFront hostname
  records = [trimspace(split("CNAME", [for s in aws_amplify_domain_association.rafalkrol_xyz[count.index].sub_domain : s.dns_record if s.prefix == "www"][0])[1])]
}

# MX Records - iCloud Mail servers
resource "aws_route53_record" "mx" {
  zone_id = aws_route53_zone.rafalkrol_xyz.zone_id
  name    = local.rafalkrol_xyz_phz
  type    = "MX"
  ttl     = 3600
  records = [
    "10 mx01.mail.icloud.com.",
    "10 mx02.mail.icloud.com."
  ]
}

# TXT Records - Apple domain verification and SPF
resource "aws_route53_record" "txt" {
  zone_id = aws_route53_zone.rafalkrol_xyz.zone_id
  name    = local.rafalkrol_xyz_phz
  type    = "TXT"
  ttl     = 3600
  records = [
    "apple-domain=ZkaoYqsPCHjbSyWk",
    "v=spf1 include:icloud.com -all"
  ]
}

# CNAME - ACM Certificate Validation (Certificate 1)
resource "aws_route53_record" "acm_validation_1" {
  zone_id = aws_route53_zone.rafalkrol_xyz.zone_id
  name    = "_45114d7ecba40eb76da37d48c85ceca0.${local.rafalkrol_xyz_phz}"
  type    = "CNAME"
  ttl     = 500
  records = [
    "_41a8e82433615fb117bac8abfc1a0739.pwmqblccxr.acm-validations.aws."
  ]
}

# CNAME - ACM Certificate Validation (Certificate 2)
resource "aws_route53_record" "acm_validation_2" {
  zone_id = aws_route53_zone.rafalkrol_xyz.zone_id
  name    = "_e3609bc8a44b157f8baaa7aac727dcab.${local.rafalkrol_xyz_phz}"
  type    = "CNAME"
  ttl     = 300
  records = [
    "_a30794c7363fc3bac9747c0e23bb36e4.tljzshvwok.acm-validations.aws."
  ]
}

# CNAME - DKIM for iCloud Mail
resource "aws_route53_record" "dkim" {
  zone_id = aws_route53_zone.rafalkrol_xyz.zone_id
  name    = "sig1._domainkey.${local.rafalkrol_xyz_phz}"
  type    = "CNAME"
  ttl     = 3600
  records = [
    "sig1.dkim.rafalkrol.xyz.at.icloudmailadmin.com."
  ]
}
### DNS RECORDS - END
