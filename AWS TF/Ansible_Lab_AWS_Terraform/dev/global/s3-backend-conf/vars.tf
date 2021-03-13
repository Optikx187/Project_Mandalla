variable "region" {
    description = "region for tf code"
    type        = string
    default     = "us-east-1"
    }

variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
}

variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
}