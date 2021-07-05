resource "aws_route53_record" "mwaa" {

  zone_id = var.aws_route53_id
  name    = var.custom_domain
  type    = "CNAME"
  ttl     = "60"

  records = [aws_mwaa_environment.mwaa.webserver_url]
}