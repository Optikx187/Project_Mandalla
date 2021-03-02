#!/bin/bash
export TF_VAR_db_password=12qwaszx12qwaszx
export TF_VAR_db_name=mysqlTEST


terraform init && terraform plan && terraform apply --auto-approve