# AROS


<!--## Terraform
<div>
  <img align="center" width="100%" src="docs/1-ReadMe_Images/2-1-Terraform.png" alt="Terraform is used for provisioning the basic infrastructure of any given scenario" title="Terraform is used for provisioning the basic infrastructure of any given scenario">
</div>

## Ansible
<div>
  <img align="center" width="100%" src="docs/1-ReadMe_Images/2-2-Ansible.png" alt="Ansible is used for the automatic configuration of the instances that were created during the terraform stage" title="Ansible is used for the automatic configuration of the instances that were created during the terraform stage">
</div>-->

# Quickstart


# Installation

ToDo: install cyberrange itself
ToDo: install terraform and ansible
ToDo: install requirements



# Deployment
The usage of the AROS requires a running OpenStack instance.

```
scp -r . cyberrange-copy:/home/iai/attack_range_openstack
ssh cyberrange-copy
cd attack_range_openstack
cd 1_resource_generation
terraform apply
```

This will build the openstack provisioned infrastructure as it is defined in terraform. You need it to finish without errors to get the floating IP of proxy which is required for the next steps.


Reset your known hosts:
```
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.12"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.14"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.15"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.16"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.17"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.18"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.20"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.12"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.18"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.15"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.14"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.16"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.17"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.4.97"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.5.64"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.6.42"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.1.3.179"
```

Setup proxy and all hosts that can be reached with ssh via proxy:
```
ansible-playbook -l 'proxy,' playbooks/access_proxy.yml
ansible-playbook -l 'proxy,' playbooks/make_ansible_controller.yml

ansible-playbook -l 'IT-Linux-PC-1,aggregation_server,' playbooks/linux.yml
ansible-playbook -l 'aggregation_server,' playbooks/aggregation_server.yml
ansible-playbook -l 'IT-Linux-PC-1,' playbooks/linux_workstation.yml
ansible-playbook -l 'APT-C2-Server,APT-Outside-Attacker,' playbooks/kali.yml
```


Then login to each Windows host via ssh and execute:
```
echo 'start winrm setup' > C:\winrm_log2.txt
echo 'quickconfig:' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
powershell winrm quickconfig >> C:\winrm_log2.txt
echo 'winrs shell memory:' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"} >> C:\winrm_log2.txt
echo 'winrs timeout: >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
winrm set winrm/config @{MaxTimeoutms="1800000"} >> C:\\winrm_log2.txt
echo 'allow unencrypted: ' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
winrm set winrm/config/service @{AllowUnencrypted="true"} >> C:\\winrm_log2.txt
echo 'basic auth:' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
winrm set winrm/config/service/auth @{Basic="true"} >> C:\\winrm_log2.txt
net stop winrm
echo 'autostart:' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
powershell Set-Service -Name winrm -StartupType Automatic >> C:\\winrm_log2.txt
net start winrm 
echo 'enable ps remoting' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force" >> C:\\winrm_log2.txt
echo 'enumerate:' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
winrm enumerate winrm/config/Listener >> C:\\winrm_log2.txt
ssh-keygen
```


Then ssh to proxy:
```
ssh -A debian@10.1.3.179
export LC_ALL="C.UTF-8";

ansible-playbook -l 'IT-Win-Share,IT-Win-PC-1,OT-Win-PC-1,' playbooks/windows.yml
ansible-playbook -l 'OT-PLC-Linux,OT-HMI-Linux,' playbooks/linux.yml
ansible-playbook -l 'IT-Win-Share,IT-Win-PC-1', playbooks/vulnerabilities.yml
ansible-playbook -l 'IT-Win-Share,' playbooks/windows_server.yml
ansible-playbook -l 'IT-Win-Share,' playbooks/windows_fileshare.yml
ansible-playbook -l 'IT-Win-PC-1,' playbooks/windows_workstation.yml
ansible-playbook -l 'OT-PLC-Linux,' playbooks/plc_debian.yml
ansible-playbook -l 'OT-HMI-Linux,' playbooks/hmi_debian.yml
```

After everything is set up, you can start and stop auditing from proxy with
```
ansible-playbook -l 'IT-Win-PC-1,IT-Win-Share,OT-PLC-Linux,OT-HMI-Linux,IT-Linux-PC-1,aggregation_server' playbooks/start_audit.yml
ansible-playbook -l 'IT-Win-PC-1,IT-Win-Share,OT-PLC-Linux,OT-HMI-Linux,IT-Linux-PC-1,aggregation_server' playbooks/stop_audit.yml
```



# Data collection


## Audit logging
ToDo: Sysmon, auditd, Win Security


## Dataset structure

ToDo

<!-- Ideally the Ansible playbooks are already executable from within the terraform stage. If this is not the case, cd into 2_ansible_resource_provisioning/ and execute the selected playbooks from there. -->


<!--## Working with the Infrastructure

<div>
  <img align="center" width="100%" src="docs/2-Topology/Network_max.png" alt="A big maximum resource usage network">
</div>



## Data collection

elk beats
raw log data
wireshark

## Dataset

<div>
  <img align="center" width="100%" src="docs/2-Topology/Struktur_Dataset.png" alt="The dataset Architecture">
</div>-->



## Troubleshooting

### Flavor ID not known

Terraform has not created the custom flavors yet and so does not know them. A possible solution is to change back to flavor_name, use m1.medium or so, execute terraform apply and change back to the custom terraform ids.

### terraform destroy does not clean up everything

if terraform destroy does not clean up everything

delete all instances in openstack
delete all routers
delete all remaining floating IPs
delete ports in all networks
delete all networks but not public


### Terraform encounters countless of errors out of the blue

Your terraform state/save file might be corrupted. Rename it and re-run.
The cause for this is a mismatch between terraform operations and tasks done in Openstack. If actions in Openstack lead to a (minor/significant?) difference, the system state is no longer accurately depicted by the tfstate file and therefore terraform is confused. Never do this. For example never touch the plubic network

```
cd /home/iai/attack_range_openstack/1_resource_generation
mv terraform.tfstate terraform.tfstate.old
mv terraform.tfstate.backup terraform.tfstate.backup.old
```


### I accidentally deleted network public

<!--Much desaster, now you have to re-install Openstack. Save your OS images and metadata and re-run the install script.

```
#!/bin/bash

image_path=/home/iai/attack_range_openstack/0_image_generation/
cd "$image_path"
mkdir save
cd save

if [ -f Metadata.txt ]
then
  echo "" > Metadata.txt
else 
  touch Metadata.txt
fi

IFS=$'\n'
images=( $(glance image-list | head -n -1 | tail -n +4 | sed 's/|//g' | awk '{$1=$1};1') )

for image in "${images[@]}"
do
  id=$(echo $image | cut -c1-36)
  name=$(echo $image | cut -d " " -f 2- | sed 's/ /_/g')
  glance image-download --file ./$name.img $id
  glance image-show $id >> Metadata.txt
  echo "" >> Metadata.txt
done

unset IFS


sudo -i
source kolla-ansible-venv/bin/activate

docker stop $(docker ps -a -q)
docker kill $(docker ps -a -q)

#search quemu process and kill it
ps aux | grep qemu

kolla-ansible -i all-in-one destroy

cd /etc/kolla
mv globals.yml globals_old.yml
cp ~/kolla-ansible-venv/share/kolla-ansible/etc_examples/kolla/globals.yml .
diff globals_old.yml globals.yml
vim globals.yml

kolla-ansible -i all-in-one deploy
kolla-ansible -i all-in-one post-deploy


cd "$image_path/save/"

for file in *.img 
do
  glance image-create --name ${file%.*} --disk-format qcow2 --container-format bare --file $file --visibility private --progress
done





openstack network create --share --external --provider-physical-network physnet1 --provider-network-type flat public

#/etc/kolla/neutron-server/ml2_conf.ini ->
#[ml2_type_flat]
#flat_networks = physnet1

openstack subnet create --network public --subnet-range 10.0.0.0/24 --allocation-pool start=10.0.0.2,end=10.0.0.254 --dns-nameserver 127.0.0.53 --gateway 10.0.0.1 public







kolla-ansible -i all-in-one genconfig
kolla-ansible -i all-in-one reconfigure


```-->

Follow the last steps on how to re-install openstack. Check the init demo setup, modify them to generate the correct IP adresses and run the init demo script. Afterwards a new public network should be spawned. You wil need to modify the network name and router ID in your terraform code tough. 




### Re-Installing OpenStack using kolla-ansible

0. save your images and Metadata
1. delete all docker containers and volumes
2. reboot


```
#!/bin/bash

image_path=/home/iai/attack_range_openstack/0_image_generation/
cd "$image_path"
mkdir save
cd save

if [ -f Metadata.txt ]
then
  echo "" > Metadata.txt
else 
  touch Metadata.txt
fi

IFS=$'\n'
images=( $(glance image-list | head -n -1 | tail -n +4 | sed 's/|//g' | awk '{$1=$1};1') )

for image in "${images[@]}"
do
  id=$(echo $image | cut -c1-36)
  name=$(echo $image | cut -d " " -f 2- | sed 's/ /_/g')
  glance image-download --file ./$name.img $id
  glance image-show $id >> Metadata.txt
  echo "" >> Metadata.txt
done

unset IFS
```



kolla-ansible venv aktivieren:
```
sudo -i
source kolla-ansible-venv/bin/activate
```

kolla-ansible updaten:
```
pip install git+https://opendev.org/openstack/kolla-ansible@18.2.0
```

ansible updaten:
```
pip install 'ansible-core>=2.15,<2.16.99'
```

config globals.yml anpassen:
```
cd /etc/kolla
mv globals.yml globals_old.yml
cp ~/kolla-ansible-venv/share/kolla-ansible/etc_examples/kolla/globals.yml .
diff globals_old.yml globals.yml
vim globals.yml
```

kolla-ansible setup:
```
cd ~
cp kolla-ansible-venv/share/kolla-ansible/ansible/inventory/all-in-one .
kolla-ansible -i all-in-one genconfig
# failed=0
kolla-ansible install-deps
# wieso nicht auch passwörter reseten?
cp ~/kolla-ansible-venv/share/kolla-ansible/etc_examples/kolla/passwords.yml /etc/kolla
kolla-genpwd
#kolla-ansible -i ./all-in-one bootstrap-servers
## pip install dbus-python ist fehlgeschlagen aufgrund fehlender dev-Packete:
apt install build-essential
apt install libdbus-1-dev libglib2.0-dev
apt install pkg-config
kolla-ansible -i ./all-in-one bootstrap-servers
# failed=0
kolla-ansible -i ./all-in-one prechecks
# failed=0
kolla-ansible -i ./all-in-one deploy
# failed=0
```

update openstackclient:
```
deactivate
pip install python-openstackclient -c https://releases.openstack.org/constraints/upper/master
```

post-deploy:
```
source kolla-ansible-venv/bin/activate
kolla-ansible post-deploy
```

init demo:
```
cp ~/kolla-ansible-venv/share/kolla-ansible/init-runonce .
vim init-runonce
./init-runonce
```

final touch:
```
cd /etc/kolla
chgrp adm admin-openrc.sh
chmod g+r admin-openrc.sh
```

then re-upload the images with their metadata


also do not forget to upload your ssh keys and edit the terraform stages to have the correct public net id in your routers and image ids. this will be everywhere you defined a router or floating IP (so APT.tf, IT.tf and proxy.tf)
then after re-building the terraform stuff, get the IP of proxy and import it to the ansible 

### I need to re-install more than openstack



### I lost my openstackcredentials

You can find your username and password in /etc/kolla/admin-openrc.sh

```
grep "OS_PASSWORD" /etc/kolla/admin-openrc.sh
```



### I have keypair errors

upload the public key from your cyberrange host (id_ed25519.pub)




### My copy of the VM does not have internet access

Try the steps from above to re-create the public network.

Ask Kaibin Bao


### Terraform reports instances in state error not coming active 

terraform cannot destory that instance itself. perform terraform destroy or terraform destroy -target openstack_compute_instance_v2.[Name]

if this does not work you have to delete them in openstack or even worse with glance. this will corrupt your terraform state files. delete them.


### I need to delete a Network/Router but Openstack does not let me do it

You need to delete things in a certing order

delete affected routers
delete all remaining floating IPs for this router or/and network
delete ports in these networks
delete the network



### I cannot type the windows password in the spice console

open a on screen keyboard
now you should be able to type. a considerable delay is normal
in windows itself your keyboard should behave as it does



### I cant reach the VMs with ssh

```

generate key id_ed25519
ssh-copy-id -i ~/.ssh/iai_vm-cyberrange-host.pub 10.1.3.191
ssh-add -l
ssh-agent bash
ssh-add .ssh/id_ed25519

make sure the ssh key gets copied to proxy in the proxy playbook. otherwise there is only the public key under authorized hosts and therefore cannot work with the other VMs



ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.12"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.14"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.15"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.16"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.17"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.18"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.20"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.12"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.18"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.15"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.14"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.16"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.17"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.4.97"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.5.64"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.6.42"


```



login manually with 
  ssh -vvvv -A -o ProxyCommand="ssh -A -p 22 -W %h:%p -q -l debian 10.1.3.191" debian@10.0.1.12 -o StrictHostKeyChecking=no
or
  ssh -vvvv -A -o ProxyCommand="ssh -A -p 22 -W %h:%p debian@10.1.3.191" debian@10.0.1.12 -o StrictHostKeyChecking=no

go back and play the playbook.



### Windows winrm quickconfig does not return and so winrm is not setup

ssh to windows machine

```
    powershell winrm quickconfig 
    winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
    winrm set winrm/config @{MaxTimeoutms="1800000"}
    winrm set winrm/config/service @{AllowUnencrypted="true"}
    winrm set winrm/config/service/auth @{Basic="true"}
    net stop winrm
    powershell Set-Service -Name winrm -StartupType Automatic
    net start winrm
    powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"
    winrm enumerate winrm/config/Listener
```



<!--### complete network wipe

If you need a complete wipe and routers do not want to be destroyed

```
openstack project show admin
```

-> id

+-------------+-----------------------------------------------+
| Field       | Value                                         |
+-------------+-----------------------------------------------+
| description | Bootstrap project for initializing the cloud. |
| domain_id   | default                                       |
| enabled     | True                                          |
| id          | 65e52ade32d74c699bef395584d2c91c              |
| is_domain   | False                                         |
| name        | admin                                         |
| options     | {}                                            |
| parent_id   | default                                       |
| tags        | []                                            |
+-------------+-----------------------------------------------+

```
neutron pruge 65e52ade32d74c699bef395584d2c91c
```

this wipes all network stuff

so now you have to re-create the public network for internet access

```
openstack network create public --external --provider-physical-network physnet1 --provider-network-type flat
neutron subnet-create public 10.0.1.0/24 --name public --allocation-pool start=10.0.1.2,end=10.3.254.254 --dns-nameserver DNS_RESOLVER --gateway 10.0.1.1
```

physnet1 is the name of of the physical network adapter in your machine 

manually create new public subnet with network address 10.0.1.0/24

after that you need to update the router id in your terraform config for every router (external network id)-->




<!--## Roadmap

- Benign behaviour and traffic generation
- More versions of Windows Server and Desktop
- Win Server applications
- IACS device images and applications
- APT28 Campaigns
- APT29 Campaigns
- CyberAv3nger Campaigns
- Dataset Release
- Cyberrange image release-->




# AROS
The Attack Range OpenStack (AROS) is a collaborative project by the Institute for Automation and Applied Informatics (IAI) at the Karlsruher Institute for Technology (KIT).
The goal of the project is to create a virtual testing environment for cyber security attacks.

<div>
  <img align="center" width="100%" src="docs/1-ReadMe_Images/1-1-cyber_kill_chain.png" alt="A generic cyber kill chain" title="A generic cyber kill chain">
</div>

To achieve this goal the AROS is constructed using preexisting cyber ranges (namely KYPO and the Splunk Attack Range) as inspiration, whilst integrating additional tools.

<div>
  <img align="center" width="100%" src="docs/1-ReadMe_Images/4-3-All_Tools_Used.png" alt="All major tools used to create the AROS" title="All major tools used to create the AROS">
</div>

The result is a cyber ranges capable of constructing divers scenarios in a reproducible manner.

<div>
  <img align="center" width="100%" src="docs/1-ReadMe_Images/5-8-Attack_on_Example_Scenario.png" alt="Example of a scenario constructed using the AROS" title="Example of a scenario constructed using the AROS">
</div>

This basic scenario describes the following steps:
1. Reconnaissance: The attacker gathers information about the target network or system to identify vulnerabilities and potential points of entry.
2. Initial Access: The attacker gains a foothold in the target system, often through phishing, exploiting vulnerabilities, or other attack vectors.
3. Discovery: The attacker explores the compromised environment to map out the network, systems, and sensitive data that can be targeted.
4. Access: The attacker escalates privileges and moves laterally within the network to gain control over more critical systems or data.
5. Exfiltration: The attacker transfers valuable or sensitive information from the compromised network to their own external location without detection.

<div>
  <img align="center" width="100%" src="docs/2-Topology/Network_max.png" alt="The topology shown is the current goal for the maximum scenario construction" title="The topology shown is the current goal for the maximum scenario construction">
</div>

The current research for this project aims to construct the scenario shown in the previous image.
Corresponding to that, a cyber kill chain suited to the scenario is established.
The goal is to automatically construct the scenario and perform the cyber kill chain with minimal manual input.

## Abstract of the corresponding initial master thesis
This thesis presents the development and evaluation of a self-hosted cyber range environment tailored for attack emulation and detection in large-scale critical infrastructure networks. Leveraging Infrastructure as Code (IaC) tools and cloud platforms, the research addresses challenges in accessing cloud services and the scarcity of cyber ranges for critical infrastructure research.
Key findings include the successful construction of the cyber range named Attack Range Open Stack (AROS) capable of handling complex environments and providing full de- tectability of network tra￿c and actions on virtual machines. The research highlights challenges in setup-time optimization, scalability testing, and integration of real energy hardware for enhanced testing capabilities.
The contributions of this work lie in the development of a sophisticated cyber range envi- ronment and the achievement of full detectability, offering researchers a valuable platform for conducting reproducible cyber security experiments. Future research directions include enhancing scenario complexity and exploring AI-driven data analysis.
Overall, this thesis contributes to advancing cyber security research by providing in- novative tools and methodologies for evaluating cyber threats in critical infrastructure networks.

## Support
If support is needed, please contact the uueaj@student.kit.edu E-Mail.

Creating a public network after neutron purge
To make the cyber range fully usable a public network is needed.
This can be created through the OpenStack UI or by using a corresponding terraform configuration.
It is important to note that a public-subnet is also required for the full usability of the public network.



## Authors and acknowledgment
Special thanks to Dr.Ing Kaibin Bao, Qi Liu and Richard Rudolph for supporting the construction of the cyber range.

Author of AROS: Leon Huck 

Project coordinator: Kaibin Bao, Richard Rudolph

## Support
If support is needed, please contact uueaj@student.kit.edu, qi9091@partner.kit.edu and kaibin.bao@kit.edu


## Project status
Development for this project is currently ongoing.

