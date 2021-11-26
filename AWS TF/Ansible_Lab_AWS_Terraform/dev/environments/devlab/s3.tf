resource "aws_kms_key" "s3_key" {
 description             = "This key is used to encrypt bucket objects"
 deletion_window_in_days = 10
 enable_key_rotation     = true
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.11.1"
  # insert the 5 required variables here
  bucket        = "${var.s3_bucket_name}-${var.environment}-${var.customer_name}"
  acl           = "private"
  force_destroy = true

  attach_deny_insecure_transport_policy = true


  versioning = {
    enabled = true
  }

server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.s3_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
tags = merge (
    var.tags,
    var.s3_tags,
)
}