
#------------------------------------
# attack_range-windows-remote-sg
#------------------------------------

resource "openstack_networking_secgroup_v2" "secgroup_windows_remote" {
  name        = "attack_range-windows-remote-sg"
  description = "Security group for Windows Terraform test"
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

resource "openstack_networking_secgroup_rule_v2" "ssh2" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
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

#------------------------------------
# secgroup_splunk_universal_forwarder
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
# secgroup_splunk_server
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
# attack_range-internal
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
