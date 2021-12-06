#cannot use variables for bucket names and 
#Errors if S3 backend not established. #chicken before egg type deal

  
terraform {
 backend "s3" {
   bucket         = "dev-lab-s3-state" #update me
   key            = "dev/terraform.tfstate" #update me for env seperations
   region         = "us-east-1" #update me
   encrypt        = true
   kms_key_id     = "alias/terraform-bucket-key" #must match key name in state.tf
   dynamodb_table = "dev-tf-state" #update me for env seprations #match dynamodb name in state.tf
 }
}
