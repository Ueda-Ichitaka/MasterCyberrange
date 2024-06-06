resource "openstack_networking_port_v2" "attack_range-network-linux-port" {
  name               = "linux-port"
  network_id         = openstack_networking_network_v2.attack_range-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.1.6"
    subnet_id  = openstack_networking_subnet_v2.attack_range-subnet.id
  }
}

data "openstack_images_image_v2" "ubuntu_test" {
    name_regex = "^ubuntu-focal.*"
    most_recent = true
}

resource "openstack_compute_instance_v2" "ubuntu_test" {
  name = "ubuntu_test"
  flavor_name = "standard.small"

  image_id = data.openstack_images_image_v2.ubuntu_test.id
  key_pair = "iai_vm-cyberrange-host"
  security_groups = ["default",openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.name]

  network {
    access_network = true
    port = openstack_networking_port_v2.attack_range-network-linux-port.id
  }

  stop_before_destroy = false
  
  # Automatic execution of the corresponding ansible-playbook
  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'ubuntu_test,' make_linux_server.yml"
  # }

  connection {
    type     = "ssh"
    user     = "debian"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-access-proxy.address
  }
}