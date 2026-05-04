# kadze-routebox-infra-tf

Terraform IaC for Routebox AWS infrastructure. **Migration in progress** — the
`network` stack has been ported; the other five stacks remain on CloudFormation in
[`routebox-infra`](https://github.com/312school/routebox-infra) until each is migrated.

## Repository layout

```
.
├── network/               ← reusable module (VPC, subnets, SGs, NAT, route tables)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md          ← inputs, outputs, operational notes
├── environments/
│   ├── dev/               ← dev env wiring + tfvars
│   ├── staging/           ← staging env wiring + tfvars
│   └── prod/              ← prod env wiring + tfvars
└── README.md              ← you are here
```

## Migration status

| Stack | Source | Status |
|---|---|---|
| `network` | `routebox-infra/cfn/network/` | **Ported to Terraform** (this repo) |
| `iam` | `routebox-infra/cfn/iam/` | CloudFormation only |
| `ecs-cluster` | `routebox-infra/cfn/ecs-cluster/` | CloudFormation only |
| `rds` | `routebox-infra/cfn/rds/` | CloudFormation only |
| `ecr` | `routebox-infra/cfn/ecr/` | CloudFormation only |
| `secrets-bootstrap` | `routebox-infra/cfn/secrets-bootstrap/` | CloudFormation only |

## ⚠ Before applying any environment

1. **Do not apply against an account that already has `routebox-network-<env>` CFN stacks.**
   Terraform does not adopt existing resources unless you run `terraform import`. Applying
   without importing will create parallel resources alongside the CFN-managed ones.

2. **Fill in `backend.tf` placeholders** (S3 bucket, region, DynamoDB lock table) in each
   `environments/<env>/backend.tf` before running `terraform init`.

3. **Cross-stack imports are not migrated.** The remaining CloudFormation stacks (`iam`,
   `ecs-cluster`, `rds`, etc.) still consume CloudFormation exports from the `network`
   stack. Two of those export names are grandfathered legacy names (`${env}-vpc`,
   `${env}-subnet-private-a`) that Terraform cannot reproduce. See
   [`network/README.md`](network/README.md) for details.

## Deploying an environment

```bash
cd environments/<env>

# One-time setup: fill in backend.tf, then:
terraform init

# Plan
terraform plan -var-file=<env>.tfvars

# Apply
terraform apply -var-file=<env>.tfvars
```

## Module documentation

See [`network/README.md`](network/README.md) for full inputs, outputs, resource list,
and operational notes (single NAT SPOF, grandfathered CFN exports, tags, Jenkins TODO).
