resource "openstack_networking_port_v2" "IT-network-access-proxy-port" {
  name               = "access-proxy-port"
  network_id         = openstack_networking_network_v2.IT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.1.5"
    subnet_id  = openstack_networking_subnet_v2.IT-subnet.id
  }
}

resource "openstack_networking_floatingip_v2" "floatip-access-proxy" {
  pool = "public"
}

resource "openstack_networking_floatingip_associate_v2" "floatingip-access-proxy" {
  floating_ip = openstack_networking_floatingip_v2.floatip-access-proxy.address
  port_id = openstack_networking_port_v2.IT-network-access-proxy-port.id
}

data "openstack_images_image_v2" "debian12" {
    name_regex = "^Debian 12 generic amd64 .*"
    most_recent = true
}

resource "openstack_compute_instance_v2" "access-proxy" {
  name = "attack_range-access-proxy"
  flavor_name = "standard.small"

  image_id = data.openstack_images_image_v2.debian12.id
  key_pair = "iai_vm-cyberrange-host"
  security_groups = ["default", openstack_networking_secgroup_v2.secgroup_access-proxy.name]

  network {
    access_network = true
    port = openstack_networking_port_v2.IT-network-access-proxy-port.id
  }

  stop_before_destroy = false

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'proxy,' access_proxy.yml"     
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'proxy,' make_ansible_controller.yml"
  }

  connection {
    type     = "ssh"
    user     = "debian"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-access-proxy.address
  }
}

resource "openstack_networking_secgroup_v2" "secgroup_access-proxy" {
  name        = "attack_range-access-proxy-sg"
  description = "Security group for Attack Ranges Access Proxy"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_access-proxy_socks" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1080
  port_range_max    = 1080
  remote_ip_prefix  = "10.1.2.0/24"
  security_group_id = openstack_networking_secgroup_v2.secgroup_access-proxy.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_access-proxy_smb" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 445
  port_range_max    = 445
  remote_ip_prefix  = "10.0.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.secgroup_access-proxy.id
}

#-------------------------------
# Quick Test Server for Debugging
#-------------------------------

# resource "openstack_compute_instance_v2" "internal-test-server-2" {
#    name = "internal-test-server"
#    flavor_name = "m1.medium"
#    image_id = data.openstack_images_image_v2.debian12.id
#    key_pair = "iai_vm-cyberrange-host"
#    security_groups = ["default"]

#    network {
#       access_network = true
#       uuid = openstack_networking_network_v2.attack_range-network.id
#       fixed_ip_v4 = "10.0.1.123"
#    }
# }

# resource "openstack_compute_instance_v2" "internal-test-server-2" {
#    name = "internal-test-server"
#    flavor_name = "m1.medium"
#    image_id = data.openstack_images_image_v2.debian12.id
#    key_pair = "iai_vm-cyberrange-host"
#    security_groups = ["default"]

#    network {
#       access_network = true
#       uuid = openstack_networking_network_v2.attack_range-network.id
#       fixed_ip_v4 = "10.0.1.123"
#    }

#    provisioner "local-exec" {
#      command = "echo ip: ${self.access_ip_v4}"
#    }
# }