# EX200-Stuff

# Cuprins
1. [Structura](#structura)
2. [Setup](#setup)
3. [Connectivitate](#connectivitate)
4. [Instalare Ansible](#ansible_install)
5. [Fisiere de configuratie](#config)
6. [Scripturi](#scripts)

## Structura <a name="structura"></a>

Scripturile de ansible sunt impartine pe baza celor daua carti, adica: tot ce apartine de prima carte (rh124) se gaseste in folderul rh124; tot ce apartine de a doua carte (rh134) se gasete in folderul rh134.

## Setup <a name="setup"></a>

Setup-ul este setat in felul in care sa simuleze cat mai bine laboratoarele de RHEL.

Ca si masini, o sa aveti nevoie de 5 VM-uri:
    
1. **workstation**

    -> OS: OEL9/RHEL9

    -> Server with GUI + System Tools + Security Tools
    
    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - macar de 20GB, pentru OS\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdb - de 5GB pentru exercitii/lab-uri\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdc - de 5GB pentru exercitii/lab-uri

    -> Network: pe acelasi sub-net ca si restul masinilor

2. **servera**

    -> OS: OEL9/RHEL9

    -> minial install + System Tools + Security Tools
    
    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - macar de 20GB, pentru OS\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdb - de 5GB pentru exercitii/lab-uri\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdc - de 5GB pentru exercitii/lab-uri
    
    -> Network: pe acelasi sub-net ca si restul masinilor

3. **serverb**

    -> OS: OEL9/RHEL9

    -> minimal install + System Tools + Security Tools

    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - macar de 20GB, pentru OS\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdb - de 5GB pentru exercitii/lab-uri\        
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sdc - de 5GB pentru exercitii/lab-uri
    
    -> Network: pe acelasi sub-net ca si restul masinilor


4. **PXE**

    -> OS: OEL9/RHEL9

    -> minimal install + System Tools

    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - macar de 50GB, pentru OS\
    
    -> Network: pe acelasi sub-net ca si restul masinilor
    -> este necesar pentru laboratorul de Kickstart; aceasta masina va pune la dispozitie pachetele de *BaseOS* si *AppStream*

5. **Demo**

    -> OS: OEL9/RHEL9

    -> Disks:\
        &nbsp;&nbsp;&nbsp;&nbsp;- /dev/sda - de 20GB, pentru OS
    
    -> este necesar pentru laboratorul de Kickstart; aceasta masina se va instala singur prin fisierul de kickstart


Aceste masini trebuie sa dispuna de user-ul standard **student**, cu parola *student* si user **root** cu parola *redhat*.

*Daca va hotarati sa instalati masini de RHEL9, atunci o sa aveti nevoie de un cont RHEL Developer, cont gratis prin care se pot obtine ISO-urile de RHEL + subscriptia la repo-uri; Momentan RedHat da 16 licente gratis pe un cont de developer prin care aveti access la toate repo-urile lor; Daca aveti deja cont de RedHat, atunci contul de Developer trebuie doar activat prin logare in platforma cu credentialele de RedHat.*

La instalarea acestor masini, din meniu, trebuie se selectati si optiunile de System Tools si Security Tools (aici trebuie instalat separat si *setroubleshoot* ca SELinux sa scrie erroriile si in */var/log/messages*), de ultima va fii nevoie pentru laboratoarele cu SELinux.

In cazul in care o comanda nu functioneaza deoarece binarul nu se gaseste pe sistem, se ruleaza comanda:
    
    [root@workstation ~]$ dnf whatprovides binary_name

Ex.:

    [root@workstation ~]# dnf whatprovides semanage
    Last metadata expiration check: 1:28:34 ago on Tue 06 Feb 2024 09:46:06 AM EET.
    policycoreutils-python-utils-3.3-6.el9_0.noarch : SELinux policy core python utilities
    Repo        : ol9_appstream
    Matched from:
    Filename    : /usr/sbin/semanage

    policycoreutils-python-utils-3.4-4.el9.noarch : SELinux policy core python utilities
    Repo        : ol9_appstream
    Matched from:
    Filename    : /usr/sbin/semanage

    policycoreutils-python-utils-3.5-1.el9.noarch : SELinux policy core python utilities
    Repo        : @System
    Matched from:
    Filename    : /usr/sbin/semanage

    policycoreutils-python-utils-3.5-1.el9.noarch : SELinux policy core python utilities
    Repo        : ol9_appstream
    Matched from:
    Filename    : /usr/sbin/semanage

    policycoreutils-python-utils-3.5-2.el9.noarch : SELinux policy core python utilities
    Repo        : ol9_appstream
    Matched from:
    Filename    : /usr/sbin/semanage

    policycoreutils-python-utils-3.5-3.el9_3.noarch : SELinux policy core python utilities
    Repo        : ol9_appstream
    Matched from:
    Filename    : /usr/sbin/semanage

dupa care se instaleaza pachetul care este returnat de catre dnf

    [root@workstation ~]# dnf install policycoreutils-python-utils-3.3-6.el9_0 -y

Pentru simularea scripturilor de start/finish din laboratoarele din carti, este nevoie sa instalati Ansible pe **workstation**.

## Connectivitate <a name="connectivitate"></a>

De la **workstation** catre celelalte doua masini connexiunea se face prin SSH; trebuie sa generati o cheie standard SSH, pentru user-ul **student**, care trebuie copiat pe restul masinilor (**servera**, **serverb**). Cheia generata trebuie sa se numeasca *ansible*.
Aceasta cheie va fii folosit si de catre Ansible.

Generarea cheii se face in urmatorul fel:

    [student@workstation ~]$ ssh-keygen -f ~/.ssh/ansible -N ""
 
 unde:

 - -f -> numele cheii care se va genera in folderul de .ssh de pe sistem
 - -N -> parola cheii; daca se specifica **""** inseamna ca cheia SSH nu este protejat cu parola

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

## Instalare Ansible <a name="ansible_install"></a>

Pentru instalarea de Ansible pe **workstation** trebuie sa rulati urmatoarele comenzi:

    [root@workstation ~]# dnf install epel-release

    [root@workstation ~]# dnf install ansible

## Fisiere de configuratie <a name="config"></a>
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

## Scripturi <a name="scripts"></a>
    
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
