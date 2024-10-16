#-----------------------
# Config
#-----------------------

data "openstack_compute_keypair_v2" "default_keypair" {
  name = "id_ed25519"   #"iai_vm-cyberrange-host"
}


data "template_file" "win_user_data_cloud_init" {
  template = file("win-cloud-init.yml")
}

# resource "openstack_networking_floatingip_v2" "floatip_1" {
#   pool = "public-network"
# }

#-----------------------------------------------------------------------------------------------

# ToDO: create ressources from images -> no more image IDs

# data.openstack_images_image_v2.debian12.id
data "openstack_images_image_v2" "Debian12" {
    name_regex = "^Debian 12 generic amd64 .*"
    most_recent = true
}


data "openstack_images_image_v2" "Debian11" {
    name_regex = "^Debian 11 generic amd64 .*"
    most_recent = true
}

data "openstack_images_image_v2" "Kali" {
    name_regex = "kali"
    most_recent = true
}


data "openstack_images_image_v2" "Win_Server_2019" {
    name_regex = "^Windows Server 2019 .*"
    most_recent = true
}


data "openstack_images_image_v2" "Win_Server_2022" {
    name = "Windows Server 2022 Eval x86_64"
    most_recent = true
}


#-----------------------------------------------------------------------------------------------




# #-----------------------
# # Aggregation Server
# #-----------------------


resource "openstack_compute_flavor_v2" "aggregation-server-flavor" {
    name = "aggregation-server-flavor"
    ram = "10240"
    vcpus = "4"
    disk = "300"
    swap = "4096"
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
    openstack_networking_secgroup_v2.secgroup_splunk_server.id,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.id,       
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
      host     = openstack_networking_floatingip_v2.floatip-access-proxy.address
    }


  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'aggregation_server,' playbooks/linux.yml"
  }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'aggregation_server,' playbooks/splunk_server.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'aggregation_server,' playbooks/elk_docker.yml"   
  # }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'aggregation_server,' playbooks/aggregation_server.yml"
  }




 }


