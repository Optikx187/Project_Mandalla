output "db_master_password" {
  description = "The master password"
  value       = module.db.db_instance_master_password
  sensitive   = true
}