#!/bin/bash 
set -e
set -v

##################################################
# Add User customizations below here
##################################################

sudo apt-get install -y nginx firewalld

#################################################################################
# Change the value of XX to be your team GitHub Repo
# Otherwise your clone operation will fail
# The command: su - vagrant -c switches from root to the user vagrant to execute 
# the git clone command
##################################################################################
su - vagrant -c "git clone git@github.com:illinoistech-itm/team-00.git"

# Enable http in the firewall
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --reload
