output "db_endpoint" {
  description = "RDS instance hostname. Matches CFN export routebox-<env>-db-endpoint."
  value       = aws_db_instance.main.address
}

output "db_port" {
  description = "RDS instance port. Matches CFN export routebox-<env>-db-port."
  value       = aws_db_instance.main.port
}

output "db_instance_identifier" {
  description = "RDS instance identifier. Matches CFN export routebox-<env>-db-id."
  value       = aws_db_instance.main.identifier
}

output "db_name" {
  description = "Database name inside the instance."
  value       = aws_db_instance.main.db_name
}
