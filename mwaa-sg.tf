resource "aws_security_group" "mwaa_sg" {
  name   = "mwaa-${var.environment_name}"
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "mwaa_sg_inbound" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "all"
  source_security_group_id = aws_security_group.mwaa_sg.id
  security_group_id        = aws_security_group.mwaa_sg.id
  description              = "Amazon MWAA inbound access"
}

resource "aws_security_group_rule" "mwaa_sg_inbound_vpn" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = tolist(var.vpn_cidr)
  security_group_id = aws_security_group.mwaa_sg.id
  description       = "VPN Access for Airflow UI"
}

resource "aws_security_group_rule" "mwaa_sg_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mwaa_sg.id
  description       = "Amazon MWAA outbound access"
}