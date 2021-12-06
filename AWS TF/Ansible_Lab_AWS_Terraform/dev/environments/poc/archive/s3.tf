################################################################################
# s3 module
################################################################################
module "media_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.11.1"
  # insert the 5 required variables here
  bucket        = "${var.s3_bucket_media}-${var.environment}-${var.customer_name}"
  acl           = "private"
  force_destroy = true

  attach_deny_insecure_transport_policy = true

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  
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
#ansible s3bucket
module "tools_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.11.1"
  # insert the 5 required variables here
  bucket        = "${var.s3_bucket_tools}-${var.environment}-${var.customer_name}"
  acl           = "private"
  force_destroy = true

  attach_deny_insecure_transport_policy = true

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  
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