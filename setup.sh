#!/bin/bash

echo "# ----------------------------- #"
echo "# Getting the IP Addresses      #"
echo "# ----------------------------- #"
echo ""
echo -n "Give workstation IP Address"
read -r workstationip

echo -n "Give servera IP Address"
read -r serveraip

echo -n "Give serverb IP Address"
read -r serverbip

echo "# ----------------------------------- #"
echo "# Configuring local /etc/hosts File   #"
echo "# ----------------------------------- #"
echo ""
echo "${workstationip} workstation" | sudo tee -a /etc/hosts > /dev/null
echo "${serveraip} servera" | sudo tee -a /etc/hosts > /dev/null
echo "${serverbip} serverb" | sudo tee -a /etc/hosts > /dev/null

echo "# ----------------------------- #"
echo "# Create SSH Key for Ansible    #"
echo "# ----------------------------- #"
echo ""
ssh-keygen -f ~/.ssh/ansible_key -N ""

echo "# ------------------------------------- #"
echo "# Deploying SSH Key to Remote Machines  #"
echo "# ------------------------------------- #"
echo ""
ssh-copy-id -i ~/.ssh/ansible_key.pub student@servera; ssh-copy-id -i ~/.ssh/ansible_key.pub student@serverb

echo "# ----------------------------- #"
echo "# Configuring SSH config File   #"
echo "# ----------------------------- #"
echo ""
cat >> ~/.ssh/config<<EOF
Host servera
    Hostname servera
    User student
    Port 22
    IdentityFile ~/.ssh/ansible_key

Host serverb
    Hostname serverb
    User student
    Port 22
    IdentityFile ~/.ssh/ansible_key
EOF

echo "# ---------------------------------- #"
echo "# Deploying /etc/hosts Configuration #"
echo "# ---------------------------------- #"
echo ""
for machine in servera serverb
do
    ssh -t student@${machine} "echo '${workstationip} workstation' | sudo tee -a /etc/hosts > /dev/null"
    ssh -t student@${machine} "echo '${serveraip} servera' | sudo tee -a /etc/hosts > /dev/null"
    ssh -t student@${machine} "echo '${serverbip} serverb' | sudo tee -a /etc/hosts > /dev/null"
done

echo "# --------------------------------- #"
echo "# Installing Ansible on workstation #"
echo" # --------------------------------- #"
echo ""
sudo dnf install -y ansible-core

echo "# ------------------------------- #"
echo "# Configuring Ansible Environment #"
echo "# ------------------------------- #"
mv {.ansible.cfg,inventory} ~/