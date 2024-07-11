#-----------------------
# Config
#-----------------------

data "openstack_compute_keypair_v2" "default_keypair" {
  name = "iai_vm-cyberrange-host"
}


data "template_file" "win_user_data_cloud_init" {
  template = file("win-cloud-init.yml")
}


#-----------------------------------------------------------------------------------------------








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
  cidr = "10.0.3.0/24"
}


resource "openstack_networking_floatingip_v2" "floatip_2" {
  pool = "public"
}



resource "openstack_networking_router_v2" "APT_router" {
  name                = "APT_router"
  admin_state_up      = true
  external_network_id = "b4def106-3c27-4de8-9848-434dacf07ba3"  
}

resource "openstack_networking_router_interface_v2" "router_interface_3" {
  router_id = openstack_networking_router_v2.APT_router.id
  subnet_id = openstack_networking_subnet_v2.APT-subnet.id
}









#----------------------------------------------------------------------------------------------




#-----------------------
# Splunk Server
#-----------------------

resource "openstack_compute_instance_v2" "splunk-server" {
   name = "splunk-server"
   flavor_name = "standard.large"
   #image_id = "e4c61468-4c60-484d-bbb9-7ac42a1440bf" #debian-10-openstack-arm64-splunk-base
   #image_id = "28e7b185-4428-4c00-b82c-51aa1809e8f7" #bionic-server-cloudimg-20230607-amd64
   image_id = "63688ae7-c167-41e5-80db-164ef5714eef" #debian 12
   key_pair = data.openstack_compute_keypair_v2.default_keypair.name
   admin_pass = "secreT123%"
   security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_splunk_server.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,       ### Wo wird das _internal definiert?
    ]

   network {
      access_network = true
      port = openstack_networking_port_v2.IT-network-port_1.id                  
   }

   network {
      access_network = true
      port = openstack_networking_port_v2.OT-network-port_1.id                  
   }   

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
      host     = openstack_networking_floatingip_v2.floatip_1.address
    }


  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'splunk_server,' make_splunk_server_os.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'splunk_server,' splunk_server.yml"
  }


}





#-----------------------
# ELK Server
#-----------------------

resource "openstack_compute_instance_v2" "elk-server" {
   name = "elk-server"
   flavor_name = "standard.large"
   #image_id = "e4c61468-4c60-484d-bbb9-7ac42a1440bf" #debian-10-openstack-arm64-splunk-base
   #image_id = "28e7b185-4428-4c00-b82c-51aa1809e8f7" #bionic-server-cloudimg-20230607-amd64
   image_id = "63688ae7-c167-41e5-80db-164ef5714eef" #debian 12
   key_pair = data.openstack_compute_keypair_v2.default_keypair.name
   admin_pass = "secreT123%"
   security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_splunk_server.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,       ### Wo wird das _internal definiert?
    ]

   network {
      access_network = true
      port = openstack_networking_port_v2.IT-network-port_5.id                  
   }

   network {
      access_network = true
      port = openstack_networking_port_v2.OT-network-port_2.id                  
   }   

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
      host     = openstack_networking_floatingip_v2.floatip_2.address
    }


  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'elk_server,' elk_server_5.6.16.yml"
  }


}



#---------------------------------------


#-----------------------
# Outside-Attacker-Kali
#-----------------------


resource "openstack_compute_instance_v2" "Outside-Attacker-Kali" {
   name = "Outside-Attacker-Kali"
   flavor_name = "m1.medium"
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
    command = "ansible-playbook -l 'outside_kali,' kali.yml"
  }


}






#-----------------------
# C2-Server
#-----------------------


resource "openstack_compute_instance_v2" "C2-Server" {
   name = "C2-Server"
   flavor_name = "m1.medium"
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
    command = "ansible-playbook -l 'c2,' kali.yml"
  }





}