#!/bin/bash

echo "# ----------------------------- #"
echo "# Getting the IP Addresses      #"
echo "# ----------------------------- #"
echo ""
echo -n "Give Workstation IP Address"
read -r workstationip

echo -n "Give servera IP Address"
read -r serveraip

echo -n "Give serverb IP Address"
read -r serverbip

echo "# ----------------------------- #"
echo "# Configuring /etc/hosts File   #"
echo "# ----------------------------- #"
echo ""
echo "${workstationip} workstation.example.lab.com workstation" >> /etc/hosts
echo "${serveraip} servera.example.lab.com servera" >> /etc/hosts
echo "${serverbip} serverb.example.lab.com servera" >> /etc/hosts

echo "# ----------------------------- #"
echo "# Create SSH Key for Ansible    #"
echo "# ----------------------------- #"
echo ""
ssh-keygen -f ~/.ssh/ansible_key -N ""

echo "# ----------------------------- #"
echo "# Deploying SSH Key to Remote   #"
echo "# ----------------------------- #"
echo ""
ssh-copy-id -i ~/.ssh/ansible_key.pub student@servera; ssh-copy-id -i ~/.ssh/ansible_key.pub student@serverb

echo "# ----------------------------- #"
echo "# Configuring SSH config File   #"
echo "# ----------------------------- #"
echo ""
if [[ -f ~/.ssh/config ]];
then
    cat ./config >> ~/.ssh/config
else
    mv ./config ~/.ssh/config
fi

echo "# ---------------------------------- #"
echo "# Deploying /etc/hosts Configuration #"
echo "# ---------------------------------- #"
echo ""
for machine in servera serverb
do
    ssh student@${machine} sudo echo "${workstationip} workstation.example.lab.com workstation" >> /etc/hosts
    ssh student@${machine} sudo echo "${serveraip} servera.example.lab.com servera" >> /etc/hosts
    ssh student@${machine} sudo echo "${serverbip} serverb.example.lab.com servera" >> /etc/hosts
done

echo "# --------------------------------- #"
echo "# Installing Ansible on workstation #"
echo" # --------------------------------- #"
echo ""
dnf install -y epel-release && dnf install -y ansible

echo "# ------------------------------- #"
echo "# Configuring Ansible Environment #"
echo "# ------------------------------- #"
mv {.ansible.cfg,inventory} ~/
