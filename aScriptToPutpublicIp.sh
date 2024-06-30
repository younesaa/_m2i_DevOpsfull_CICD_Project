#!/bin/bash

# Get the public IP from Terraform output
public_ip=$(terraform output -raw public_ip)

# Create the Ansible inventory file
cat <<EOL > hosts
[all]
vm_azure ansible_ssh_host=$public_ip ansible_ssh_user=testadmin
EOL