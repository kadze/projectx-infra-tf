# network

Terraform module for the Routebox VPC and network baseline. Ported from
`routebox-infra/cfn/network/template.yaml`.

## Resources created

| Resource | Count | Description |
|---|---|---|
| `aws_vpc` | 1 | `routebox-<env>-vpc`; DNS support + hostnames enabled |
| `aws_internet_gateway` | 1 | `routebox-<env>-igw`; attached to the VPC |
| `aws_subnet` (public) | 3 | `routebox-<env>-public-{a,b,c}`; one per AZ; `map_public_ip_on_launch = true` |
| `aws_subnet` (private) | 3 | `routebox-<env>-private-{a,b,c}`; one per AZ |
| `aws_eip` | 1 | Elastic IP for the NAT gateway |
| `aws_nat_gateway` | 1 | Single NAT in public subnet a. See operational notes below. |
| `aws_route_table` | 2 | Public (default → IGW), private (default → NAT) |
| `aws_route_table_association` | 6 | Each subnet associated to its route table |
| `aws_security_group` | 4 | ALB, ECS, RDS, Jenkins |
| `aws_vpc_security_group_ingress_rule` | 2 | RDS ← ECS, RDS ← Jenkins (separate to avoid cycles) |

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `environment` | `string` | required | One of `dev`, `staging`, `prod`. Drives resource names. |
| `vpc_cidr` | `string` | required | VPC CIDR block (e.g. `10.10.0.0/16`). |
| `public_subnet_cidrs` | `list(string)` | required | Three public subnet CIDRs in AZ order (a/b/c). |
| `private_subnet_cidrs` | `list(string)` | required | Three private subnet CIDRs in AZ order (a/b/c). |
| `cost_center` | `string` | `"platform"` | Cost allocation tag value. |

## Outputs

| Name | Description | Equivalent CFN export |
|---|---|---|
| `vpc_id` | VPC ID | `routebox-<env>-vpc-id` |
| `vpc_cidr_block` | VPC CIDR block | `routebox-<env>-vpc-cidr` |
| `public_subnet_ids` | List of all 3 public subnet IDs (index 0–2) | — |
| `private_subnet_ids` | List of all 3 private subnet IDs (index 0–2) | — |
| `public_subnet_1_id` | Public subnet AZ a (index 0) | `routebox-<env>-public-subnet-1` |
| `public_subnet_2_id` | Public subnet AZ b (index 1) | `routebox-<env>-public-subnet-2` |
| `public_subnet_3_id` | Public subnet AZ c (index 2) | `routebox-<env>-public-subnet-3` |
| `private_subnet_1_id` | Private subnet AZ a (index 0) | `routebox-<env>-private-subnet-1` |
| `private_subnet_2_id` | Private subnet AZ b (index 1) | `routebox-<env>-private-subnet-2` |
| `private_subnet_3_id` | Private subnet AZ c (index 2) | `routebox-<env>-private-subnet-3` |
| `alb_security_group_id` | ALB SG ID | `routebox-<env>-alb-sg-id` |
| `ecs_service_security_group_id` | ECS service SG ID | `routebox-<env>-ecs-sg-id` |
| `rds_security_group_id` | RDS SG ID | `routebox-<env>-rds-sg-id` |
| `jenkins_security_group_id` | Jenkins SG ID | `routebox-<env>-jenkins-sg-id` |

## Security groups

| SG | Inbound |
|---|---|
| ALB | 80/tcp from 0.0.0.0/0 (HTTP, listener redirects to HTTPS), 443/tcp from 0.0.0.0/0 |
| ECS | 0–65535/tcp from ALB SG (wide range preserved from CFN; per-service tightening is a follow-up) |
| RDS | 5432/tcp from ECS SG, 5432/tcp from Jenkins SG |
| Jenkins | 8080/tcp from VPC CIDR (SSH from bastion CIDR is a TODO — see below) |

All SGs allow all egress (default AWS behavior, preserved explicitly).

## Operational notes

### Single NAT gateway (SPOF)

There is **one** NAT gateway, placed in public subnet a (`aws_subnet.public["0"]`). This
is intentional for cost — the original CFN deployment had one NAT per AZ, but was
collapsed to a single gateway. Private-subnet traffic in all three AZs goes through
this single NAT. If the AZ hosting that subnet or the NAT itself fails, all private
egress stops.

To restore per-AZ redundancy: add two more `aws_nat_gateway` resources (one each in
`aws_subnet.public["1"]` and `aws_subnet.public["2"]`), add private route tables per AZ,
and point each private RT's default route to the local NAT.

### Grandfathered CloudFormation exports — not reproduced here

The CFN stack exported two legacy names that predate the `routebox-<env>-<resource>`
convention:

- `${env}-vpc` — the VPC ID
- `${env}-subnet-private-a` — private subnet a ID

These are used by the `rds` and `ecs-cluster` stacks in places that are awkward to
update without a coordinated multi-stack deploy. **This module does not and cannot
reproduce them.** CloudFormation `Export` / `!ImportValue` and Terraform outputs are
different mechanisms with no interop. Consumer stacks that still rely on those CFN
export names must be migrated off before this Terraform module can replace the CFN
stack in any environment.

### Tags

Resources are tagged via the environment-level provider `default_tags`:

- `Environment`: `dev` / `staging` / `prod`
- `ManagedBy`: `terraform` *(changed from `cloudformation`)*
- `CostCenter`: per-env value (e.g. `platform-dev`)

Each resource also carries a `Name` tag set inside the module, matching the original
CFN naming (`routebox-<env>-vpc`, `routebox-<env>-public-a`, etc.). Subnets also carry
a `Tier` tag (`public` or `private`).

### Jenkins SSH bastion (TODO)

The Jenkins SG carries a TODO from the original CFN template: allow SSH (port 22)
inbound from a bastion CIDR. The bastion was never provisioned. When it is, add an
`aws_vpc_security_group_ingress_rule` for port 22 with the bastion's source CIDR.
