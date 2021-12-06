################################################################################
# queried data
################################################################################
################################################################################
# general
################################################################################
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
################################################################################
# iam
################################################################################
data "aws_iam_policy_document" "ec2_policydocument" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret_version.ec2_secret.arn]
    effect    = "Allow"
  }
  statement {
    actions   = ["s3:*"]
    resources = [module.media_s3_bucket.s3_bucket_arn, module.tools_s3_bucket.s3_bucket_arn]
    effect    = "Allow"
  }
  statement {
    actions   = ["ssm:*"]
    resources = ["*"]
    effect    = "Allow"
  }
}
################################################################################
# ami's
################################################################################
#https://gmusumeci.medium.com/how-to-get-the-latest-os-ami-in-aws-using-terraform-5b1fca82daff
# Get latest Red Hat Enterprise Linux 7.x AMI
data "aws_ami" "redhat-linux-7" {
  most_recent = true
  owners      = ["309956199498"]
  filter {
    name   = "name"
    values = ["RHEL-7.*"]
  }
}
# Get latest Red Hat Enterprise Linux 8.x AMI
data "aws_ami" "redhat-linux-8" {
  most_recent = true
  owners      = ["309956199498"]
  filter {
    name   = "name"
    values = ["RHEL-8.*"]
  }
}

# Get latest Windows Server 2016 AMI
data "aws_ami" "windows-2016" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base*"]
  }
}
# Get latest Windows Server 2019 AMI
data "aws_ami" "windows-2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}