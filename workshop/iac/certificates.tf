data "aws_route53_zone" "ingress" {
  name         = var.ingress_hostzone_name
  private_zone = false
}


// create a wilddcart certificate
resource "aws_acm_certificate" "ingress" {
  domain_name       = var.ingress_hostzone_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  subject_alternative_names = [
    "*.${var.ingress_hostzone_name}"
  ]
}

resource "aws_acm_certificate_validation" "ingress" {
  certificate_arn         = aws_acm_certificate.ingress.arn
  validation_record_fqdns = [for record in aws_route53_record.ingress : record.fqdn]
}


resource "aws_route53_record" "ingress" {
  for_each = {
    for dvo in aws_acm_certificate.ingress.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.ingress.zone_id
}




