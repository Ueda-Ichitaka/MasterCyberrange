
resource "openstack_networking_port_v2" "IT-network-access-proxy-port" {
  name               = "access-proxy-port"
  network_id         = openstack_networking_network_v2.IT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.1.5"
    subnet_id  = openstack_networking_subnet_v2.IT-subnet.id
  }
}


resource "openstack_networking_port_v2" "APT-network-access-proxy-port" {
  name               = "access-proxy-port"
  network_id         = openstack_networking_network_v2.APT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.4.5"
    subnet_id  = openstack_networking_subnet_v2.APT-subnet.id
  }
}


resource "openstack_networking_floatingip_v2" "floatip-access-proxy" {
  pool = "public1"
}

resource "openstack_networking_floatingip_associate_v2" "floatingip-access-proxy" {
  floating_ip = openstack_networking_floatingip_v2.floatip-access-proxy.address
  port_id = openstack_networking_port_v2.IT-network-access-proxy-port.id
}

data "openstack_images_image_v2" "debian12" {
    name_regex = "^Debian 12 generic amd64 .*"
    most_recent = true
}

resource "openstack_compute_flavor_v2" "proxy-flavor" {
    name = "proxy-flavor"
    ram = "2048"
    vcpus = "1"
    disk = "100"
    swap = "4096"
}

resource "openstack_compute_instance_v2" "access-proxy" {
  name = "attack_range-access-proxy"
  #flavor_name = "standard.medium"
  flavor_id = openstack_compute_flavor_v2.proxy-flavor.id
  image_id = data.openstack_images_image_v2.debian12.id
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = ["default", openstack_networking_secgroup_v2.secgroup_access-proxy.id]

  network {
    access_network = true
    port = openstack_networking_port_v2.IT-network-access-proxy-port.id
  }

   network {  
      access_network = true
      port = openstack_networking_port_v2.APT-network-access-proxy-port.id
   }   

  stop_before_destroy = false

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'proxy,' playbooks/access_proxy.yml"     
  }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'proxy,' playbooks/make_ansible_controller.yml"
  # }

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

