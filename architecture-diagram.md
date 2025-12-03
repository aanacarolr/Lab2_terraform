# Web Application Architecture Diagram

## High Availability Web Application (eu-west-1)

```
                                    Internet
                                       |
                                       |
                    ┌──────────────────┴──────────────────┐
                    |                                     |
                    |     Application Load Balancer      |
                    |   terraform-ha-webapp-alb          |
                    |   (Internet-facing)                |
                    └──────────────────┬──────────────────┘
                                       |
                    ┌──────────────────┴──────────────────┐
                    |                                     |
    ┌───────────────┴────────────┐       ┌───────────────┴────────────┐
    |                            |       |                            |
    |  Availability Zone 1a      |       |  Availability Zone 1b      |
    |                            |       |                            |
    |  ┌──────────────────────┐  |       |  ┌──────────────────────┐  |
    |  | Public Subnet        |  |       |  | Public Subnet        |  |
    |  | 10.0.1.0/24          |  |       |  | 10.0.2.0/24          |  |
    |  |                      |  |       |  |                      |  |
    |  |  ┌────────────────┐  |  |       |  |  ┌────────────────┐  |  |
    |  |  | EC2 Instance   |  |  |       |  |  | EC2 Instance   |  |  |
    |  |  | web-1          |  |  |       |  |  | web-2          |  |  |
    |  |  | t3.micro       |  |  |       |  |  | t3.micro       |  |  |
    |  |  | 10.0.1.212     |  |  |       |  |  | 10.0.2.173     |  |  |
    |  |  | 54.75.116.22   |  |  |       |  |  | 54.216.192.129 |  |  |
    |  |  | Status: ✓      |  |  |       |  |  | Status: ✓      |  |  |
    |  |  └────────────────┘  |  |       |  |  └────────────────┘  |  |
    |  └──────────────────────┘  |       |  └──────────────────────┘  |
    |                            |       |                            |
    |  ┌──────────────────────┐  |       |  ┌──────────────────────┐  |
    |  | Private Subnet       |  |       |  | Private Subnet       |  |
    |  | 10.0.10.0/24         |  |       |  | 10.0.20.0/24         |  |
    |  └──────────────────────┘  |       |  └──────────────────────┘  |
    |                            |       |                            |
    └────────────────────────────┘       └────────────────────────────┘
                    |                                     |
                    └──────────────────┬──────────────────┘
                                       |
                            ┌──────────┴──────────┐
                            |                     |
                            |  VPC                |
                            |  10.0.0.0/16        |
                            |  Internet Gateway   |
                            └─────────────────────┘
```

## Resource Details

### Network
- **VPC**: `terraform-ha-webapp-vpc` (10.0.0.0/16)
- **Internet Gateway**: `terraform-ha-webapp-igw`
- **Availability Zones**: eu-west-1a, eu-west-1b

### Load Balancer
- **Name**: terraform-ha-webapp-alb
- **DNS**: terraform-ha-webapp-alb-654245485.eu-west-1.elb.amazonaws.com
- **Type**: Application Load Balancer
- **Status**: Active

### Compute
| Instance | ID | AZ | Private IP | Public IP | Status |
|----------|----|----|------------|-----------|--------|
| web-1 | i-055d0a0a843ec1f67 | eu-west-1a | 10.0.1.212 | 54.75.116.22 | Healthy |
| web-2 | i-098e3c567ce327007 | eu-west-1b | 10.0.2.173 | 54.216.192.129 | Healthy |

### Security
- **ALB Security Group**: Allows HTTP (80) from 0.0.0.0/0
- **Web Security Group**: Allows HTTP (80) from ALB only

### Target Group
- **Name**: terraform-ha-webapp-tg
- **Health Check**: HTTP on port 80, path /
- **Targets**: 2/2 healthy
