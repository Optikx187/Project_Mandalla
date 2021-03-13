 terraform {
   backend "s3" {
     bucket = "dev-tf-state-storage"
     key = "ws-cluster/terraform.tfstate"
     region = "us-east-1"
     dynamodb_table = "dev-tf-state-lock"
     encrypt = true
   }
 }