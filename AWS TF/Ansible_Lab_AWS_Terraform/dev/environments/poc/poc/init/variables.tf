#=======================
#backend config var
#=======================
variable "s3_backend_name" {
  type = string
  description = "s3 bucket name for backent config"
  default     = "dev-lab-s3-state" #change me
}

variable "dynamo_db_backend_name" {
  type = string
  description = "dynamodb name for backent config"
  default     = "dev-tf-state" #change me
}