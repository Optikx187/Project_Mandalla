 terraform {
   backend "s3" {
     bucket = "dev-tf-state-storage"
     key = "mysql/terraform.tfstate"
     region = var.region
     dynamodb_table = "dev-tf-state-lock"
     encrypt = true
   }
 }