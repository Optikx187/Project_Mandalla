#!/bin/bash
#assumes aws config profiles are set for tf code and referenced in main.tf
#ansible dependancies must be installed
    #ansible-galaxy collection install amazon.aws
    #python 3.6
    #botocore
    #boto3
    #ssm aws cli plugin
        #https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
        #amd:curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"
        #arm:curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_arm64/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"
        #sudo yum install -y session-manager-plugin.rpm
#tf env vars will need to be configured for pipelines
#seperate backend pipeline
## source env
export AWS_DEFAULT_REGION=us-east-1 #change me
export AWS_PROFILE=default #change me 
#change me match base path
function init()
{
    echo 'creating local dirs'
    #mkdir ./build_keys/ ./build_keys/env/ ./build_keys/env/poc/ > /dev/null
    echo 'initializing supporting infra'
    pushd ./init > /dev/null
    #Run init terraform
    rm *.tfplan .terraform.lock.hcl terraform.tfstate.backup
    rm -rf .terraform 
    terraform init  -input=false
    terraform plan  -input=false -out=init.tfplan
    terraform apply -input=false "init.tfplan"
    #Copy tf files to ../*
    cp *.tfplan ../build/
    cp -rp .terraform ../build/
    #cp *.tfstate ../
    popd > /dev/null
}
function destroy_init()
{
    echo 'destroying supporting infra'
    pushd ./init > /dev/null
    terraform destroy -auto-approve  &&  rm -rf .terraform  &&  rm *.tfplan .terraform.lock.hcl terraform.tfstate.backup
    popd > /dev/null
}
function build()
{
    echo 'building infra'
    #run main tf
    pushd ./build > /dev/null
    rm *.tfplan .terraform.lock.hcl *.tfstate terraform.tfstate.backup
    rm -rf .terraform 
    terraform init  -input=false
    terraform plan  -input=false -out=build.tfplan
    terraform apply -input=false "build.tfplan"
    #ingest tf outputs here.. ansible functions
    popd > /dev/null
}
function destroy_build()
{
    echo 'destroying infra'
    pushd ./build > /dev/null
    terraform destroy -auto-approve && rm *.tfplan .terraform.lock.hcl *.tfstate && terraform.tfstate.backup && rm -rf .terraform  
    popd > /dev/null
}
function configure()
{
    export AWS_DEFAULT_REGION=us-east-1 #change me
    export AWS_PROFILE=default #change me 
    pushd ./ansible > /dev/null
    echo 'confinguring windows instances'
    AWS_PROFILE=default ansible-playbook win_playbook.yml -v
    echo 'configuring linux instances'
    AWS_PROFILE=default ansible-playbook lin_playbook.yml -v
    popd > /dev/null
}
#arguments
$1 $2 $3 $4 $5 

#ansible example
#$ AWS_PROFILE=default ansible-playbook win_playbook.yml

