# Sysadmin I and II Mock Environment

# Table of Content
1. [Structure](#structure)
2. [Setup](#setup)
3. [Connectivity](#connectivity)
4. [Ansible Scripts](#ansible_scripts)
5. [The setup.sh Script](#setup_script)

## Structure <a name="structure"></a>

The ansible scripts are separated in two categories, based on the books, meaning that everything that belongs to the first book (rh124) can be found in the rh124 folder; everything that belongs to the second book (rh134) can be found in the rh134 folder.

Usernames and passwords are exactly the same as in the books.
For the VMs to work correctly you will need a free RedHat Developer account; if you already have a RedHat account just login on the RedHat Developer page; if not, you will have to create a new account. The Developer account will be needed to register your machines to the RedHat environment, for free, so you can have access to the repositories.

## Setup <a name="setup"></a>

The setup is made in such way, that it tries to simulate the lab environment as close as possible.

As for VM-s, you will need 5 machines:
    
1. **workstation**

    -> OS: RHEL9 ( Server with GUI + System Tools + Security Tools )

    -> CPU: 4 vCPU

    -> RAM: 3 GB
   
    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - 30GB, for OS\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdb - 5GB for labs/exercises\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdc - 5GB for labs/exercises

    -> Network:\
       &nbsp;&nbsp;&nbsp;&nbsp;1. NIC - for SSH/internet connectivity - must be on the same subnet as the rest of the machines\
       &nbsp;&nbsp;&nbsp;&nbsp;2. NIC - for networking exercises/labs

3. **servera**

    -> OS: RHEL9 ( minimal install + System Tools + Security Tools )

    -> CPU: 3 vCPU

    -> RAM: 3 GB
   
    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - 20GB, for OS\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdb - 5GB for labs/exercises\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdc - 5GB for labs/exercises

    -> Network:\
       &nbsp;&nbsp;&nbsp;&nbsp;1. NIC - for SSH/internet connectivity - must be on the same subnet as the rest of the machines\
       &nbsp;&nbsp;&nbsp;&nbsp;2. NIC - for networking exercises/labs

5. **serverb**

    -> OS: RHEL9 ( minimal install + System Tools + Security Tools )

    -> CPU: 3 vCPU

    -> RAM: 3 GB
   
    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - 20GB, for OS\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdb - 5GB for labs/exercises\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdc - 5GB for labs/exercises

    -> Network:\
       &nbsp;&nbsp;&nbsp;&nbsp;1. NIC - for SSH/internet connectivity - must be on the same subnet as the rest of the machines\
       &nbsp;&nbsp;&nbsp;&nbsp;2. NIC - for networking exercises/labs

6. **PXE**

    -> OS: RHEL9 ( minimal install + System Tools + Apache/Nginx )

    -> CPU: 2 vCPU

    -> RAM: 2 GB
   
    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - 50GB for OS + data
    
    -> Network:\
       &nbsp;&nbsp;&nbsp;&nbsp;1. NIC - for SSH/internet connectivity/serving repo for the Demo machine - must be on the same subnet as the rest of the machines
    -> it`s necessarry for the *Kickstart* lab

7. **Demo**

    -> OS: RHEL9

    -> CPU: 1 vCPU

    -> RAM: 2 GB
   
    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - 20GB for OS

    -> Network:\
       &nbsp;&nbsp;&nbsp;&nbsp;1) NIC - has to be on the same subnet az the *PXE* machine, so it can run the kickstart file
   
    -> it`s necessarry for the *Kickstart* lab; with this machine you can test if the kickstart file works as is should


## Connectivity <a name="connectivity"></a>

The connections from the **workstation** to the other machines is done via SSH; to make it as seamless as possible, you will need an SSH key pair for the **student** user; the public key has to be copied to the other machines. The key pair is generated and copied to the remote machines by the **setup.sh** shell script.


## Ansible Scripts <a name="ansible_scripts"></a>

To run the ansbile scripts, you will need Ansible on the **workstation** machine. Ansible is installed automatically by the **setup.sh** shell script.

There are two type of scripts:
1. start-*
   
    -> these prepare the remote machine for the respective exercise/lab

3. finish-*

    -> these clean up the remote system after you are done with the exercise/lab

In case you do not see a *start-\**/*finish-\** script for an exercise/lab it means that that remote machine does not need to be prepared or cleaned after the exercise/lab.

The scripts **must** be run as the **student** user:
    
    # ansible-playbook script_name.yml -K

- -K -> flag means that Ansible will interogate the user for the *sudo* password, this will be needed to run commands on the remote machine as the root user


## The setup.sh Script <a name="setup_script"></a>

The **setup.sh** shell script will configure the environment, meaning:\

- configure the */etc/hosts* file, on the workstation and also on the remove machines\
- generate the SSH key pair and deploy the public key on the remote machines\
- install Ansible on the *workstaion*\
- move the Ansible configuration files to their location

To run the script enter the following in the terminal (make sure you are int the *mock_environment* folder):

    # sh ./setup.sh
