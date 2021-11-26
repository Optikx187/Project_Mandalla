#cannot use variables for bucket names and 
#must be commented out on first run. S3 backend not established. #chicken before egg type deal
#bucket name must ma tch variable 
    #terrarofm init
    #terraform plan -out test.tfplan
    #terraform apply "test.tfplan"
/*    
terraform {
 backend "s3" {
   bucket         = "dev-lab-s3-bucket" #update me
   key            = "state/terraform.tfstate"
   region         = "us-east-1" #update me
   encrypt        = true
   kms_key_id     = "alias/terraform-bucket-key"
   dynamodb_table = "terraform-state"
 }
}
*/