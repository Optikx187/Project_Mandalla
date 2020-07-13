#!/bin/bash

sudo yum -y update --nobest
sudo yum -y install nano --nobest
sudo yum -y install unzip --nobest
sudo yum -y install wget --nobest
sudo yum -y install openssh-server openssh-clients --nobest
sudo yum -y install python2  --nobest
#ansible install
sudo yum -y install python3 --nobest
sudo yum -y install python3-pip --nobest
sudo yum -y install epel-release --nobest
sudo yum -y install ansible --nobest

#install windows ansible dependency
pip3 install pywinrm

#terraform install
sudo wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip
sudo unzip ./terraform_0.12.26_linux_amd64.zip -d /usr/local/bin/
sudo rm ./terraform_0.12.26_linux_amd64.zip