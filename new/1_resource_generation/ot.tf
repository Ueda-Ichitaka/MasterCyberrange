
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



resource "openstack_networking_port_v2" "OT-network-port_2" {
  name               = "port_2"
  network_id         = openstack_networking_network_v2.OT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.2.13"
    subnet_id  = openstack_networking_subnet_v2.OT-subnet.id
  }
}



# Splunk floatingIP, not necessary with proxy use
resource "openstack_networking_floatingip_v2" "floatip_1" {
  pool = "public"
}



resource "openstack_networking_floatingip_v2" "floatip_2_OT" {
  pool = "public"
}

# resource "openstack_networking_floatingip_associate_v2" "splunk_floatingip_1" {
#   floating_ip = openstack_networking_floatingip_v2.floatip_1.address
#   port_id = openstack_networking_port_v2.attack_range-network-port_1.id
# }



resource "openstack_networking_router_interface_v2" "router_interface_2" {
  router_id = openstack_networking_router_v2.IT_router.id
  subnet_id = openstack_networking_subnet_v2.OT-subnet.id
}






#------------------------------------
# Windows OT Domain Controller
#------------------------------------
data "openstack_images_image_v2" "winserver2022_4" {
    name_regex = "^Windows Server 2022 Eval x86_64$"
    most_recent = true
}

resource "openstack_compute_instance_v2" "DC-OT" {
  name            = "DC-OT"
  image_id        = data.openstack_images_image_v2.winserver2022.id
  flavor_name     = "m1.medium"
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
    command = "ansible-playbook -l 'windows_gateway_server,' windows_dc.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'windows_gateway_server,' windows.yml"
  }


}








#-----------------------
# APT29 Windows Engineering-PC
#-----------------------

data "openstack_images_image_v2" "win10_2" {
    name_regex = "^Windows Server 2019 Eval x86_64$"
    #name = "windows-10-amd64"
    most_recent = true
}


resource "openstack_compute_instance_v2" "APT29-Engineering-PC" {
  name = "APT29-Engineering-PC"
  flavor_name = "m1.medium"
  image_id = "b34c1867-728f-4d7b-839c-06c05a108088" 
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_windows_remote.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,       
    ]
 user_data = data.template_file.win_user_data_cloud_init.rendered
   network {
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.15"
   }


  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_engineering,' windows.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_engineering,' windows_post.yml"
  # }





}




#-----------------------
# APT29 Windows Operating-PC
#-----------------------

data "openstack_images_image_v2" "win10_3" {
    name_regex = "^Windows Server 2019 Eval x86_64$"
    #name = "windows-10-amd64"
    most_recent = true
}

resource "openstack_compute_instance_v2" "APT29-Operating-PC" {
  name = "APT29-Operating-PC"
  flavor_name = "m1.medium"
  image_id = "b34c1867-728f-4d7b-839c-06c05a108088" 
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_windows_remote.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,       #
    ]
  user_data = data.template_file.win_user_data_cloud_init.rendered

   network {  
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.18"
   }


  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_operating,' windows.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_operating,' windows_post.yml"
  # }




}




#-----------------------
# Linux PLC
#-----------------------

data "openstack_images_image_v2" "PLC_Linux" {
    name_regex = "^ubuntu-focal.*"
    most_recent = true
}

resource "openstack_compute_instance_v2" "PLC_Linux" {
  name = "PLC_Linux"
  flavor_name = "m1.small"

  image_id = "d508e903-4f41-491e-bf41-b0cbc0f1712a"    #data.openstack_images_image_v2.ubuntu_test.id
  key_pair = "iai_vm-cyberrange-host"
  security_groups = ["default",openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.name]

   network {  
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.17"
   }


  stop_before_destroy = false

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'plc_linux,' plcs_linux.yml"
  }

  connection {
    type     = "ssh"
    user     = "debian"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-access-proxy.address
  }
}



#-----------------------
# Linux HMI
#-----------------------


data "openstack_images_image_v2" "HMI_Linux" {
    name_regex = "^ubuntu-focal.*"
    most_recent = true
}

resource "openstack_compute_instance_v2" "HMI_Linux" {
  name = "HMI_Linux"
  flavor_name = "standard.small"

  image_id = "d508e903-4f41-491e-bf41-b0cbc0f1712a"  # data.openstack_images_image_v2.ubuntu_test.id
  key_pair = "iai_vm-cyberrange-host"
  security_groups = ["default",openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.name]

   network {  
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.16"
   }


  stop_before_destroy = false

  # # Automatic execution of the corresponding ansible-playbook
  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'hmi_linux,' plcs_linux.yml"
  # }

  connection {
    type     = "ssh"
    user     = "debian"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-access-proxy.address
  }
}