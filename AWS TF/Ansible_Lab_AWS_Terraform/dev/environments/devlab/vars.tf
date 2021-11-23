variable "aws_region" {
  type = string
  description = "AWS region"
  default="us-east-1"
}
variable "s3_bucket_name" {
  type = string
  description = "s3 bucket name for backent config"
  default="lab-s3-bucket"
}