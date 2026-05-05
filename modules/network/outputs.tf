output "vpc_id" {
  description = "VPC ID. Matches CFN export routebox-<env>-vpc-id."
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block. Matches CFN export routebox-<env>-vpc-cidr."
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs ordered by AZ index (0=a, 1=b, 2=c)."
  value       = [for k in ["0", "1", "2"] : aws_subnet.public[k].id]
}

output "private_subnet_ids" {
  description = "Private subnet IDs ordered by AZ index (0=a, 1=b, 2=c)."
  value       = [for k in ["0", "1", "2"] : aws_subnet.private[k].id]
}

output "public_subnet_1_id" {
  description = "Public subnet in AZ a (index 0). Matches CFN export routebox-<env>-public-subnet-1."
  value       = aws_subnet.public["0"].id
}

output "public_subnet_2_id" {
  description = "Public subnet in AZ b (index 1). Matches CFN export routebox-<env>-public-subnet-2."
  value       = aws_subnet.public["1"].id
}

output "public_subnet_3_id" {
  description = "Public subnet in AZ c (index 2). Matches CFN export routebox-<env>-public-subnet-3."
  value       = aws_subnet.public["2"].id
}

output "private_subnet_1_id" {
  description = "Private subnet in AZ a (index 0). Matches CFN export routebox-<env>-private-subnet-1."
  value       = aws_subnet.private["0"].id
}

output "private_subnet_2_id" {
  description = "Private subnet in AZ b (index 1). Matches CFN export routebox-<env>-private-subnet-2."
  value       = aws_subnet.private["1"].id
}

output "private_subnet_3_id" {
  description = "Private subnet in AZ c (index 2). Matches CFN export routebox-<env>-private-subnet-3."
  value       = aws_subnet.private["2"].id
}

output "alb_security_group_id" {
  description = "ALB security group ID. Matches CFN export routebox-<env>-alb-sg-id."
  value       = aws_security_group.alb.id
}

output "ecs_service_security_group_id" {
  description = "ECS service security group ID. Matches CFN export routebox-<env>-ecs-sg-id."
  value       = aws_security_group.ecs.id
}

output "rds_security_group_id" {
  description = "RDS security group ID. Matches CFN export routebox-<env>-rds-sg-id."
  value       = aws_security_group.rds.id
}

output "jenkins_security_group_id" {
  description = "Jenkins security group ID. Matches CFN export routebox-<env>-jenkins-sg-id."
  value       = aws_security_group.jenkins.id
}
