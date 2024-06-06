# resource "openstack_networking_port_v2" "windows_server_2012_domain_server_port" {
#   name               = "windows_server_2012_domain_server_port"
#   network_id         = openstack_networking_network_v2.attack_range-network.id
#   admin_state_up     = "true"

#   fixed_ip {
#     ip_address = "10.0.1.6"
#     subnet_id  = openstack_networking_subnet_v2.attack_range-subnet.id
#   }
# }

# data "openstack_images_image_v2" "windows_server_2012" {
#     name_regex = "^windows_server_2012_domain_server*"
#     most_recent = true
# }

# resource "openstack_compute_instance_v2" "windows_server_2012_domain_server" {
#   name            = "windows_server_2012_domain_server"
#   image_id        = data.openstack_images_image_v2.windows_server_2012.id
#   flavor_name     = "m1.medium"
#   security_groups = ["default",openstack_networking_secgroup_v2.secgroup_windows_server.name]
#   user_data = <<EOF
# #cloud-config
# users:
#   - name: Admin
#     inactive: True
#   - name: admin
#     passwd: add123!%
#     primary_group: Administrators
#     inactive: False
# runcmd:
#   - 'winrm quickconfig -q'
#   - |
#     winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}'
#   - |
#     winrm set winrm/config '@{MaxTimeoutms="1800000"}'
#   - |
#     winrm set winrm/config/service '@{AllowUnencrypted="true"}'
#   - |
#     winrm set winrm/config/service/auth '@{Basic="true"}'
#   - 'netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow'
#   - 'netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow'
#   - 'net stop winrm'
#   - 'sc.exe config winrm start=auto'
#   - 'net start winrm'
#   - 'powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"'
# EOF

#   provisioner "remote-exec" {
#     inline = ["echo booted"]

#     connection {
#       type     = "winrm"
#       user     = "admin"
#       password = "add123!"
#       host     = openstack_networking_floatingip_v2.windows_server_2012_floating_ip.address
#       port     = 5986
#       insecure = true
#       https    = true
#     }
#   }

#   provisioner "local-exec" {
#     working_dir = "../2_ansible_resource_provisioning"
#     command = "ansible-playbook -i '${openstack_networking_floatingip_v2.windows_server_2012_floating_ip.address},' windows.yml --extra-vars 'ansible_user=TestAdmin ansible_password=secreT123% ansible_winrm_operation_timeout_sec=120 ansible_winrm_read_timeout_sec=150 ansible_port=5986 attack_range_password=secreT123% use_prebuilt_images_with_packer=0 cloud_provider=local splunk_uf_win_url=https://download.splunk.com/products/universalforwarder/releases/9.0.5/windows/splunkforwarder-9.0.5-e9494146ae5c-x64-release.msi'"
#   }

#   network {
#     access_network = true
#     port = openstack_networking_port_v2.windows_server_2012_domain_server_port.id
#   }
# }

# resource "openstack_networking_floatingip_v2" "windows_server_2012_floating_ip" {
#   pool = "public"
# }

# resource "openstack_networking_floatingip_associate_v2" "windows_server_2012_floating_ip_associate" {
#   floating_ip = openstack_networking_floatingip_v2.windows_server_2012_floating_ip.address
#   port_id = openstack_networking_port_v2.windows_server_2012_domain_server_port.id
# }