output "route53_nameservers" {
  value = aws_route53_zone.labs.name_servers
}

output "certificate_arn" {
    value = aws_acm_certificate_validation.cert.certificate_arn
}
    