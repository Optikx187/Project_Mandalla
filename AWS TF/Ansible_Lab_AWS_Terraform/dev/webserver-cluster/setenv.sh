#!/bin/bash
export TF_VAR_instance_name=TEST
export TF_VAR_sg_http_name=HTTP-SG-TEST
export TF_VAR_sg_alb_name=ALB-SG-TEST
export TF_VAR_alb_name=ALB-TEST

terraform init && terraform plan && terraform apply --auto-approve