################################################################################
# outputs
################################################################################
# ec2
################################################################################
output "bastion_ip" {
    value = module.ec2_bastion_multi.public_ip
    description = "public ip of bastion host"
}
output "bastion_pw" {
    value = module.ec2_bastion_multi.password_data
    description = "pw for admin account"
}
output "windows_ip" {
    value = module.ec2_windows_multi.private_ip
    description = "public ip of bastion host"
}
output "linux_ip" {
    value = module.ec2_linux_multi.private_ip
    description = "public ip of bastion host"
}
################################################################################
/*
output "ec2_secrets_manager" {
  value = jsondecode(aws_secretsmanager_secret_version.ec2_secret.secret_string)["password"]
  sensitive = true
}
*/