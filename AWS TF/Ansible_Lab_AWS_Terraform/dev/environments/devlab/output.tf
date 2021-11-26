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
/*
output "ec2_secrets_manager" {
  value = jsondecode(aws_secretsmanager_secret_version.ec2_secret.secret_string)["password"]
  sensitive = true
}
*/