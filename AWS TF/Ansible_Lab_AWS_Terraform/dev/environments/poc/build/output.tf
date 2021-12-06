################################################################################
# outputs
################################################################################

################################################################################
# ec2
################################################################################
output "bastion_ip" {
    description = "public ip of bastion host"
    value = module.ec2_bastion_multi
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
# vpc
################################################################################
output "vpc_id" {
    description = "vpc id"
    value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
    value = module.vpc.vpc_cidr_block
    description = "vpc cidr"
}
output "vpc_arn" {
    value = module.vpc.vpc_arn
    description = "vpc arn"
}
output "vpc_private_subnet_id" {
    value = module.vpc.private_subnets
    description = "private subnet ips"
}
output "vpc_public_subnet_id" {
    value = module.vpc.public_subnets
    description = "public subnet ips"
}
output "vpc_db_subnet_id" {
    value = module.vpc.database_subnets
    description = "db subnets"
}
################################################################################
# db 
################################################################################
#output "db_instance_endpoint" {
#  description = "The connection endpoint"
#  value       = module.db.db_instance_endpoint
#}
################################################################################
output "secrets_manager_policy_arn" {
    value = aws_secretsmanager_secret_version.ec2_secret.arn
}
output "s3_arn" {
    value = module.media_s3_bucket.s3_bucket_arn

}
#terraform output -json bastion_ip | jq -r '.one.id'
/*
output "ec2_secrets_manager" {
  value = jsondecode(aws_secretsmanager_secret_version.ec2_secret.secret_string)["password"]
  sensitive = true
}
*/