#!/bin/bash
export TF_VAR_bucket_name=dev-tf-state-storage
export TF_VAR_table_name=dev-tf-state-lock

terraform init && terraform plan && terraform apply --auto-approve

