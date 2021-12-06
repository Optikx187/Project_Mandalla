################################################################################
# iam policy/roles for resources
################################################################################
resource "aws_iam_policy" "ec2_policy" {
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
          Action    = "sts:AssumeRole"
          Effect    = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
        {
          Action    = "sts:AssumeRole"
          Effect    = "Allow",
          Principal = {
            Service = "ssm.amazonaws.com"
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

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  #policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  policy_arn = data.aws_iam_policy.managed_ssm.arn
}

resource "aws_iam_policy_attachment" "ec2_attach" {
  name       = "ec2-attach-${var.environment}-${var.customer_name}"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_policy.arn
}
