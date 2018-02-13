#!/bin/bash

set -e

echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y tmux ruby apt-transport-https ca-certificates autojump git python python-pip libnetfilter-queue-dev libnetfilter-log-dev libelf-dev htop ntp ipset
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
apt-get update
apt-get install -y "linux-image-extra-$(uname -r)" linux-image-extra-virtual docker-engine
gem install tmuxinator
systemctl enable docker
usermod -aG docker ubuntu
pip install docker-compose awscli
git clone https://github.com/jimeh/tmux-themepack.git /home/ubuntu/.tmux-themepack

cd /tmp
wget https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.9.2.linux-amd64.tar.gz

add-apt-repository ppa:masterminds/glide
apt-get update

systemctl disable ufw

cat > /lib/systemd/system/docker.service <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network.target docker.socket
Requires=docker.socket

[Service]
Type=notify
ExecStart=/usr/bin/dockerd --insecure-registry hub.aporeto.io --userland-proxy=false -H fd://
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
service docker restart
