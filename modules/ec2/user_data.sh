#! /bin/bash

# Update repositores of Ubuntu
apt-get update

# Get own IP of Ec2 instance
SELFIP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

# Send logs of User data to console in CloudWatch
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

mkdir -p ${HOME}/autostart
chown -R ubuntu:ubuntu ${HOME}/autostart

# Install zsh
apt install zsh -y
chsh -s /bin/zsh ubuntu
su - ubuntu -c "(sh -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh))"

# Install tmux and Oh-my-tmux
apt install tmux -y
su - ubuntu -c "(cd ${HOME}/ && git clone https://github.com/gpakosz/.tmux.git && ln -s -f .tmux/.tmux.conf && cp .tmux/.tmux.conf.local .)"

# Install VSCode server
mkdir -p ${HOME}/app/

wget https://github.com/cdr/code-server/releases/download/2.1692-vsc1.39.2/code-server2.1692-vsc1.39.2-linux-x86_64.tar.gz
tar xfvz code-server2.1692-vsc1.39.2-linux-x86_64.tar.gz
mv code-server2.1692-vsc1.39.2-linux-x86_64 code-server
mv code-server ${HOME}/app/
rm releases/download/2.1692-vsc1.39.2/code-server2.1692-vsc1.39.2-linux-x86_64.tar.gz
chown -R ubuntu:ubuntu ${HOME}/app/

tee -a ${HOME}/autostart/code-server.sh > /dev/null <<EOT
#!/bin/bash
${HOME}/app/code-server/code-server
EOT
chmod +x ${HOME}/autostart/code-server.sh

# Code Server SystemD
mkdir /etc/systemd/system/codeserver.service.d
tee -a /etc/systemd/system/codeserver.service.d/myenv.conf > /dev/null <<EOT
[Service]
Environment="PASSWORD=${CODESERVER_PASSWORD}"
EOT

tee -a /lib/systemd/system/codeserver.service > /dev/null <<EOT
[Unit]
Description=CodeServer

Wants=network-online.target
After=network-online.target

[Service]
User=ubuntu
Group=ubuntu
Restart=always
RestartSec=3
ExecStart=${HOME}/autostart/code-server.sh

[Install]
WantedBy=default.target
EOT

systemctl enable codeserver
systemctl start codeserver

# Anaconda
su - ubuntu -c "(cd ${HOME} && curl -o Anaconda.sh ${ANACONDA} && chmod +x Anaconda.sh)"
su - ubuntu -c "(cd ${HOME} && mkdir -p notebooks/ && bash Anaconda.sh -b -p ${HOME}/anaconda && rm Anaconda.sh)"

# Create SystemD of Jupyter Lab
mkdir -p ${HOME}/notebooks
chown -R ubuntu:ubuntu ${HOME}/notebooks

tee -a ${HOME}/autostart/jupyter.sh > /dev/null <<EOT
#!/bin/bash
source ${HOME}/anaconda/bin/activate
jupyter lab --NotebookApp.token='' --NotebookApp.ip='*' --NotebookApp.base_url=/ --NotebookApp.notebook_dir=${HOME}/notebooks
EOT
chmod +x ${HOME}/autostart/jupyter.sh

tee -a /lib/systemd/system/jupyter.service > /dev/null <<EOT
[Unit]
Description=Jupyter Lab

Wants=network-online.target
After=network-online.target

[Service]
User=ubuntu
Group=ubuntu
Restart=always
RestartSec=3
ExecStart=${HOME}/autostart/jupyter.sh

[Install]
WantedBy=default.target
EOT

systemctl enable jupyter
systemctl start jupyter

# Install Docker
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt update
apt install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker ubuntu

# Install Portainer
apt install -y apache2-utils
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock --name portainer --admin-password="$(htpasswd -nbB admin password | cut -d ":" -f 2)" -v portainer_data:/data portainer/portainer

# Reboot 
reboot