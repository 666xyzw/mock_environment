# Sysadmin I and II Mock Environment

# Table of Content
1. [Structure](#structure)
2. [Setup](#setup)
3. [Connectivity](#connectivity)
4. [Installing Ansible](#ansible_install)
5. [Configuration Files](#config)
6. [Scripts](#scripts)

## Structure <a name="structure"></a>

The ansible scripts are separated in two categories, based on the books, so everything that belongs to the first book (rh124) it is put into the rh124 folder; everything that belongs to the second book (rh134) you will get it in the rh134 folder.

Usernames and passwords are exactly the same as in the books.
For the VMs to work correctly you will need a RedHat Developer account; if you already have a RedHat account joust login on the RedHat Developer page, if not you will have to create an account. The Developer account will be needed to register your machines to the RedHat environment, so you can have access to the repositories.

## Setup <a name="setup"></a>

The setup is made in such way, that it tries to simulate the lab environment as close as possible.

As for VM-s, you will need 5 machines:
    
1. **workstation**

    -> OS: RHEL9

    -> Server with GUI + System Tools + Security Tools
    
    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - 20GB, for OS\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdb - 5GB for labs/exercises\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdc - 5GB for labs/exercises

    -> Network:\
       &nbsp;&nbsp;&nbsp;&nbsp;1. NIC - for SSH/internet connectivity - must be on the same subnet as the rest of the machines\
       &nbsp;&nbsp;&nbsp;&nbsp;2. NIC - for networking exercises/labs

3. **servera**

    -> OS: RHEL9

    -> minial install + System Tools + Security Tools
    
    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - 20GB, for OS\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdb - 5GB for labs/exercises\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdc - 5GB for labs/exercises

    -> Network:\
       &nbsp;&nbsp;&nbsp;&nbsp;1. NIC - for SSH/internet connectivity - must be on the same subnet as the rest of the machines\
       &nbsp;&nbsp;&nbsp;&nbsp;2. NIC - for networking exercises/labs

4. **serverb**

    -> OS: RHEL9

    -> minimal install + System Tools + Security Tools

    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - 20GB, for OS\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdb - 5GB for labs/exercises\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdc - 5GB for labs/exercises

    -> Network:\
       &nbsp;&nbsp;&nbsp;&nbsp;1. NIC - for SSH/internet connectivity - must be on the same subnet as the rest of the machines\
       &nbsp;&nbsp;&nbsp;&nbsp;2. NIC - for networking exercises/labs

5. **PXE**

    -> OS: RHEL9

    -> minimal install + System Tools

    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - 50GB for OS + data
    
    -> Network:\
       &nbsp;&nbsp;&nbsp;&nbsp;1. NIC - for SSH/internet connectivity/serving repo for the Demo machine - must be on the same subnet as the rest of the machines
    -> it`s necessarry for the *Kickstart* lab

7. **Demo**

    -> OS: RHEL9

    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - 20GB for OS

    -> Network:\
       &nbsp;&nbsp;&nbsp;&nbsp;1) NIC - has to be on the same subnet az the *PXE* machine, so it can run the kickstart file
   
    -> it`s necessarry for the *Kickstart* lab; with this machine you can test if the kickstart file works as is should


When you install these machines, from the menu you have tol select the *System Tools* and *Security Tools* options.
To run the ansbile scripts, you have to install Ansible on the **workstation** machine.

## Connectivity <a name="connectivity"></a>

The connections from the **workstation** to the other machines is done via SSH; to make it as seamless as possible, generate an SSH key pair for the **student** user, the public key has to be copied to the other machines. The generated key has to be named *ansible*. This key will also be used by the Ansible scripts.

To generate an SSH key pair un the following command:

    [student@workstation ~]$ ssh-keygen -f ~/.ssh/ansible -N ""
 
 where:

 - -f -> name of the file that will contain the key, and will be saved into *~/.ssh* folder 
 - -N -> the keys password; if **""** is specified (alais nothing) then, the key won`t be password protected

 Ca noua cheie sa fie folosite de catre SSH, tot in *~/.ssh/* trebuie creat un fisier numit **config** care sa contina urmatoarele date:

    Host servera
            Hostname servera
            User student
            Port 22
            IdentityFile ~/.ssh/ansible

    Host serverb
            Hostname serverb
            User student
            Port 22
            IdentityFile ~/.ssh/ansible

Fisierul respectiv il gasiti si in repo, trebuie doar sa-o copiati in path-ul correct.

## Installing Ansible <a name="ansible_install"></a>

Pentru instalarea de Ansible pe **workstation** trebuie sa rulati urmatoarele comenzi:

    [root@workstation ~]# dnf install epel-release

    [root@workstation ~]# dnf install ansible

## Configuration Files <a name="config"></a>
Ca si configuratie, in primul rand trebuie populat fisierul "/etc/hosts" cu numele si IP-ul masinilor, ex.:

    [student@workstation ~]$ cat /etc/hosts
    127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
    
    192.168.56.122  workstation
    192.168.56.123  servera
    192.168.56.128  serverb


    [root@servera ~]# cat /etc/hosts
    127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
    
    192.168.56.122  workstation
    192.168.56.123  servera
    192.168.56.128  serverb

    [root@serverb ~]# cat /etc/hosts
    127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4

    192.168.56.122  workstation
    192.168.56.123  servera
    192.168.56.128  serverb

Acesta trebuie facut pe fiecare masina in parte, ca sa aiba interconnectivitate intre ei.

Dupa modificarea fisierului hosts, mai aveti nevoie de fisierul **.ansible.cfg**. Acesta se pune in folderul $HOME al user-ului **student** (/home/student/.ansible.cfg)

## Scripts <a name="scripts"></a>
    
Scripturile sunt de doua feluri:

1. start-*

    -> aceste scripturi pregatesc sistemul remote pentru laboratorul respectiv

2. finish-*

    -> aceste sripturi curata modificarile facute pe sistemul remote

In cazurile in care pentru un exercitiu/laborator nu exista script de **start**, doar script de **finish** inseamna ca masina remote nu trebuie pregatit in mod special pentru laborator/exercitiu.

Scripturile se ruleaza cu user-ul **student**, in urmatorul fel:
    
    [student@workstation ~]$ ansible-playbook script_name.yml -K

- -K -> interogheaza user-ul pentru parola "sudo", acesta este nevoie pentru Ansible, ca sa poata sa faca modificari pe sistemul remote

- optiunea de *-i* nu trebuie specificat, asa cum facem cand rulam scripturile pe serverele noastre, deoarece *inventory*-ul este specificat in fisierul de configuratie de Ansible 

Ex.:

    [student@workstation rh134]$ ansible-playbook start-netstorage-nfs.yml  -K
