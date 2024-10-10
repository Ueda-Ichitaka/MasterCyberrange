#-----------------------
# Config
#-----------------------

data "openstack_compute_keypair_v2" "default_keypair" {
  name = "iai_vm-cyberrange-host"
}


data "template_file" "win_user_data_cloud_init" {
  template = file("win-cloud-init.yml")
}

# resource "openstack_networking_floatingip_v2" "floatip_1" {
#   pool = "public-network"
# }

#-----------------------------------------------------------------------------------------------


# Todo: Make public network with terraform
# #-----------------------
# # Public network
# #-----------------------
# # Create a public network
# resource "openstack_networking_network_v2" "public" {
#   name           = "public"
#   admin_state_up = true
#   shared         = true
# }

# # Create a public subnet in the public network
# resource "openstack_networking_subnet_v2" "public-subnet" {
#   name            = "public-subnet"
#   network_id      = openstack_networking_network_v2.public.id
#   ip_version      = 4
#   cidr            = "10.0.0.0/24"
#   gateway_ip      = "10.0.0.1" # Gateway IP address for the subnet

#   # Allocation pool for the subnet's IP addresses
#   allocation_pool {
#     start = "10.0.0.10" # Starting IP address in the pool
#     end   = "10.0.0.50" # Ending IP address in the pool
#   }

#   dns_nameservers = ["8.8.8.8", "8.8.4.4"]
# }



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
      host     = openstack_networking_floatingip_v2.floatip_1.address
    }


  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'aggregation_server,' playbooks/linux.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'aggregation_server,' playbooks/splunk_server.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'aggregation_server,' playbooks/elk_docker.yml"   
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'aggregation_server,' playbooks/aggregation_server.yml"
  # }




 }


