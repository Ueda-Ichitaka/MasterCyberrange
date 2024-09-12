#-----------------------
# Internal IT Network
#-----------------------

resource "openstack_networking_network_v2" "IT-network" {
  name = "IT-network"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "IT-subnet" {
  network_id = openstack_networking_network_v2.IT-network.id
  name = "IT-subnet"
  cidr = "10.0.1.0/24"
}

resource "openstack_networking_port_v2" "IT-network-port_1" {
  name               = "port_1"
  network_id         = openstack_networking_network_v2.IT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.1.12"
    subnet_id  = openstack_networking_subnet_v2.IT-subnet.id
  }
}

resource "openstack_networking_floatingip_v2" "floatip_2" {
  pool = "public"
}

resource "openstack_networking_router_v2" "IT_router" {
  name                = "IT_router"
  admin_state_up      = true
  external_network_id = "b4def106-3c27-4de8-9848-434dacf07ba3"  ### ID von public network
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.IT_router.id
  subnet_id = openstack_networking_subnet_v2.IT-subnet.id
}

#------------------------------------
# Windows IT Domain Controller
#------------------------------------

resource "openstack_compute_flavor_v2" "it-dc-flavor" {
    name = "it-dc-flavor"
    ram = "4"
    vcpus = "2"
    disk = "10"
    swap = "4"
}

resource "openstack_compute_instance_v2" "IT-Win-DC" {
  name            = "IT-Win-DC"
  image_id = "b34c1867-728f-4d7b-839c-06c05a108088"  #Windows Server 2019 Eval   
  flavor_name     = "m1.medium"
  #flavor_id = openstack_compute_flavor_v2.it-dc-flavor.id
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_windows_remote.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,
    openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.name,
    ]
  user_data = data.template_file.win_user_data_cloud_init.rendered

   network {  
      access_network = true
      name = openstack_networking_network_v2.IT-network.name
      fixed_ip_v4 = "10.0.1.14"
   }   


  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-DC,' playbooks/windows.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-DC,' playbooks/beats_windows.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-DC,' playbooks/splunk_forwarder_windows.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-DC,' playbooks/windows_dc.yml"
  }

}

#------------------------------------
# Windows Share and Gateway Server
#------------------------------------

resource "openstack_compute_flavor_v2" "it-win-share-flavor" {
    name = "it-win-share-flavor"
    ram = "4"
    vcpus = "2"
    disk = "10"
    swap = "4"
}

resource "openstack_compute_instance_v2" "IT-Win-Share" {
  name            = "IT-Win-Share"
  image_id = "b34c1867-728f-4d7b-839c-06c05a108088"  #Windows Server 2019 Eval  
  flavor_name     = "m1.medium"
  flavor_id = openstack_compute_flavor_v2.it-win-share-flavor.id
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_windows_remote.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,
    openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.name,
    ]
  user_data = data.template_file.win_user_data_cloud_init.rendered

   network {  
      access_network = true
      name = openstack_networking_network_v2.IT-network.name
      fixed_ip_v4 = "10.0.1.20"
   }   

   network {  
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.20"
   } 


  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-Share,' playbooks/windows.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-Share,' playbooks/beats_windows.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-Share,' playbooks/splunk_forwarder_windows.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-Share,' playbooks/windows_fileshare.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-Share,' playbooks/windows_server.yml"
  }

}

#-----------------------
# APT29 Windows Workstation
#-----------------------

resource "openstack_compute_flavor_v2" "it-win-pc-1-flavor" {
    name = "it-win-pc-1-flavor"
    ram = "4"
    vcpus = "2"
    disk = "20"
    swap = "4"
}

resource "openstack_compute_instance_v2" "IT-Win-PC-1" {
  name = "IT-Win-PC-1"
  flavor_name = "m1.medium"
  #flavor_id = openstack_compute_flavor_v2.it-win-pc-1-flavor.id
  image_id = "b34c1867-728f-4d7b-839c-06c05a108088"  #Windows Server 2019 Eval 
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_windows_remote.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,       
    ]
  user_data = data.template_file.win_user_data_cloud_init.rendered

  network {
      access_network = true
      name = openstack_networking_network_v2.IT-network.name
      fixed_ip_v4 = "10.0.1.15"
   }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-PC-1,' playbooks/windows.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-PC-1,' playbooks/beats_windows.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-PC-1,' playbooks/splunk_forwarder_windows.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-PC-1,' playbooks/windows_workstation.yml"
  }  

}

# Todo: Server applications
#------------------------------------
# Windows SQL and Exchange Server
#------------------------------------

resource "openstack_compute_flavor_v2" "it-win-server-1-flavor" {
    name = "it-win-server-1-flavor"
    ram = "4"
    vcpus = "2"
    disk = "20"
    swap = "4"
}

resource "openstack_compute_instance_v2" "IT-Win-Server-1" {
  name            = "IT-Win-Server-1"
  image_id = "b34c1867-728f-4d7b-839c-06c05a108088"  #Windows Server 2019 Eval  
  flavor_name     = "m1.medium"
  #flavor_id = openstack_compute_flavor_v2.it-win-server-flavor.id
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_windows_remote.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,
    openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.name,
    ]
  user_data = data.template_file.win_user_data_cloud_init.rendered

  network {
    access_network = true
    name = openstack_networking_network_v2.IT-network.name
    fixed_ip_v4 = "10.0.1.18"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-Server-1,' playbooks/windows.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-Server-1,' playbooks/beats_windows.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-Server-1,' playbooks/splunk_forwarder_windows.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-Server-1,' playbooks/windows_sql.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-Server-1,' playbooks/windows_exchange.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Win-Server-1,' playbooks/windows_server.yml"
  }

}

# Todo: Applications
#-----------------------
# Ubuntu Workstation
#-----------------------

data "openstack_images_image_v2" "IT-Linux-PC-1" {
    name_regex = "^ubuntu-focal.*"
    most_recent = true
}

resource "openstack_compute_flavor_v2" "it-linux-pc-1-flavor" {
    name = "it-linux-pc-1-flavor"
    ram = "4"
    vcpus = "2"
    disk = "20"
    swap = "4"
}

resource "openstack_compute_instance_v2" "IT-Linux-PC-1" {
  name = "IT-Linux-PC-1"
  flavor_name = "m1.small"
  #flavor_id = openstack_compute_flavor_v2.it-linux-pc-1-flavor.id
  image_id = "d508e903-4f41-491e-bf41-b0cbc0f1712a"    #data.openstack_images_image_v2.ubuntu_test.id
  key_pair = "iai_vm-cyberrange-host"
  security_groups = ["default",openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.name]

   network {  
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.1.16"
   }


  stop_before_destroy = false


  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-access-proxy.address
  }


  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Linux-PC-1,' playbooks/linux.yml"
  }

}

#-----------------------
# Inside-Attacker-Kali
#-----------------------

resource "openstack_compute_flavor_v2" "it-inside-attacker-flavor" {
    name = "it-inside-attacker-flavor"
    ram = "4"
    vcpus = "2"
    disk = "20"
    swap = "4"
}

resource "openstack_compute_instance_v2" "IT-Inside-Attacker" {
   name = "IT-Inside-Attacker"
   flavor_name = "m1.medium"
   #flavor_id = openstack_compute_flavor_v2.it-inside-attacker-flavor.id
   image_id = "bf8afd2a-f61b-4e2d-a747-caf2803c8d37"
   key_pair = data.openstack_compute_keypair_v2.default_keypair.name
   admin_pass = "1337"


   network {
      access_network = true
      name = openstack_networking_network_v2.IT-network.name
      fixed_ip_v4 = "10.0.1.17"
   }


   stop_before_destroy = false

  connection {
    type     = "ssh"
    user     = "kali"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-access-proxy.address #openstack_networking_floatingip_v2.floatip_3.address
  }


  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Inside-Attacker,' playbooks/linux.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'IT-Inside-Attacker,' playbooks/kali.yml"
  }
}