
# #-----------------------
# # Attacker Network
# #-----------------------

resource "openstack_networking_network_v2" "APT-network" {
  name = "APT-network"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "APT-subnet" {
  network_id = openstack_networking_network_v2.APT-network.id
  name = "APT-subnet"
  cidr = "10.0.4.0/22"
}



resource "openstack_networking_floatingip_v2" "floatip_c2" {
  pool = "public1"
}

resource "openstack_networking_floatingip_v2" "floatip_download_server" {
  pool = "public1"
}

resource "openstack_networking_router_v2" "APT_router" {
  name                = "APT_router"
  admin_state_up      = true
  external_network_id = "cc737076-5b14-4c74-a2ed-d3fb490663ac"  
}

resource "openstack_networking_router_interface_v2" "router_interface_3" {
  router_id = openstack_networking_router_v2.APT_router.id
  subnet_id = openstack_networking_subnet_v2.APT-subnet.id
}

# #-----------------------
# # Outside-Attacker-Kali
# #-----------------------

resource "openstack_compute_flavor_v2" "apt-outside-attacker-flavor" {
    name = "apt-outside-attacker-flavor"
    ram = "4096"
    vcpus = "2"
    disk = "50"
    swap = "4096"
}

resource "openstack_networking_port_v2" "apt-outside-attacker-port" {
  name               = "apt-outside-attacker-port"
  network_id         = openstack_networking_network_v2.APT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.4.97"
    subnet_id  = openstack_networking_subnet_v2.APT-subnet.id
  }
}

resource "openstack_networking_floatingip_v2" "floatip-outside-attacker" {
  pool = "public1"
}

resource "openstack_networking_floatingip_associate_v2" "floatingip-outside-attacker" {
  floating_ip = openstack_networking_floatingip_v2.floatip-outside-attacker.address
  port_id = openstack_networking_port_v2.apt-outside-attacker-port.id
}

resource "openstack_compute_instance_v2" "APT-Outside-Attacker" {
   name = "APT-Outside-Attacker"
   #flavor_name = "m1.medium"
   flavor_id = openstack_compute_flavor_v2.apt-outside-attacker-flavor.id
   image_id = "bf8afd2a-f61b-4e2d-a747-caf2803c8d37"
   key_pair = data.openstack_compute_keypair_v2.default_keypair.name
   admin_pass = "1337"


   network {
      access_network = true
      port = openstack_networking_port_v2.apt-outside-attacker-port.id
      #name = openstack_networking_network_v2.APT-network.name
      #fixed_ip_v4 = "10.0.4.97"
   }

   stop_before_destroy = false

  connection {
    type     = "ssh"
    user     = "debian"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-outside-attacker.address #openstack_networking_floatingip_v2.floatip_3.address
  }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'APT-Outside-Attacker,' playbooks/kali.yml"
  # }
}






# #-----------------------
# # C2-Server
# #-----------------------

resource "openstack_compute_flavor_v2" "apt-c2-server-flavor" {
    name = "apt-c2-server-flavor"
    ram = "4096"
    vcpus = "2"
    disk = "50"
    swap = "4096"
}


resource "openstack_networking_port_v2" "apt-c2-port" {
  name               = "apt-c2-port"
  network_id         = openstack_networking_network_v2.APT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.5.64"
    subnet_id  = openstack_networking_subnet_v2.APT-subnet.id
  }
}

resource "openstack_networking_floatingip_v2" "floatip-c2" {
  pool = "public1"
}

resource "openstack_networking_floatingip_associate_v2" "floatingip-c2" {
  floating_ip = openstack_networking_floatingip_v2.floatip-c2.address
  port_id = openstack_networking_port_v2.apt-c2-port.id
}


resource "openstack_compute_instance_v2" "APT-C2-Server" {
   name = "APT-C2-Server"
   #flavor_name = "m1.medium"
   flavor_id = openstack_compute_flavor_v2.apt-c2-server-flavor.id
   image_id = "bf8afd2a-f61b-4e2d-a747-caf2803c8d37"
   key_pair = data.openstack_compute_keypair_v2.default_keypair.name
   admin_pass = "1337"


   network {
      access_network = true
      port = openstack_networking_port_v2.apt-c2-port.id
      #name = openstack_networking_network_v2.APT-network.name
      #fixed_ip_v4 = "10.0.5.64"
   }


  stop_before_destroy = false

  connection {
    type     = "ssh"
    user     = "debian"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-c2.address #openstack_networking_floatingip_v2.floatip_3.address
  }


  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'APT-C2-Server,' playbooks/kali.yml"
  # }

 }


# TODO floatip
# # #-----------------------
# # # APT-Download-Server
# # #-----------------------

# resource "openstack_compute_flavor_v2" "apt-download-server-flavor" {
#     name = "apt-download-server-flavor"
#     ram = "2048"
#     vcpus = "1"
#     disk = "20"
#     swap = "2048"
# }

# resource "openstack_compute_instance_v2" "APT-Download-Server" {
#   name = "APT-Download-Server"
#   #flavor_name = "m1.small"
#   flavor_id = openstack_compute_flavor_v2.apt-download-server-flavor.id
#   image_id = "63688ae7-c167-41e5-80db-164ef5714eef" #debian 12
#   key_pair = data.openstack_compute_keypair_v2.default_keypair.name
#   security_groups = ["default",openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.id]

#   network {  
#       access_network = true
#       name = openstack_networking_network_v2.APT-network.name
#       fixed_ip_v4 = "10.0.6.42"
#   }


#   stop_before_destroy = false


#   connection {
#     type     = "ssh"
#     user     = "debian"
#     private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
#     host     = openstack_networking_floatingip_v2.floatip-access-proxy.address
#   }


#   provisioner "local-exec" {
#     working_dir = "../2_ansible_resource_provisioning"
#     command = "ansible-playbook -l 'APT-Download-Server,' playbooks/linux.yml"
#   }

# }