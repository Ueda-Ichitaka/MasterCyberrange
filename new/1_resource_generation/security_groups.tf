
#------------------------------------
# attack_range-windows-remote-security_group
#------------------------------------

resource "openstack_networking_secgroup_v2" "secgroup_windows_remote" {
  name        = "attack_range-windows-remote-sg"
  description = "Security group for Windows"
}

resource "openstack_networking_secgroup_rule_v2" "rdp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3389
  port_range_max    = 3389
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_windows_remote.id
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_windows_remote.id
}

resource "openstack_networking_secgroup_rule_v2" "win_kali_egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6000
  port_range_max    = 9000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_windows_remote.id
}

resource "openstack_networking_secgroup_rule_v2" "win_kali_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6000
  port_range_max    = 9000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_windows_remote.id
}


resource "openstack_networking_secgroup_rule_v2" "anyv6egress" {
  direction         = "egress"
  ethertype         = "IPv6"
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_windows_remote.id
}

resource "openstack_networking_secgroup_rule_v2" "anyvingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_windows_remote.id
}


resource "openstack_networking_secgroup_rule_v2" "anyv6ingress" {
  direction         = "ingress"
  ethertype         = "IPv6"
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_windows_remote.id
}

resource "openstack_networking_secgroup_rule_v2" "winrm" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5985
  port_range_max    = 5986
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_windows_remote.id
}

resource "openstack_networking_secgroup_rule_v2" "winrm2" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5985
  port_range_max    = 5986
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_windows_remote.id
}

resource "openstack_networking_secgroup_rule_v2" "rpci" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 135
  port_range_max    = 135
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_windows_remote.id
}

resource "openstack_networking_secgroup_rule_v2" "rpce" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 135
  port_range_max    = 135
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_windows_remote.id
}

#------------------------------------
# splunk_universal_forwarder-security_group
#------------------------------------

resource "openstack_networking_secgroup_v2" "secgroup_splunk_universal_forwarder" {
  name        = "secgroup_splunk_universal_forwarder"
  description = "Security group to allow splunk universal forwarders to send to splunk server"
}

resource "openstack_networking_secgroup_rule_v2" "splunk_universal_forwarder" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9997
  port_range_max    = 9997
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.id
}

#------------------------------------
# splunk_server-security_group
#------------------------------------

resource "openstack_networking_secgroup_v2" "secgroup_splunk_server" {
  name        = "secgroup_splunk_server"
   description = "Security group to allow splunk server to receive data from splunk universal forwarder"
}

resource "openstack_networking_secgroup_rule_v2" "splunk_server" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8089
  port_range_max    = 8089
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_splunk_server.id
}

#------------------------------------
# attack_range-internal-security_group
#------------------------------------

resource "openstack_networking_secgroup_v2" "secgroup_attack_range_internal" {
  name        = "secgroup_attack_range_internal"
  description = "Unrestricted communication on the internal attack range network"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_ipv4_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_attack_range_internal.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_ipv6_ingress" {
  direction         = "ingress"
  ethertype         = "IPv6"
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_attack_range_internal.id
}



#------------------------------------
# kali-security_group
#------------------------------------


resource "openstack_networking_secgroup_v2" "secgroup_kali" {
  name        = "secgroup_kali"
  description = "Allow some Ports for Server use"
}


resource "openstack_networking_secgroup_rule_v2" "ingress_kali" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6000
  port_range_max    = 9000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_kali.id
}

resource "openstack_networking_secgroup_rule_v2" "egress_kali" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6000
  port_range_max    = 9000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_kali.id
}



resource "openstack_networking_secgroup_rule_v2" "rpci_kali" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 135
  port_range_max    = 135
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_kali.id
}

resource "openstack_networking_secgroup_rule_v2" "rpce_kali" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 135
  port_range_max    = 135
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_kali.id
}