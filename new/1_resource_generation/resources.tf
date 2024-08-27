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
# Aggregation Server
#-----------------------

resource "openstack_compute_flavor_v2" "aggregation-server-flavor" {
    name = "aggregation-server-flavor"
    ram = "10"
    vcpus = "4"
    disk = "500"
    swap = "4"
}

resource "openstack_compute_instance_v2" "aggregation-server" {
   name = "aggregation-server"
   #flavor_name = "standard.large"
   flavor_id = openstack_compute_flavor_v2.aggregation-server-flavor.id
   image_id = "63688ae7-c167-41e5-80db-164ef5714eef" #debian 12
   key_pair = data.openstack_compute_keypair_v2.default_keypair.name
   admin_pass = "secreT123%"
   security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_splunk_server.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,       
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
      user     = "debian"
      private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
      host     = openstack_networking_floatingip_v2.floatip_1.address
    }


  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'aggregation_server,' linux.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'aggregation_server,' splunk_server.yml"
  }


  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'aggregation_server,' elk_server_7.x.yml"
  }


}


