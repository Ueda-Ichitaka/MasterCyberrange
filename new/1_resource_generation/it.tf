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

resource "openstack_networking_port_v2" "IT-network-port_2" {
  name               = "port_2"
  network_id         = openstack_networking_network_v2.IT-network.id
  admin_state_up     = "true"

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.IT-subnet.id
  }
}


resource "openstack_networking_port_v2" "IT-network-port_5" {
  name               = "port_5"
  network_id         = openstack_networking_network_v2.IT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.1.13"
    subnet_id  = openstack_networking_subnet_v2.IT-subnet.id
  }
}




# Splunk floatingIP, not necessary with proxy use
# resource "openstack_networking_floatingip_v2" "floatip_1" {
#   pool = "public"
# }

resource "openstack_networking_floatingip_v2" "floatip_2" {
  pool = "public"
}

# resource "openstack_networking_floatingip_associate_v2" "splunk_floatingip_1" {
#   floating_ip = openstack_networking_floatingip_v2.floatip_1.address
#   port_id = openstack_networking_port_v2.attack_range-network-port_1.id
# }

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
# Windows Share and Gateway Server
#------------------------------------
data "openstack_images_image_v2" "winserver2022_3" {
    name_regex = "^Windows Server 2022 Eval x86_64$"
    most_recent = true
}

resource "openstack_compute_instance_v2" "Windows-Share-Server" {
  name            = "Windows-Share-Server"
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
      fixed_ip_v4 = "10.0.1.20"
   }   

   network {  
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.20"
   } 


  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'windows_gateway_server,' windows.yml"
  }


}




# -----------------------------------------------------------






#-----------------------
# APT29 Windows Workstation
#-----------------------

data "openstack_images_image_v2" "win10" {
    name_regex = "^Windows Server 2019 Eval x86_64$"
    #name = "windows-10-amd64"
    most_recent = true
}

resource "openstack_compute_instance_v2" "APT29-Windows-Workstation" {
  name = "APT29-Windows-Workstation"
  flavor_name = "m1.medium"
  image_id = "b34c1867-728f-4d7b-839c-06c05a108088"  #Windows Server 2019 Eval 
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_windows_remote.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,       ### WOher kommt internal?
    ]
  user_data = data.template_file.win_user_data_cloud_init.rendered

  network {
      access_network = true
      name = openstack_networking_network_v2.IT-network.name
      fixed_ip_v4 = "10.0.1.15"
   }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'windows_workstation,' windows.yml"
  }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_workstation,' windows_post.yml"
  # }


}


#-----------------------
# Inside-Attacker-Kali
#-----------------------
resource "openstack_networking_floatingip_v2" "floatip_3" {
  pool = "public"
}

# resource "openstack_networking_port_v2" "IT-network-port_3" {
#   name               = "port_3"
#   network_id         = openstack_networking_network_v2.IT-network.id
#   admin_state_up     = "true"

#   fixed_ip {
#     ip_address = "10.0.1.17"
#     subnet_id  = openstack_networking_subnet_v2.IT-subnet.id
#   }
# }


resource "openstack_compute_instance_v2" "Inside-Attacker-Kali" {
   name = "Inside-Attacker-Kali"
   flavor_name = "m1.medium"
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
    command = "ansible-playbook -l 'inside_kali,' linux.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'inside_kali,' kali.yml"
  }


}






#------------------------------------
# Windows SQL Server
#------------------------------------
data "openstack_images_image_v2" "winserver2022" {
    name_regex = "^Windows Server 2022 Eval x86_64$"
    most_recent = true
}

resource "openstack_compute_instance_v2" "Windows-SQL-Server" {
  name            = "Windows-SQL-Server"
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
  connection {
    type     = "ssh"
    user     = "TestAdmin"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-access-proxy.address #openstack_networking_floatingip_v2.floatip_3.address
  }


  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_sql_server,' windows.yml --extra-vars 'ansible_user=TestAdmin ansible_password=secreT123% ansible_winrm_operation_timeout_sec=120 ansible_winrm_read_timeout_sec=150 ansible_port=5986 attack_range_password=secreT123% use_prebuilt_images_with_packer=0 cloud_provider=local splunk_uf_win_url=https://download.splunk.com/products/universalforwarder/releases/9.0.5/windows/splunkforwarder-9.0.5-e9494146ae5c-x64-release.msi'"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_sql_server,' windows_post.yml --extra-vars 'ansible_user=TestAcc ansible_password=secreT123% ansible_winrm_operation_timeout_sec=120 ansible_winrm_read_timeout_sec=150 attack_range_password=secreT123% ansible_port=5986'"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_sql_server,' windows_sql.yml"
  # }




  network {
    access_network = true
    name = openstack_networking_network_v2.IT-network.name
    fixed_ip_v4 = "10.0.1.18"
  }


}





#------------------------------------
# Windows IT Domain Controller
#------------------------------------
data "openstack_images_image_v2" "winserver2022_2" {
    name_regex = "^Windows Server 2022 Eval x86_64$"
    most_recent = true
}

resource "openstack_compute_instance_v2" "DC-IT" {
  name            = "DC-IT"
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


