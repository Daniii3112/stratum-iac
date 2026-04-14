# STRATUM — Cloud Infrastructure as Code

Production-grade AWS infrastructure for a Kubernetes-based platform, built with Terraform.

## Architecture

┌─────────────────────────────────────────────────────┐
│                    AWS eu-west-1                    │
│                                                     │
│  ┌──────────────────────────────────────────────┐   │
│  │                    VPC                       │   │
│  │           CIDR: 10.0.0.0/16                  │   │
│  │                                              │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────┐  │   │
│  │  │  Public    │  │  Public    │  │ Public │  │   │
│  │  │  Subnet 1a │  │  Subnet 1b │  │  1c    │  │   │
│  │  │  NAT GW    │  │  NAT GW    │  │ NAT GW │  │   │
│  │  └────────────┘  └────────────┘  └────────┘  │   │
│  │                                              │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────┐  │   │
│  │  │  Private   │  │  Private   │  │Private │  │   │
│  │  │  EKS Nodes │  │  EKS Nodes │  │  RDS   │  │   │
│  │  └────────────┘  └────────────┘  └────────┘  │   │
│  └──────────────────────────────────────────────┘   │
│                                                     │
│  ┌─────────────┐  ┌──────────────┐  ┌───────────┐   │
│  │     EKS     │  │    Aurora    │  │    S3     │   │
│  │  v1.28      │  │  PostgreSQL  │  │  + State  │   │
│  │  3 nodes    │  │  Multi-AZ    │  │  Bucket   │   │
│  └─────────────┘  └──────────────┘  └───────────┘   │
└─────────────────────────────────────────────────────┘

## Modules

| Module | Description |
|--------|-------------|
| `vpc` | VPC, subnets, NAT gateways, route tables |
| `eks` | EKS cluster, node groups, IAM roles |
| `rds` | Aurora PostgreSQL, Secrets Manager |
| `s3` | Asset buckets, Terraform state backend, DynamoDB locks |

## Environments

| Environment | Region | EKS Nodes | DB Instance |
|-------------|--------|-----------|-------------|
| production | eu-west-1 | 3x m5.xlarge | db.r6g.large |
| staging | eu-west-1 | 2x t3.large | db.t4g.medium |

## Usage

```bash
# Install Terraform
brew install terraform

# Init production
cd environments/production
terraform init
terraform plan
terraform apply
```

## Design decisions

- **Multi-AZ** — all critical resources span 3 availability zones for high availability
- **Private subnets** — EKS nodes and RDS run in private subnets, never exposed publicly
- **Least privilege IAM** — separate roles for cluster and nodes with minimum required permissions
- **Encrypted storage** — S3 and RDS encrypted at rest with AES256
- **Remote state** — Terraform state stored in S3 with DynamoDB locking to prevent conflicts
- **Secrets Manager** — database passwords never in code, always in AWS Secrets Manager

## Stack

- Terraform >= 1.5
- AWS Provider ~> 5.0
- Kubernetes 1.28
- Aurora PostgreSQL 15.3