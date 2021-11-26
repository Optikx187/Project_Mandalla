#! /bin/bash
sudo useradd -G wheel ${uname}
echo '${uname}:${pass}' | sudo chpasswd
sudo sed -i '63s/.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i '65s/.*/#PasswordAuthentication no/' /etc/ssh/sshd_config
#sudo systemctl stop sshd
#sudo systemctl start sshd
reboot -f
 