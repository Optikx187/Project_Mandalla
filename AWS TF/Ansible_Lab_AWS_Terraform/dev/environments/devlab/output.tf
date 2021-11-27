################################################################################
# outputs
################################################################################
# ec2
################################################################################
output "bastion_ip" {
    value = module.ec2_bastion_multi
    description = "public ip of bastion host"
}
output "windows_ip" {
    value = module.ec2_windows_multi
    description = "public ip of bastion host"
}
output "linux_ip" {
    value = module.ec2_linux_multi
    description = "public ip of bastion host"
}
################################################################################
#db 
#output "db_instance_endpoint" {
#  description = "The connection endpoint"
#  value       = module.db.db_instance_endpoint
#}
################################################################################
output "secrets_manager_policy_arn" {
    value = aws_secretsmanager_secret_version.ec2_secret.arn
}
output "s3_arn" {
    value = module.s3_bucket.s3_bucket_arn

}
/*
output "ec2_secrets_manager" {
  value = jsondecode(aws_secretsmanager_secret_version.ec2_secret.secret_string)["password"]
  sensitive = true
}
*/