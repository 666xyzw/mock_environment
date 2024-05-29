#!/bin/bash

# ----------------------------- #
# Getting the IP Addresses      #
# ----------------------------- #
echo -n "Give Workstation IP Address"
read -r workstationip

echo -n "Give servera IP Address"
read -r serveraip

echo -n "Give serverb IP Address"
read -r serverbip

# ----------------------------- #
# Configuring /etc/hosts File   #
# ----------------------------- #
echo "${workstationip} workstation.example.lab.com workstation" >> /etc/hosts
echo "${serveraip} servera.example.lab.com servera" >> /etc/hosts
echo "${serverbip} serverb.example.lab.com servera" >> /etc/hosts

# ----------------------------- #
# Create SSH Key for Ansible    #
# ----------------------------- #
echo "Generating SSH Key"

ssh-keygen -f ~/.ssh/ansible_key -N ""

# ----------------------------- #
# Deploy SSH Key for Ansible    #
# ----------------------------- #
echo "Deploying SSH Key to Servers"

ssh-copy-id -i ~/.ssh/ansible_key.pub student@servera; ssh-copy-id -i ~/.ssh/ansible_key.pub student@serverb

# ----------------------------- #
# Configuring SSH config File   #
# ----------------------------- #
echo "Creating SSH Configuration File"

if [[ -f ~/.ssh/config ]];
then
    cat ./config >> ~/.ssh/config
else
    mv ./config ~/.ssh/config
fi

# ------------------------------- #
# Deploy /etc/hosts Configuration #
# ------------------------------- #
echo "Deploying /etc/hosts Configuration to Remote Machines"
for machine in servera serverb
do
    ssh student@${machine} sudo echo "${workstationip} workstation.example.lab.com workstation" >> /etc/hosts
    ssh student@${machine} sudo echo "${serveraip} servera.example.lab.com servera" >> /etc/hosts
    ssh student@${machine} sudo echo "${serverbip} serverb.example.lab.com servera" >> /etc/hosts
done

# ------------------------------- #
# Installing Ansible              #
# ------------------------------- #
echo "Installing Ansible on workstation"
dnf install -y epel-release
dnf install -y ansible

# ------------------------------- #
# Configuring Ansible Environment #
# ------------------------------- #
mv {.ansible.cfg,inventory} ~/
