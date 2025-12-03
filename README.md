# Terraform Lab Repository

This repository contains the work developed for my Terraform Lab as part my education in IaC.  
It includes all configurations, exercises, and practical implementations related to Infrastructure as Code (IaC) using Terraform.  
The main focus of this lab is the deployment of a highly available web service, applying cloud architecture principles and best practices in Terraform.

# Terraform Assignment 2025 - Highly Available Web App + EKS-Ready Networking

## Scenario
Deployed a highly available website for a startup across 2 AZs with web servers behind an ALB in public subnets. Private subnets with NAT Gateway are ready for future EKS worker nodes.

## Architecture Overview
VPC: 10.0.0.0/16 (eu-west-1) ├── Public Subnets (IGW → 0.0.0.0/0) │   ├── 10.0.1.0/24 (eu-west-1a) → Web Server 1 + ALB │   └── 10.0.2.0/24 (eu-west-1b) → Web Server 2 + ALB └── Private Subnets (NAT → 0.0.0.0/0) - EKS Ready ├── 10.0.10.0/24 (eu-west-1a) └── 10.0.20.0/24 (eu-west-1b)


## Key Decisions & Best Practices Applied

### 1. Networking 
- **VPC CIDR**: `10.0.0.0/16` as required
- **Public route table**: Fixed weak pseudocode example (`0.0.0.0/0` → IGW, not `/24`)
- **Private route table**: NAT Gateway for EKS outbound internet access
- **HA across AZs**: Resources span eu-west-1a/b

### 2. Security Groups 
ALB SG: HTTP(80) ← 0.0.0.0/0 → HTTP(80) → Web SG Web SG: HTTP(80) ← ALB SG → All outbound (yum/ECR updates)

### 3. Web Tier 
- 2 EC2 (t3.micro) in public subnets, 1 per AZ
- Amazon Linux 2 AMI with nginx via `amazon-linux-extras`
- Custom index.html with student name + instance metadata

### Steps
- terraform init 
- terraform plan
- terraform apply

EKS pods can reach frontend via ALB DNS with NAT outbound.

## Continuous Improvement (Git History)
- PR1: Basic VPC + public subnets
- PR2: Web servers + nginx user_data
- PR3: ALB + security groups + target groups
- PR4: NAT Gateway + private route table (EKS ready)
- PR5: .gitignore + code cleanup

## Key Learnings
- Route table `0.0.0.0/0` vs weak `/24` example [file:13]
- Amazon Linux Extras for nginx (`amazon-linux-extras install nginx1`)
- Least-privilege SGs (ALB→Web, not world)
- NAT Gateway pattern for private EKS nodes 


