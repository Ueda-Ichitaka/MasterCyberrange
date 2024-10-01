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





## Terraform
<div>
  <img align="center" width="100%" src="docs/1-ReadMe_Images/2-1-Terraform.png" alt="Terraform is used for provisioning the basic infrastructure of any given scenario" title="Terraform is used for provisioning the basic infrastructure of any given scenario">
</div>

## Ansible
<div>
  <img align="center" width="100%" src="docs/1-ReadMe_Images/2-2-Ansible.png" alt="Ansible is used for the automatic configuration of the instances that were created during the terraform stage" title="Ansible is used for the automatic configuration of the instances that were created during the terraform stage">
</div>

## Deployment
The usage of the AROS requires a running OpenStack instance.

```
scp -r .  cyberrange-copy:/home/iai/attack_range_openstack
ssh cyberrange-copy
terraform apply
```

## Working with the Infrastructure

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
</div>



## Troubleshooting

### delete all remains

if terraform destroy does not clean up everything

delete all instances in openstack
delete all routers
delete ports in all networks
delete all networks but public

### complete network wipe

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

``
neutron pruge [id]

this wipes all network stuff

so now you have to re-create the public network for internet access

```
openstack network create public --external --provider-physical-network physnet1 --provider-network-type flat
neutron subnet-create public 10.0.1.0/8 --name public --allocation-pool start=10.0.1.2,end=10.3.254.254 --dns-nameserver DNS_RESOLVER --gateway 10.0.1.1
```

physnet1 is the name of of the physical network adapter in your machine 

manually create new public subnet with network address 10.0.1.0/24

after that you need to update the router id in your terraform config for every router (external network id)




## Roadmap

## Authors and acknowledgment
Special thanks to PhD Kaibin Bao, Qi Liu and Richard Rudolph for supporting the construction of the cyber range.


## Support
If support is needed, please contact the uueaj@student.kit.edu E-Mail.


## Project status
Development for this project is currently ongoing.

