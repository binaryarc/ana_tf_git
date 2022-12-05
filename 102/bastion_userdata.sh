#!/bin/bash -ex
# Updated to use Amazon Linux 2
sudo yum -y update
sudo rm -f /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime
sudo hostnamectl set-hostname bastion