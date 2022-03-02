#!/bin/bash 
set -e
set -v

##################################################
# Add User customizations below here
##################################################

sudo apt-get install -y nginx firewalld

###################################################
# Example how to install NodeJS
###################################################
# https://nodejs.org/en/download/
# https://github.com/nodesource/distributions/blob/master/README.md
# Using Ubuntu
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

su - vagrant -c "git clone git@github.com:illinoistech-itm/team-00.git"
cd ./team-00/code/express-static-app

# This will use the package.json files to install all the applcation 
# needed packages and upgrade npm
sudo npm install -y
sudo npm install -g npm@8.5.2

# This will install pm2 - a javascript process manager -- like systemd for 
# starting and stopping javascript applciations
# https://pm2.io/
sudo npm install pm2 -g 

# Command to create a service handler and start that javascript app at boot time
pm2 startup
# The pm2 startup command generates this command
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u vagrant --hp /home/vagrant
pm2 start server.js
pm2 save

# Enable http in the firewall
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --reload
