#!/bin/bash -ex
sudo hostnamectl --static set-hostname eks-server
sudo yum -y install git tree tmux jq lynx htop

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

sudo yum install -y kubectl

# docker 설치
sudo yum update -y
sudo yum install docker -y
sudo systemctl enable --now docker
sudo usermod -a -G docker ec2-user