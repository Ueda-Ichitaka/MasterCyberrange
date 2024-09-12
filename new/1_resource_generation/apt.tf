
#-----------------------
# Attacker Network
#-----------------------

resource "openstack_networking_network_v2" "APT-network" {
  name = "APT-network"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "APT-subnet" {
  network_id = openstack_networking_network_v2.APT-network.id
  name = "APT-subnet"
  cidr = "10.3.0.0/16"
}

# resource "openstack_networking_floatingip_v2" "floatip_2" {
#   pool = "public"
# }

resource "openstack_networking_router_v2" "APT_router" {
  name                = "APT_router"
  admin_state_up      = true
  external_network_id = "b4def106-3c27-4de8-9848-434dacf07ba3"  
}

resource "openstack_networking_router_interface_v2" "router_interface_3" {
  router_id = openstack_networking_router_v2.APT_router.id
  subnet_id = openstack_networking_subnet_v2.APT-subnet.id
}

#-----------------------
# Outside-Attacker-Kali
#-----------------------

resource "openstack_compute_flavor_v2" "apt-outisde-attacker-flavor" {
    name = "apt-outside-attacker-flavor"
    ram = "4"
    vcpus = "2"
    disk = "20"
    swap = "4"
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
      name = openstack_networking_network_v2.APT-network.name
      fixed_ip_v4 = "10.0.3.37"
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
    command = "ansible-playbook -l 'outside_kali,' playbooks/kali.yml"
  }
}






#-----------------------
# C2-Server
#-----------------------

resource "openstack_compute_flavor_v2" "apt-oc2-server-flavor" {
    name = "apt-c2-server-flavor"
    ram = "4"
    vcpus = "2"
    disk = "20"
    swap = "4"
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
      name = openstack_networking_network_v2.APT-network.name
      fixed_ip_v4 = "10.0.3.38"
   }


  stop_before_destroy = false

  connection {
    type     = "ssh"
    user     = "kali"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-access-proxy.address #openstack_networking_floatingip_v2.floatip_3.address
  }


  resource "openstack_dns_zone_v2" "C2_zone" {
    name        = "cozybear.com."
    email       = "contact@cozybear.com"
    description = "a zone"
    ttl         = 6000
    type        = "PRIMARY"
  }

  resource "openstack_dns_recordset_v2" "apt_cozybear_com" {
    zone_id     = openstack_dns_zone_v2.C2_zone.id
    name        = "apt.cozybear.com."
    description = "An example record set"
    ttl         = 3000
    type        = "A"
    records     = ["10.0.3.38"]
  }



  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'APT-C2-Server,' playbooks/kali.yml"
  }

}



#-----------------------
# APT-Download-Server
#-----------------------

resource "openstack_compute_flavor_v2" "apt-download-server-flavor" {
    name = "apt-download-server-flavor"
    ram = "2"
    vcpus = "1"
    disk = "10"
    swap = "2"
}

resource "openstack_compute_instance_v2" "APT-Download-Server" {
  name = "APT-Download-Server"
  #flavor_name = "m1.small"
  flavor_id = openstack_compute_flavor_v2.apt-download-server-flavor.id
  image_id = "63688ae7-c167-41e5-80db-164ef5714eef" #debian 12
  key_pair = "iai_vm-cyberrange-host"
  security_groups = ["default",openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.name]

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


  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'APT-Download-Server,' playbooks/linux.yml"
  }

}