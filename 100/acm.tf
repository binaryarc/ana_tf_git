# resource "aws_acm_certificate" "anaconda" {
#   domain_name       = "*.vvasco.site"
#   validation_method = "DNS"
  
#   validation_option {
#     domain_name       = "*.vvasco.site"
#     validation_domain = "vvasco.site"
#   }
# }

# resource "aws_route53_record" "anaconda" {
#   for_each = {
#     for dvo in aws_acm_certificate.anaconda.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = aws_route53_zone.anaconda.zone_id
# }

#버지니아 북부 인증서. cloudfront용
provider "aws" {
  alias = "virginia"
  region = "us-east-1"
    profile = "mfa"
}

resource "aws_acm_certificate" "anaconda2" {
provider = "aws.virginia"
  domain_name       = "*.vvasco.site"
  validation_method = "DNS"
  
  validation_option {
    domain_name       = "*.vvasco.site"
    validation_domain = "vvasco.site"
  }
}

resource "aws_route53_record" "anaconda2" {
  for_each = {
    for dvo in aws_acm_certificate.anaconda2.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.anaconda.zone_id
}