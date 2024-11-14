
#-----------------------
# Internal OT Network
#-----------------------

resource "openstack_networking_network_v2" "OT-network" {
  name = "OT-network"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "OT-subnet" {
  network_id = openstack_networking_network_v2.OT-network.id
  name = "OT-subnet"
  cidr = "10.0.2.0/24"
}

resource "openstack_networking_port_v2" "OT-network-port_1" {
  name               = "port_1"
  network_id         = openstack_networking_network_v2.OT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.2.12"
    subnet_id  = openstack_networking_subnet_v2.OT-subnet.id
  }
}

resource "openstack_networking_router_interface_v2" "router_interface_2" {
  router_id = openstack_networking_router_v2.IT_router.id
  subnet_id = openstack_networking_subnet_v2.OT-subnet.id
}






# # #------------------------------------
# # # Windows OT Domain Controller
# # #------------------------------------

# resource "openstack_compute_flavor_v2" "ot-dc-flavor" {
#     name = "ot-dc-flavor"
#     ram = "4096"
#     vcpus = "2"
#     disk = "32"
#     swap = "4096"
# }

# resource "openstack_compute_instance_v2" "OT-Win-DC" {
#   name            = "OT-Win-DC"
#   image_id = "b34c1867-728f-4d7b-839c-06c05a108088"  #Windows Server 2019 Eval  
#   #image_id        = data.openstack_images_image_v2.winserver2022_4.id
#   #flavor_name     = "m1.medium"
#   flavor_id = openstack_compute_flavor_v2.ot-dc-flavor.id
#   key_pair = data.openstack_compute_keypair_v2.default_keypair.name
#   security_groups = [
#     "default",
#     openstack_networking_secgroup_v2.secgroup_windows_remote.id,
#     openstack_networking_secgroup_v2.secgroup_attack_range_internal.id,
#     openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.id,
#     ]
#   user_data = data.template_file.win_user_data_cloud_init.rendered
#    network {  
#       access_network = true
#       name = openstack_networking_network_v2.OT-network.name
#       fixed_ip_v4 = "10.0.2.14"
#    }   


#   # provisioner "local-exec" {
#   #   working_dir = "../2_ansible_resource_provisioning"
#   #   command = "ansible-playbook -l 'OT-Win-DC,' playbooks/windows.yml"
#   # }

#   # provisioner "local-exec" {
#   #   working_dir = "../2_ansible_resource_provisioning"
#   #   command = "ansible-playbook -l 'OT-Win-DC,' playbooks/beats_windows.yml"
#   # }

#   # provisioner "local-exec" {
#   #   working_dir = "../2_ansible_resource_provisioning"
#   #   command = "ansible-playbook -l 'OT-Win-DC,' playbooks/splunk_forwarder_windows.yml"
#   # }

#   # provisioner "local-exec" {
#   #   working_dir = "../2_ansible_resource_provisioning"
#   #   command = "ansible-playbook -l 'OT-Win-DC,' playbooks/windows_dc.yml"
#   # }

#   # provisioner "local-exec" {
#   #   working_dir = "../2_ansible_resource_provisioning"
#   #   command = "ansible-playbook -l 'OT-Win-DC,' playbooks/vulnerabilities.yml"
#   # }  


#  }








# #-----------------------
# # APT29 Windows Engineering-PC
# #-----------------------

resource "openstack_compute_flavor_v2" "ot-win-pc-1-flavor" {
    name = "ot-win-pc-1-flavor"
    ram = "4096"
    vcpus = "2"
    disk = "60"
    swap = "4096"
}

resource "openstack_compute_instance_v2" "OT-Win-PC-1" {
  name = "OT-Win-PC-1"
  #flavor_name = "m1.medium"
  flavor_id = openstack_compute_flavor_v2.ot-win-pc-1-flavor.id
  image_id = "b34c1867-728f-4d7b-839c-06c05a108088" 
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_windows_remote.id,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.id,       
    ]
 user_data = data.template_file.win_user_data_cloud_init.rendered
   network {
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.15"
   }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'OT-Win-PC-1,' playbooks/windows.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'OT-Win-PC-1,' playbooks/beats_windows.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'OT-Win-PC-1,' playbooks/splunk_forwarder_windows.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'OT-Win-PC-1,' playbooks/windows_workstation.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'OT-Win-PC-1,' playbooks/vulnerabilities.yml"
  # }  




 }




# # #-----------------------
# # # APT29 Windows Operating-PC
# # #-----------------------

# resource "openstack_compute_flavor_v2" "ot-win-pc-2-flavor" {
#     name = "ot-win-pc-2-flavor"
#     ram = "4096"
#     vcpus = "2"
#     disk = "32"
#     swap = "4096"
# }

# resource "openstack_compute_instance_v2" "OT-Win-PC-2" {
#   name = "OT-Win-PC-2"
#   #flavor_name = "m1.medium"
#   flavor_id = openstack_compute_flavor_v2.ot-win-pc-2-flavor.id
#   image_id = "b34c1867-728f-4d7b-839c-06c05a108088" 
#   key_pair = data.openstack_compute_keypair_v2.default_keypair.name
#   security_groups = [
#     "default",
#     openstack_networking_secgroup_v2.secgroup_windows_remote.id,
#     openstack_networking_secgroup_v2.secgroup_attack_range_internal.id,
#     ]
#   user_data = data.template_file.win_user_data_cloud_init.rendered

#    network {  
#       access_network = true
#       name = openstack_networking_network_v2.OT-network.name
#       fixed_ip_v4 = "10.0.2.18"
#    }


#   # provisioner "local-exec" {
#   #   working_dir = "../2_ansible_resource_provisioning"
#   #   command = "ansible-playbook -l 'OT-Win-PC-2,' playbooks/windows.yml"
#   # }

#   # provisioner "local-exec" {
#   #   working_dir = "../2_ansible_resource_provisioning"
#   #   command = "ansible-playbook -l 'OT-Win-PC-2,' playbooks/beats_windows.yml"
#   # }

#   # provisioner "local-exec" {
#   #   working_dir = "../2_ansible_resource_provisioning"
#   #   command = "ansible-playbook -l 'OT-Win-PC-2,' playbooks/splunk_forwarder_windows.yml"
#   # }

#   # provisioner "local-exec" {
#   #   working_dir = "../2_ansible_resource_provisioning"
#   #   command = "ansible-playbook -l 'OT-Win-PC-2,' playbooks/windows_workstation.yml"
#   # }

#   # provisioner "local-exec" {
#   #   working_dir = "../2_ansible_resource_provisioning"
#   #   command = "ansible-playbook -l 'OT-Win-PC-2,' playbooks/vulnerabilities.yml"
#   # }


#  }




# #-----------------------
# # Linux PLC
# #-----------------------

resource "openstack_compute_flavor_v2" "ot-plc-linux-flavor" {
    name = "ot-plc-linux-flavor"
    ram = "2048"
    vcpus = "1"
    disk = "10"
    swap = "2048"
}

resource "openstack_compute_instance_v2" "OT-PLC-Linux" {
  name = "OT-PLC-Linux"
  #flavor_name = "m1.small"
  flavor_id = openstack_compute_flavor_v2.ot-plc-linux-flavor.id

  image_id = "63688ae7-c167-41e5-80db-164ef5714eef" #debian 12
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = ["default",openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.id]

  network {  
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.17"
  }


  stop_before_destroy = false


  connection {
    type     = "ssh"
    user     = "debian"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-access-proxy.address
  }


  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'OT-PLC-Linux,' playbooks/linux.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'OT-PLC-Linux,' playbooks/beats_linux.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'OT-PLC-Linux,' playbooks/plc_debian.yml"
  # }

 }


# #-----------------------
# # Linux HMI
# #-----------------------

resource "openstack_compute_flavor_v2" "ot-hmi-linux-flavor" {
    name = "ot-hmi-linux-flavor"
    ram = "2048"
    vcpus = "1"
    disk = "10"
    swap = "2048"
}

resource "openstack_compute_instance_v2" "OT-HMI-Linux" {
  name = "OT-HMI-Linux"
  #flavor_name = "m1.small"
  flavor_id = openstack_compute_flavor_v2.ot-hmi-linux-flavor.id
  image_id = "63688ae7-c167-41e5-80db-164ef5714eef" #debian 12
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = ["default",openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.id]

  network {  
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.16"
  }


  stop_before_destroy = false


  connection {
    type     = "ssh"
    user     = "debian"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-access-proxy.address
  }


  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'OT-HMI-Linux,' playbooks/linux.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'OT-HMI-Linux,' playbooks/hmi_debian.yml"
  # }

}
