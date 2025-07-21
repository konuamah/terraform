
# =============================================================================
# EC2 MODULE - modules/ec2/outputs.tf
# =============================================================================

output "public_instance_id" {
  description = "ID of the public EC2 instance"
  value       = aws_instance.public_instance.id
}

output "public_instance_ip" {
  description = "Public IP of the public EC2 instance"
  value       = aws_instance.public_instance.public_ip
}

output "private_instance_id" {
  description = "ID of the private EC2 instance"
  value       = aws_instance.private_instance.id
}

output "private_instance_ip" {
  description = "Private IP of the private EC2 instance"
  value       = aws_instance.private_instance.private_ip
}
