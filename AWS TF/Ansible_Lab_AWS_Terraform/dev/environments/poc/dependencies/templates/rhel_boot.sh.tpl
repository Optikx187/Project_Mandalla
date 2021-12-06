#! /bin/bash
#rhel 8
sudo useradd -G wheel ${uname}
echo '${uname}:${pass}' | sudo chpasswd
sudo sed -i '63s/.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i '65s/.*/#PasswordAuthentication no/' /etc/ssh/sshd_config

sudo yum -y install python3 python3-pip curl
pip3 install awscli --upgrade
#update architecture
sudo dnf install -y  https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/linux_amd64/amazon-ssm-agent.rpm
#sudo dnf install -y  https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/linux_arm64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent 
sudo systemctl start amazon-ssm-agent

#sudo yum -y update
sudo mkdir /apps
sudo mkdir /media

#dnf install python3-pip
#pip3 install awscli --upgrade --user

reboot -f
 