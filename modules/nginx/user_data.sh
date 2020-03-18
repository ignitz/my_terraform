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

apt install -y nginx apache2-utils

# Get own IP of Ec2 instance
SELFIP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
# Send logs of User data to console in CloudWatch
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

export CONFFILE=/etc/nginx/nginx.conf

# Create Nginx Config
echo "http {" > $CONFFILE
echo "  server {" >> $CONFFILE
echo "    listen 80;" >> $CONFILE

# Port 9000 for portainer
echo "    location / {" >> $CONFFILE
echo '      proxy_pass                   http://${EC2HOST}:9000/;' >> $CONFFILE
echo '      proxy_set_header             X-ProxyHost $host;' >> $CONFFILE
echo '      proxy_set_header             X-ProxyPort 80;' >> $CONFFILE
echo '      proxy_set_header             X-ProxyContextPath /;' >> $CONFFILE
echo "    }" >> $CONFFILE

# Jupyter Route
echo "    location /jupyter {" >> $CONFFILE
echo "      auth_basic_user_file         /etc/nginx/.htpasswd;" >> $CONFFILE
echo "      auth_basic                   \"Authentication required\";" >> $CONFFILE
echo "      proxy_pass                   http://${JupyterHOST}:8888;" >> $CONFFILE
echo '      proxy_set_header Host $host;' >> $CONFFILE
echo '      proxy_set_header X-Real-IP $remote_addr;' >> $CONFFILE
echo '      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' >> $CONFFILE
echo "      proxy_http_version 1.1;" >> $CONFFILE
echo '      proxy_set_header Upgrade $http_upgrade;' >> $CONFFILE
echo "      proxy_set_header Connection \"upgrade\";" >> $CONFFILE
echo "      proxy_read_timeout 86400;" >> $CONFFILE
echo "    }" >> $CONFFILE
echo "" >> $CONFFILE
echo "    client_max_body_size 50M;" >> $CONFFILE
echo "" >> $CONFFILE
echo "    location ~* /jupyter/(api/kernels/[^/]+/(channels|iopub|shell|stdin)|terminals/websocket)/? {" >> $CONFFILE
echo "      proxy_pass                   http://${JupyterHOST}:8888;" >> $CONFFILE
echo "" >> $CONFFILE
echo '      proxy_set_header X-Real-IP $remote_addr;' >> $CONFFILE
echo '      proxy_set_header Host $host;' >> $CONFFILE
echo '      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' >> $CONFFILE
echo "" >> $CONFFILE
echo "      proxy_http_version 1.1;" >> $CONFFILE
echo "" >> $CONFFILE
echo "      proxy_set_header Upgrade \"websocket\";" >> $CONFFILE
echo "      proxy_set_header Connection \"Upgrade\";" >> $CONFFILE
echo "      proxy_read_timeout 86400;" >> $CONFFILE
echo "    }" >> $CONFFILE
# End

echo "  }" >> $CONFFILE
echo "}" >> $CONFFILE
echo "" >> $CONFFILE
echo "events{}" >> $CONFFILE

# Add default user with password
htpasswd -cb /etc/nginx/.htpasswd ${USERNAME} ${PASSWORD}

systemctl enable nginx
systemctl start nginx

echo "UserData Done."
reboot