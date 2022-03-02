#!/bin/bash 
set -e
set -v

#################################################################################
# Add User customizations below here
#################################################################################

sudo apt-get install -y nginx firewalld

#################################################################################
# Update /etc/hosts file
#################################################################################

echo "192.168.56.101     lb    lb.class.edu"    | sudo tee -a /etc/hosts
echo "192.168.56.102     ws1   ws1.class.edu"   | sudo tee -a /etc/hosts
echo "192.168.56.103     ws2   ws2.class.edu"   | sudo tee -a /etc/hosts
echo "192.168.56.104     ws3   ws3.class.edu"   | sudo tee -a /etc/hosts
echo "192.168.56.105     db    db.class.edu"    | sudo tee -a /etc/hosts

#################################################################################
# Set hostname
#################################################################################
sudo hostnamectl set-hostname lb

#################################################################################
# Change the value of XX to be your team GitHub Repo
# Otherwise your clone operation will fail
# The command: su - vagrant -c switches from root to the user vagrant to execute 
# the git clone command
##################################################################################
su - vagrant -c "git clone git@github.com:illinoistech-itm/team-00.git"

# Documentation for configuring load-balancing in Nginx
# https://nginx.org/en/docs/http/load_balancing.html
# https://stackoverflow.com/questions/10175812/how-to-create-a-self-signed-certificate-with-openssl
# https://ethitter.com/2016/05/generating-a-csr-with-san-at-the-command-line/

#################################################################################
# Create Self-signed cert request and key
#################################################################################
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048  -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=US/ST=IL/L=Chicago/O=IIT/OU=SAT/CN=class.edu"
sudo openssl dhparam -out /etc/nginx/dhparam.pem 2048

# Nginx configurations
# https://nginx.org/en/docs/beginners_guide.html
# https://dev.to/guimg/how-to-serve-nodejs-applications-with-nginx-on-a-raspberry-jld
sudo cp -v /home/vagrant/team-00/code/nginx/default /etc/nginx/sites-enabled
sudo cp -v /home/vagrant/team-00/code/nginx/nginx.conf /etc/nginx/

# Move the self-signed cert config into to nginx config
# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-18-04
sudo cp -v /home/vagrant/team-00/code/nginx/self-signed.conf /etc/nginx/snippets

sudo systemctl daemon-reload
sudo systemctl reload nginx
sudo systemctl restart nginx

# Enable http in the firewall
sudo firewall-cmd --zone=public --add-service=https --permanent
sudo firewall-cmd --reload
