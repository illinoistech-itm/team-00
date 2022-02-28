#!/bin/bash 
set -e
set -v

##################################################
# Add User customizations below here
##################################################

sudo apt-get install -y nginx firewalld

#git clone git@github.com:illinoistech-itm/team-00.git

su - vagrant -c "git clone git@github.com:illinoistech-itm/team-00.git"

# Enable http in the firewall
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --reload
