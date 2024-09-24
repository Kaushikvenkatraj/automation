#! /bin/bash

# Update & Upgrade the server
sudo yum update -y
sudo yum upgrade -y

# Add nodejs from binary archive
wget https://nodejs.org/dist/v20.11.0/node-v20.11.0-linux-x64.tar.gz

# Unzip the directory and add it to the executable path
sudo mkdir -p /usr/local/lib/nodejs
tar -xvf node-v20.11.0-linux-x64.tar.gz 
sudo mv node-v20.11.0-linux-x64 /usr/local/lib/nodejs/

# Add the details to .bash_profile
echo "VERSION=v20.11.0" >> ~/.bash_profile
echo "DISTRO=linux-x64" >> ~/.bash_profile
echo "export PATH=/usr/local/lib/nodejs/node-v20.11.0-linux-x64/bin:\$PATH" >> ~/.bash_profile

# Immediately export variables within the script
export VERSION=v20.11.0
export DISTRO=linux-x64
export PATH=/usr/local/lib/nodejs/node-v20.11.0-linux-x64/bin:$PATH

source ~/.bash_profile

# Confirm Node.js installation
node -v
npm -v

echo "Nodejs environment variables added and profile refreshed."

# Add nginx web proxy server

sudo yum install yum-utils -y

# Define the content for the nginx.repo file
NGINX_REPO_CONTENT="[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/amzn2/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
priority=9

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/amzn2/\$releasever/\$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
priority=9
"

# Create the nginx.repo file with the specified content
echo "$NGINX_REPO_CONTENT" | sudo tee /etc/yum.repos.d/nginx.repo > /dev/null

echo "nginx.repo file created successfully."

sudo yum-config-manager --enable nginx-mainline -y
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo yum install python3-certbot-nginx -y
sudo systemctl restart nginx
