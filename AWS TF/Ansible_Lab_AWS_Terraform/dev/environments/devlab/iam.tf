data "aws_iam_policy_document" "ec2_policydocument" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret_version.ec2_secret.arn]
    effect    = "Allow"
  }
  statement {
    actions   = ["s3:*"]
    resources = [module.s3_bucket.s3_bucket_arn] #check outputs
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "secretpolicy" {
  name        = "ec2-policy-${var.environment}-${var.customer_name}"
  description = "Policy for Instances"
  policy      = data.aws_iam_policy_document.ec2_policydocument.json
}


resource "aws_iam_role" "ec2_role" {
  name = "ec2-role-${var.environment}-${var.customer_name}"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "server-ec2-role-${var.environment}-${var.customer_name}"
  role = aws_iam_role.ec2_role.name
}



resource "aws_iam_policy_attachment" "ec2_attach" {
  name       = "ec2-attach-${var.environment}-${var.customer_name}"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.secretpolicy.arn
}