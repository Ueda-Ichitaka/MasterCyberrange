#-----------------------
# Windows Victim
#-----------------------

data "openstack_images_image_v2" "winserver2019" {
    name_regex = "^Windows Server 2019 Eval x86_64$"
    most_recent = true
}

resource "openstack_compute_instance_v2" "windows-server-2019-test" {
  name = "windows_2019_test"
  flavor_name = "m1.medium"
  image_id = data.openstack_images_image_v2.winserver2019.id
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_windows_remote.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,
    ]
  user_data = <<EOF
#cloud-config
users:
  - name: Admin
    inactive: True
  - name: TestAdmin
    passwd: secreT123%
    primary_group: Administrators
    inactive: False
runcmd:
  - 'winrm quickconfig -q'
  - |
    winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}'
  - |
    winrm set winrm/config '@{MaxTimeoutms="1800000"}'
  - |
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
  - |
    winrm set winrm/config/service/auth '@{Basic="true"}'
  - 'netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow'
  - 'netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow'
  - 'net stop winrm'
  - 'sc.exe config winrm start=auto'
  - 'net start winrm'
  - 'powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"'
EOF

   network {
      access_network = true
      name = openstack_networking_network_v2.attack_range-network.name
      fixed_ip_v4 = "10.0.1.16"
   }
}
