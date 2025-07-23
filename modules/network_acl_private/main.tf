resource "aws_network_acl" "private_nacl" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-private-nacl"
  }
}

# Associate NACL with private subnet
resource "aws_network_acl_association" "private_nacl_association" {
  subnet_id      = var.private_subnet_id
  network_acl_id = aws_network_acl.private_nacl.id
}

# Inbound SSH from private subnet
resource "aws_network_acl_rule" "inbound_ssh" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = 22
  to_port        = 22
}

# Inbound ICMP (Echo Reply)
resource "aws_network_acl_rule" "inbound_icmp" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "icmp"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = -1
  to_port        = -1
}

# Outbound ephemeral ports (1024-65535) to anywhere (for responses and outbound traffic)
resource "aws_network_acl_rule" "outbound_ephemeral" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Outbound ICMP allowed to anywhere
resource "aws_network_acl_rule" "outbound_icmp" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 110
  egress         = true
  protocol       = "icmp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = -1
  to_port        = -1
}

# Deny all other inbound traffic
resource "aws_network_acl_rule" "inbound_deny_all" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 200
  egress         = false
  protocol       = "-1"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# Deny all other outbound traffic
resource "aws_network_acl_rule" "outbound_deny_all" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}
