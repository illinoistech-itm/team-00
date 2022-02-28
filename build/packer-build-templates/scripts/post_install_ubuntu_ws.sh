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

git clone git@github.com:illinoistech-itm/team-00.git

# Enable http in the firewall
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --reload
