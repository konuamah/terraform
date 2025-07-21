# =============================================================================
# ROOT MODULE - outputs.tf
# =============================================================================


output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_instance_ip" {
  description = "Public IP of the public EC2 instance"
  value       = module.ec2.public_instance_ip
}

output "private_instance_ip" {
  description = "Private IP of the private EC2 instance"
  value       = module.ec2.private_instance_ip
}

output "nat_gateway_ip" {
  description = "Public IP of the NAT Gateway"
  value       = module.vpc.nat_gateway_ip
}