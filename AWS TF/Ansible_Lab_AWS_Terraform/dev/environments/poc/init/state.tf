################################################################################
# .tfstate file infra config
################################################################################
#cannot use variables for bucket names
#must be commented out on first run. S3 backend not established. #chicken before egg type deal
#bucket name must match variable 
    #terrarofm init
    #terraform plan -out test.tfplan
    #terraform apply "test.tfplan"
    
/*
terraform {
 backend "s3" {
   bucket         = "dev-lab-s3-state" #update me
   key            = "state/terraform.tfstate"
   region         = "us-east-1" #update me
   encrypt        = true
   kms_key_id     = "alias/terraform-bucket-key"
   dynamodb_table = "terraform-state"
 }
}
*/
resource "aws_kms_key" "terraform-bucket-key" {
 description             = "This key is used to encrypt bucket objects"
 deletion_window_in_days = 10
 enable_key_rotation     = true
}
resource "aws_kms_alias" "key-alias" {
 name          = "alias/terraform-bucket-key"
 target_key_id = aws_kms_key.terraform-bucket-key.key_id
}
#S3 Bucket
resource "aws_s3_bucket" "terraform-state" {
 bucket = var.s3_backend_name
 acl    = "private"

 versioning {
   enabled = true
 }

 server_side_encryption_configuration {
   rule {
     apply_server_side_encryption_by_default {
       kms_master_key_id = aws_kms_key.terraform-bucket-key.arn
       sse_algorithm     = "aws:kms"
     }
   }
 }
}

resource "aws_s3_bucket_public_access_block" "block" {
 bucket = aws_s3_bucket.terraform-state.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}

#dynamodb
resource "aws_dynamodb_table" "terraform-state" {
 name           = var.dynamo_db_backend_name
 read_capacity  = 20
 write_capacity = 20
 hash_key       = "LockID"

 attribute {
   name = "LockID"
   type = "S"
 }
}