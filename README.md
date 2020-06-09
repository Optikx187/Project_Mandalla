## Project Mandalla

Welcome, 

This project is mainly a hodgepodge of terraform code, powershell, and bash scripts to provide infrustructure for various testing labs.

Currently I'm working on is providing a terraform solution to create an Ansible lab containing a centOS 7.5 control node with a windows server and centOS child node. The infrustructure takes about 15 min to spin up from start to finish. 

### Prereqs before you begin

1)You need Terraform installed or you can use Azure CLI
2)You will need a dedicated folder to store the terraform code
3)You will need to find your connection variables for your cloud service provider
  -Documentation for Azure connection strings can be found at: _Project_Mandalla/Documentation/Configure_Terraform_for_Azure.txt_ 
Note: 
 My local test lab is centOS 8 so many of these examples will use linux commands and syntax

### Get started with IaC Ansible Lab 

Azure: 
1) Download the terraform code into a local directory.
   Code: https://github.com/Optikx187/Project_Mandalla/tree/master/Azure_TF/Ansible_Lab_Az_Terraform
2) Edit _az.provider.tf_ and set up connection string for your provider block
  Documentation for this is laid out here: _Project_Mandalla/Documentation/Configure_Terraform_for_Azure.txt_ 
3) Run terraform init
4) Run terraform plan 
5) Run terraform apply
6) Thats it!

### Stay tuned. There will be much more to come. 
