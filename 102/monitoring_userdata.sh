#!/bin/bash -ex

sudo yum -y update
sudo rm -f /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime
sudo hostnamectl set-hostname monitoring

cat <<EOF | sudo tee /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

sudo yum repolist -y
sudo yum install -y grafana
sudo systemctl enable --now grafana-server