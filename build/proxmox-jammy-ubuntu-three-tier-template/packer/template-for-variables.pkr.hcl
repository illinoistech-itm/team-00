//  variables.pkr.hcl

// For those variables that you don't provide a default for, you must
// set them from the command line, a var-file, or the environment.

# This is the name of the node in the Cloud Cluster where to deploy the virtual instances
locals {
  NODENAME = vault("/secret/data/team00-NODENAME","NODENAME3")
}

locals {
  USERNAME = vault("/secret/data/team00-username-packer-system","USERNAME")
}

locals {
  PROXMOX_TOKEN = vault("/secret/data/team00-token-packer-system","TOKEN")
}

locals {
  URL = vault("/secret/data/team00-url","SYSTEM41")
}

locals {
  SSHPW = vault("/secret/data/team00-ssh","SSHPASS")
}

variable "MEMORY" {
  type    = string
  default = "4096"
}

# Best to keep this low -- you can expand the size of a disk when deploying 
# instances from templates - but not reduce the disk size -- No need to edit this
variable "DISKSIZE" {
  type    = string
  default = "25G"
}

# This is the name of the disk the build template will be stored on in the 
# Proxmox cloud -- No need to edit this

# Define a list of values
my_list = ["datadisk4", "datadisk3", "datadisk2", "datadisk1"]

# Get a random value from the list
# random_value = random.choice(my_list)

# Use the random value in your Packer template
# For example:
# some_key = "${random_value}"

# Note: Make sure to import the 'random' module at the beginning of your HCL file.


variable "STORAGEPOOL" {
  type    = string
  default = random.choice(my_list)
}

variable "NUMBEROFCORES" {
  type    = string
  default = "1"
}

# This is the name of the Virtual Machine Template you want to create
variable "frontend-VMNAME" {
  type    = string
  default = "team00-fe"
}

# This is the name of the Virtual Machine Template you want to create
variable "backend-VMNAME" {
  type    = string
  default = "team00-be"
}

# This is the name of the Virtual Machine Template you want to create
variable "loadbalancer-VMNAME" {
  type    = string
  default = "team00-lb"
}

variable "iso_checksum" {
  type    = string
  default = "file:https://mirrors.edge.kernel.org/ubuntu-releases/22.04.4/SHA256SUMS"
}

variable "iso_urls" {
  type    = list(string)
  default = ["http://mirrors.edge.kernel.org/ubuntu-releases/22.04.4/ubuntu-22.04.4-live-server-amd64.iso"]
}

# This will be the non-root user account name
variable "DBUSER" {
  type      = string
  sensitive = true
  default   = "controller"
}

# This will be the Database user (non-root) password setup
variable "DBPASS" {
  type      = string
  sensitive = true
  default   = "wonders"
}

# This variable is the IP address range to allow your connections
variable "CONNECTIONFROMIPRANGE" {
  type      = string
  sensitive = true
  default   = "10.110.%.%"
}

# This will be the fully qualified domain name team-00-be-vm0.service.consul
variable "FQDN" {
  type      = string
  sensitive = true
  default   = "team00-be-vm0.service.consul"
}

# This will be the Database name you default to (like posts or comments or customers)
variable "DATABASE" {
  type      = string
  sensitive = true
  default   = "posts"
}
