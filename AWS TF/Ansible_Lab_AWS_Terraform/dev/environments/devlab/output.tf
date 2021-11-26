
#output "db_master_password" {
#  description = "The master password"
#  value       = random_password.password.result
#  sensitive   = true
#}

output "ec2_secrets_manager" {
  value = jsondecode(aws_secretsmanager_secret_version.ec2_secret.secret_string)["password"]
  sensitive = true
}