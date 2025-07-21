

## Cloud Infrastructure as Code with Terraform

### Project Overview

This project demonstrates how to design, provision, and automate a **multi-tier AWS infrastructure** using **Terraform** and **GitHub Actions**. It follows Infrastructure as Code (IaC) best practices, using a modular architecture and CI/CD automation for safe and repeatable deployments.

---

### Tech Stack

* Terraform (v1.6.0)
* AWS (VPC, EC2, NAT Gateway, Subnets, Route Tables, Security Groups)
* GitHub Actions (CI/CD)
* Amazon Linux 2
* Modular Terraform Codebase

---

### Architecture Diagram

```
                      Internet
                          |
                   [Internet Gateway]
                          |
               --------------------------
               |                        |
         [Public Subnet]         [Private Subnet]
               |                        |
         Public EC2 (Bastion)     Private EC2 (Web Server)
               |                        ^
               --------------------------
                          |
                      NAT Gateway
```

---

### Features

* Isolated VPC with public and private subnets
* NAT Gateway for secure internet access from private subnet
* Public EC2 instance (bastion host)
* Private EC2 instance with Nginx web server
* SSH access only through public instance
* Modular Terraform structure
* Automated CI/CD pipeline using GitHub Actions
* AWS credentials securely managed using GitHub Secrets

---

### Project Structure

```
terraform-project/
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── vpc/
│   ├── ec2/
│   └── networking/
├── .github/workflows/terraform.yml
└── README.md
```

---

### CI/CD Workflow (GitHub Actions)

Runs automatically on push to the `main` branch:

* `terraform fmt` — checks formatting
* `terraform validate` — syntax validation
* `terraform plan` — shows changes without applying

**Note**: `terraform apply` is disabled in CI for safety and manual review.

Secrets used:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

---

### Security

* Private EC2 instance has no public IP
* SSH access is only allowed via the bastion host
* Security groups strictly control access on required ports
* CI/CD avoids automatic apply in production environments

---

### How to Deploy

1. Clone the repo and navigate into it
2. Set up your AWS credentials
3. Run the following Terraform commands:

```bash
terraform init
terraform plan
terraform apply
```

4. Access the public EC2 instance via SSH and test connectivity to the private EC2.


