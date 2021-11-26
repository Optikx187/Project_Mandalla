################################################################################
# Keypairs
################################################################################
# this will create a key with RSA algorithm with 4096 rsa bits
resource "tls_private_key" "private_key_ec2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# this resource will create a key pair using above private key
resource "aws_key_pair" "key_pair_ec2" {
  key_name   = var.key_name_ec2
  public_key = tls_private_key.private_key_ec2.public_key_openssh
  depends_on = [tls_private_key.private_key_ec2]
  tags = merge (
    {
      "Name" = format("%s", var.key_name_ec2)
    },
    var.tags,
    var.key_tags,
  )
}
# this resource will save the private key at our specified path.
resource "local_file" "saveKey_ec2" {
  content = tls_private_key.private_key_ec2.private_key_pem
  filename = "${var.base_path}/${var.key_name_ec2}.pem"
}
#rds key 
#root key
resource "tls_private_key" "private_key_root" {
    algorithm = "RSA"
    rsa_bits  = 4096
  }
  # this resource will create a key pair using above private key
  resource "aws_key_pair" "key_pair_root" {
    key_name   = var.key_name_root
    public_key = tls_private_key.private_key_root.public_key_openssh
    depends_on = [tls_private_key.private_key_root]
    tags = merge (
      {
        "Name" = format("%s", var.key_name_root)
      },
      var.tags,
      var.key_tags,
    )
  }
  # this resource will save the private key at our specified path.
  resource "local_file" "saveKey_root" {
    content = tls_private_key.private_key_root.private_key_pem
    filename = "${var.base_path}/${var.key_name_root}.pem"
  }
  #additional keys

#ec2 passwords
  resource "random_password" "ec2_pw" {
    length           = 20
    special          = false
  }

  # NOTE: Since we aren't specifying a KMS key this will default to using
  # `aws/secretsmanager`/
  resource "aws_secretsmanager_secret" "ec2" {
    name        = "ec2-${var.environment}-${var.customer_name}"
    tags = merge (
      var.tags,
      var.key_tags,
    )
  }

  resource "aws_secretsmanager_secret_version" "ec2_secret" {
    secret_id     = aws_secretsmanager_secret.ec2.id
    secret_string = jsonencode({"password": "${random_password.ec2_pw.result}"})
  }
#rds passwords
  resource "random_password" "rds_pw" {
    length           = 20
    special          = false
  }

  # NOTE: Since we aren't specifying a KMS key this will default to using
  # `aws/secretsmanager`/
  resource "aws_secretsmanager_secret" "rds" {
    name        = "rds-${var.environment}-${var.customer_name}"
    tags = merge (
      var.tags,
      var.key_tags,
    )
  }

  resource "aws_secretsmanager_secret_version" "rds_secret" {
    secret_id     = aws_secretsmanager_secret.rds.id
    secret_string = jsonencode({"password": "${random_password.rds_pw.result}"})
  }
