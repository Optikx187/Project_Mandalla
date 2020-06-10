# Project_Mandalla
## Project Mandalla

Welcome, 

This project is mainly a hodgepodge of terraform code, powershell, and bash scripts to provide infrustructure for various solutions. This project is my documented journey down the path of learning immutable infrustructure and configuration management. Currently I'm working on is providing a terraform solution to create an Ansible lab containing a centOS 7.5 control node with a windows server and centOS child node. The infrustructure takes about 15 min to spin up from start to finish. 

For now, all documentation is for CentOS and the Azure terraform provider, but AWS is on the list of future projects.

### Prereqs before you begin

1)You need Terraform installed or you can use Azure CLI
2)You will need a dedicated folder to store the terraform code
3)You will need to find your connection variables for your cloud service provider
  -Documentation for Azure connection strings can be found at:
  https://github.com/Optikx187/Project_Mandalla/tree/master/Documentation/Configure_Terraform_for_Azure.txt
 
### Get started with IaC Ansible Lab 
_Note: My local test lab is centOS 8 so many of the examples in the documetation will use linux commands and syntax_

Software versions:
Terraform 0.12.26
Ansible 2.9.9
Azure provider 2.0

Azure: 
1) Download the terraform code into a local directory.
   Code: https://github.com/Optikx187/Project_Mandalla/tree/master/Azure_TF/Ansible_Lab_Az_Terraform
2) Edit _az.provider.tf_ and set up connection string for your provider block
  Documentation for this is laid out here: _Project_Mandalla/Documentation/Configure_Terraform_for_Azure.txt_ 
3) Run 'terraform init'
4) Run 'terraform plan'
5) Run 'terraform apply'
6) Thats it your ansible infrustructure is built in Azure. 

The Terraform code covers:
-Bootstrapping the ansible node to install ansible as well as some helpful tools that you might need.
-Bootstrapping the windows server to run 'ConfigureRemotingForAnsible.ps1' to allow winrm connectivity to your windows server from your ansible node.

### Get started with Ansible:
Once the terraform apply is done, you will need to configure your inventory file on your Ansible control node to run some test playbooks. 
Detailed instructions can be found here: https://github.com/Optikx187/Project_Mandalla/tree/master/Documentation


### Stay tuned. There will be much more to come. 

