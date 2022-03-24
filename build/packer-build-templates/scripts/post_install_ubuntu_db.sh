#!/bin/bash 
set -e
set -v

##################################################
# Add User customizations below here
##################################################

sudo apt-get install -y mariadb-server firewalld

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
sudo hostnamectl set-hostname db

#################################################################################
# Change the value of XX to be your team GitHub Repo
# Otherwise your clone operation will fail
# The command: su - vagrant -c switches from root to the user vagrant to execute 
# the git clone command
##################################################################################
su - vagrant -c "git clone git@github.com:illinoistech-itm/team-00.git"
cd team-00/code/
#################################################################################
# Linux systemd Firewall - firewalld https://firewalld.org/
# Remember to open proper firewall ports
#################################################################################
# Open firewall port for port 3306/tcp
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent 
# Open firewall port to allow only connections from 192.168.56.0/24
sudo firewall-cmd --zone=public --add-source=192.168.56.0/24 --permanent
# Reload changes to firewall
sudo firewall-cmd --reload

# Changing the mysql bind address with a script to listen for external connections
# https://serverfault.com/questions/584607/changing-the-mysql-bind-address-within-a-script
# https://stackoverflow.com/questions/23670282/bind-address-missing-in-my-cnf-in-mysql-centos
# https://en.wikipedia.org/wiki/Sed
# https://devopscube.com/setup-mysql-master-slave-replication/
# Don't leave off the final "/" in a sed expression--they need to be closed
# If using mysql instead of MariaDB the path to the cnf file is /etc/mysql/mysql.conf.d/mysql.cnf
# sudo sed -i "s/.*bind-address.*/#bind-address = $(hostname -I | awk '{print $2}')/" /etc/mysql/mysql.conf.d/mysql.cnf
sudo sed -i "s/.*bind-address.*/bind-address = $(hostname -I | awk '{print $2}')/" /etc/mysql/mariadb.conf.d/50-server.cnf

#################################################################################
# To execute .sql files to create tables, databases, and insert records
# Modern versions of mariadb and mysql don't have a root password for the root 
# user they control access via sudo permissions... which is great for security
# and automation
# These next 4 lines will create a simple database, a table, a non-root user
# with limited permissions (adjust accordingly) and finally insert 3 dummy records
#################################################################################

#################################################################################
# Using sed to replace placeholder variables in the scripts in the scripts 
# with the USER variables passed from PACKER
#################################################################################
sed -i "s/\$ACCESSFROMIP/$ACCESSFROMIP/g" ./db-samples/*.sql
sed -i "s/\$USERPASS/$USERPASS/g" ./db-samples/*.sql
sed -i "s/\$USERNAME/$USENAME/g" ./db-samples/*.sql

sudo mysql < /home/vagrant/team-00/code/db-samples/create-database.sql
sudo mysql < /home/vagrant/team-00/code/db-samples/create-table.sql
sudo mysql < /home/vagrant/team-00/code/db-samples/create-user-with-permissions.sql
sudo mysql < /home/vagrant/team-00/code/db-samples/insert-records.sql