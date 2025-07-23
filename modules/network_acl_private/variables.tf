variable "vpc_id" {
  description = "VPC ID where the NACL will be created"
  type        = string
}

variable "private_subnet_id" {
  description = "Subnet ID to associate with the private NACL"
  type        = string
}

variable "project_name" {
  description = "Project name used in tags"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
