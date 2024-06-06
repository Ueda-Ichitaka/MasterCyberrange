#-----------------------
# Config
#-----------------------

data "openstack_compute_keypair_v2" "default_keypair" {
  name = "iai_vm-cyberrange-host"
}


#-----------------------------------------------------------------------------------------------


#-----------------------
# Internal IT Network
#-----------------------

resource "openstack_networking_network_v2" "IT-network" {
  name = "IT-network"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "IT-subnet" {
  network_id = openstack_networking_network_v2.IT-network.id
  name = "IT-subnet"
  cidr = "10.0.1.0/24"
}

resource "openstack_networking_port_v2" "IT-network-port_1" {
  name               = "port_1"
  network_id         = openstack_networking_network_v2.IT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.1.12"
    subnet_id  = openstack_networking_subnet_v2.IT-subnet.id
  }
}

resource "openstack_networking_port_v2" "IT-network-port_2" {
  name               = "port_2"
  network_id         = openstack_networking_network_v2.IT-network.id
  admin_state_up     = "true"

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.IT-subnet.id
  }
}


# resource "openstack_networking_port_v2" "IT-network-port_3" {
#   name               = "port_3"
#   network_id         = openstack_networking_network_v2.IT-network.id
#   admin_state_up     = "true"

#   fixed_ip {
#     subnet_id  = openstack_networking_subnet_v2.IT-subnet.id
#   }
# }


# resource "openstack_networking_port_v2" "IT-network-port_4" {
#   name               = "port_4"
#   network_id         = openstack_networking_network_v2.IT-network.id
#   admin_state_up     = "true"

#   fixed_ip {
# #    ip_address = "10.0.1.17"
#     subnet_id  = openstack_networking_subnet_v2.IT-subnet.id
#   }
# }






# Splunk floatingIP, not necessary with proxy use
# resource "openstack_networking_floatingip_v2" "floatip_1" {
#   pool = "public"
# }

resource "openstack_networking_floatingip_v2" "floatip_2" {
  pool = "public"
}

# resource "openstack_networking_floatingip_associate_v2" "splunk_floatingip_1" {
#   floating_ip = openstack_networking_floatingip_v2.floatip_1.address
#   port_id = openstack_networking_port_v2.attack_range-network-port_1.id
# }

resource "openstack_networking_router_v2" "IT_router" {
  name                = "IT_router"
  admin_state_up      = true
  external_network_id = "b4def106-3c27-4de8-9848-434dacf07ba3"  ### CHANGE ME!IT_
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.IT_router.id
  subnet_id = openstack_networking_subnet_v2.IT-subnet.id
}


#-----------------------
# Internal OT Network
#-----------------------

resource "openstack_networking_network_v2" "OT-network" {
  name = "OT-network"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "OT-subnet" {
  network_id = openstack_networking_network_v2.OT-network.id
  name = "OT-subnet"
  cidr = "10.0.2.0/24"
}

resource "openstack_networking_port_v2" "OT-network-port_1" {
  name               = "port_1"
  network_id         = openstack_networking_network_v2.OT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.2.12"
    subnet_id  = openstack_networking_subnet_v2.OT-subnet.id
  }
}




# Splunk floatingIP, not necessary with proxy use
# resource "openstack_networking_floatingip_v2" "floatip_1" {
#   pool = "public"
# }

resource "openstack_networking_floatingip_v2" "floatip_2_OT" {
  pool = "public"
}

# resource "openstack_networking_floatingip_associate_v2" "splunk_floatingip_1" {
#   floating_ip = openstack_networking_floatingip_v2.floatip_1.address
#   port_id = openstack_networking_port_v2.attack_range-network-port_1.id
# }



#----------------------------------------------------------------------------------------------


#-----------------------
# Splunk Server
#-----------------------

resource "openstack_compute_instance_v2" "splunk-server" {
   name = "splunk-server"
   flavor_name = "m1.medium"
   #image_id = "e4c61468-4c60-484d-bbb9-7ac42a1440bf" #debian-10-openstack-arm64-splunk-base
   #image_id = "28e7b185-4428-4c00-b82c-51aa1809e8f7" #bionic-server-cloudimg-20230607-amd64
   image_id = "63688ae7-c167-41e5-80db-164ef5714eef" #debian 12
   key_pair = data.openstack_compute_keypair_v2.default_keypair.name
   security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_splunk_server.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,       ### Wo wird das _internal definiert?
    ]

   network {
      access_network = true
      port = openstack_networking_port_v2.IT-network-port_1.id                  
   }

   network {
      access_network = true
      port = openstack_networking_port_v2.OT-network-port_1.id                  
   }   

  # connection {
  #   type     = "ssh"
  #   user     = "ubuntu"
  #   private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
  #   host     = openstack_networking_floatingip_v2.floatip_1.address
  # }

  # provisioner "remote-exec" {
  #   inline = ["echo Test >> test.txt"]
  # }
}


#---------------------------------------------------------------------------------------------------------------------


#-----------------------
# APT29 Windows Workstation
#-----------------------

data "openstack_images_image_v2" "win10" {
    #name_regex = "^Windows 10 Eval x86_64$"
    name = "windows-10-amd64"
    most_recent = true
}

resource "openstack_compute_instance_v2" "APT29-Windows-Workstation" {
  name = "APT29-Windows-Workstation"
  flavor_name = "m1.medium"
  image_id = data.openstack_images_image_v2.win10.id
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_windows_remote.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,       ### WOher kommt internal?
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
  - 'powershell -Command "Enable-PSRemoting -SkipNetworkProfileChapt29_Target-Win10Workstation2eck -Force"'
EOF

   network {
      access_network = true
      name = openstack_networking_network_v2.IT-network.name
      fixed_ip_v4 = "10.0.1.15"
   }
}


#-----------------------
# Attacker-Kali
#-----------------------
resource "openstack_networking_floatingip_v2" "floatip_3" {
  pool = "public"
}

resource "openstack_networking_port_v2" "IT-network-port_3" {
  name               = "port_3"
  network_id         = openstack_networking_network_v2.IT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.1.17"
    subnet_id  = openstack_networking_subnet_v2.IT-subnet.id
  }
}

# resource "openstack_networking_floatingip_associate_v2" "attacker_kali_floatingip_3" {
#   floating_ip = openstack_networking_floatingip_v2.floatip_3.address
#   port_id = openstack_networking_port_v2.IT-network-port_3.id
# }

resource "openstack_compute_instance_v2" "Attacker-Kali" {
   name = "Attacker-Kali"
   flavor_name = "m1.medium"
   image_id = "bf8afd2a-f61b-4e2d-a747-caf2803c8d37"
   key_pair = data.openstack_compute_keypair_v2.default_keypair.name

   network {
      access_network = true
      port = openstack_networking_port_v2.IT-network-port_3.id
   }

   stop_before_destroy = false

  connection {
    type     = "ssh"
    user     = "kali"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip_3.address
  }
}



#------------------------------------
# Windows SQL Server
#------------------------------------
data "openstack_images_image_v2" "winserver2022" {
    name_regex = "^Windows Server 2022 Eval x86_64$"
    most_recent = true
}

resource "openstack_compute_instance_v2" "Windows-SQL-Server" {
  name            = "Windows-SQL-Server"
  image_id        = data.openstack_images_image_v2.winserver2022.id
  flavor_name     = "m1.medium"
  #key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_windows_remote.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,
    openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.name,
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
    winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}'I
  - |
    winrm set winrm/config '@{MaxTimeoutms="1800000"}'
  - |
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'   network {
#       access_network = true
#       name = openstack_networking_network_v2.IT-network.name
#       fixed_ip_v4 = "10.0.1.16"
#    }
  - |
    winrm set winrm/config/service/auth '@{Basic="true"}'
  - 'netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow'
  - 'netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow'
  - 'net stop winrm'
  - 'sc.exe config winrm start=auto'
  - 'net start winrm'
  - 'powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"'
EOF

  #block_device {
  #  uuid = "260fb6f4-9faf-433a-8939-5b840e1b4e1c"
  #  source_type = "image"
  #  boot_index = "1"
  #  device_type = "cdrom"
  #  destination_type = "local"s to be authenticated for it to work depending on bios security sett
  #  delete_on_termination = true
  #}

  #provisioner "remote-exec" {
  #  inline = ["echo booted"]
  #
  #  connection {
  #    type     = "winrm"
  #    user     = "TestAdmin"
  #    password = "secreT123%"
  #    host     = openstack_networking_floatingip_v2.floatip_4.address
  #    port     = 5986
  #    insecure = true
  #    https    = true
  #  }
  #}

  #provisioner "local-exec" {
  #  working_dir = "../2_ansible_resource_provisioning"
  #  command = "ansible-playbook -i '${openstack_networking_floatingip_v2.floatip_4.address},' windows.yml --extra-vars 'ansible_user=TestAdmin ansible_password=secreT123% ansible_winrm_operation_timeout_sec=120 ansible_winrm_read_timeout_sec=150 ansible_port=5986 attack_range_password=secreT123% use_prebuilt_images_with_packer=0 cloud_provider=local splunk_uf_win_url=https://download.splunk.com/products/universalforwarder/releases/9.0.5/windows/splunkforwarder-9.0.5-e9494146ae5c-x64-release.msi'"
  #}

  ## packer would execute until this point

  #provisioner "local-exec" {I
  #  working_dir = "../ansible"
  #  command = "ansible-playbook -i '${openstack_compute_instance_v2.test-server.network[0].fixed_ip_v4},' windows_post.yml --extra-vars 'ansible_user=TestAcc ansible_password=secreT123% ansible_winrm_operation_timeout_sec=120 ansible_winrm_read_timeout_sec=150 attack_range_password=secreT123% ansible_port=5986'"
  #}

  network {
    access_network = true
    port = openstack_networking_port_v2.IT-network-port_4.id
  }


}

resource "openstack_networking_floatingip_v2" "floatip_4" {
  pool = "public"
}

resource "openstack_networking_port_v2" "IT-network-port_4" {
  name               = "port_4"
  network_id         = openstack_networking_network_v2.IT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.1.18"
    subnet_id  = openstack_networking_subnet_v2.IT-subnet.id
  }
}

# resource "openstack_networking_floatingip_associate_v2" "windows_test_floatingip_4" {
#   floating_ip = openstack_networking_floatingip_v2.floatip_4.address
#   port_id = openstack_networking_port_v2.IT-network-port_4.id
# }





#------------------------------------
# Windows Gateway Server
#------------------------------------
data "openstack_images_image_v2" "winserver2022_2" {
    name_regex = "^Windows Server 2022 Eval x86_64$"
    most_recent = true
}

resource "openstack_compute_instance_v2" "Windows-Gateway-Server" {
  name            = "Windows-Gateway-Server"
  image_id        = data.openstack_images_image_v2.winserver2022_2.id
  flavor_name     = "m1.medium"
  #key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_windows_remote.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,
    openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.name,
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
  - |apt29_Target-Win10Workstation2
    winrm set winrm/config '@{MaxTimeoutms="1800000"}'
  - |
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'   network {
#       access_network = true
#       name = openstack_networking_network_v2.IT-network.name
#       fixed_ip_v4 = "10.0.1.16"
#    }
  - |
    winrm set winrm/config/service/auth '@{Basic="true"}'
  - 'netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dientrale Lieferzufahrt am Campus Nord in Eggenstein-Leopoldshafen ist montags bis
donnerstags von 8.00-12.00 Uhr u. von 13.00-15.00 Uhr; freitags nur von 8.00-13.00 Uhr
geöffnet. Bitte Lier=in localport=5985 action=allow'
  - 'netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow'
  - 'net stop winrm'
  - 'sc.exe config winrm start=auto'
  - 'net start winrm'
  - 'powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"'
EOF

  #block_device {
  #  uuid = "260fb6f4-9faf-433a-8939-5b840e1b4e1c"
  #  source_type = "image"
  #  boot_index = "1"
  #  device_type = "cdrom"
  #  destination_type = "local"s to be authenticated for it to work depending on bios security sett
  #  delete_on_termination = true
  #}

  #provisioner "remote-exec" {
  #  inline = ["echo booted"]
  #
  #  connection {
  #    type     = "winrm"
  #    user     = "TestAdmin"
  #    password = "secreT123%"
  #    host     = openstack_networking_floatingip_v2.floatip_4.address
  #    port     = 5986
  #    insecure = true
  #    https    = true
  #  }
  #}

  #provisioner "local-exec" {
  #  working_dir = "../2_ansible_resource_provisioning"
  #  command = "ansible-playbook -i '${openstack_networking_floatingip_v2.floatip_4.address},' windows.yml --extra-vars 'ansible_user=TestAdmin ansible_password=secreT123% ansible_winrm_operation_timeout_sec=120 ansible_winrm_read_timeout_sec=150 ansible_port=5986 attack_range_password=secreT123% use_prebuilt_images_with_packer=0 cloud_provider=local splunk_uf_win_url=https://download.splunk.com/products/universalforwarder/releases/9.0.5/windows/splunkforwarder-9.0.5-e9494146ae5c-x64-release.msi'"
  #}

  ## packer would execute until this point

  #provisioner "local-exec" {
  #  working_dir = "../ansible"
  #  command = "ansible-playbook -i '${openstack_compute_instance_v2.test-server.network[0].fixed_ip_v4},' windows_post.yml --extra-vars 'ansible_user=TestAcc ansible_password=secreT123% ansible_winrm_operation_timeout_sec=120 ansible_winrm_read_timeout_sec=150 attack_range_password=secreT123% ansible_port=5986'"
  #}

#   network {
#     access_network = true
#     port = openstack_networking_port_v2.IT-network-port_4.id
#   }

   network {  
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      #fixed_ip_v4 = "10.0.2.18"
   }

   network {  
      access_network = true
      name = openstack_networking_network_v2.IT-network.name
      fixed_ip_v4 = "10.0.1.16"
   }   


}

resource "openstack_networking_floatingip_v2" "floatip_5" {
  pool = "public"
}

# resource "openstack_networking_port_v2" "IT-network-port_4" {
#   name               = "port_4"
#   network_id         = openstack_networking_network_v2.IT-network.id
#   admin_state_up     = "true"

#   fixed_ip {
#     ip_address = "10.0.1.16"
#     subnet_id  = openstack_networking_subnet_v2.IT-subnet.
#   }
# }

# resource "openstack_networking_floatingip_associate_v2" "windows_test_floatingip_4" {
#   floating_ip = openstack_networking_floatingip_v2.floatip_4.address
#   port_id = openstack_networking_port_v2.IT-network-port_4.id
# }






#-----------------------------------------------------------------------------------------


#-----------------------
# APT29 Windows Engineering-PC
#-----------------------

data "openstack_images_image_v2" "win10_2" {
    #name_regex = "^Windows 10 Eval x86_64$"
    name = "windows-10-amd64"
    most_recent = true
}

resource "openstack_compute_instance_v2" "APT29-Engineering-PC" {
  name = "APT29-Engineering-PC"
  flavor_name = "m1.medium"
  image_id = data.openstack_images_image_v2.win10_2.id
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_windows_remote.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,       ### WOher kommt internal?
    ]
  user_data = <<EOF
#cloud-config
users:
  - name: Admin
    inactive: True
  - name: TestAdmin
    passwd: secreT123%
    primary_group: Administratorsresource "openstack_networking_port_v2" "IT-network-port_3" {
  name               = "port_3"
  network_id         = openstack_networking_network_v2.IT-network.id
  admin_state_up     = "true"apt29_Target-Win10Workstation2

  fixed_ip {
    ip_address = "10.0.1.17"
    subnet_id  = openstack_networking_subnet_v2.IT-subnet.id
  }
}
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
  - name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.15"
   }
} 'powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"'
EOF

   network {
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.15"
   }
}




#-----------------------
# APT29 Windows Operating-PC
#-----------------------

data "openstack_images_image_v2" "win10_3" {
    #name_regex = "^Windows 10 Eval x86_64$"
    name = "windows-10-amd64"
    most_recent = true
}

resource "openstack_compute_instance_v2" "APT29-Operating-PC" {
  name = "APT29-Operating-PC"
  flavor_name = "m1.medium"
  image_id = data.openstack_images_image_v2.win10_3.id
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_windows_remote.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,       ### WOher kommt internal?
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
  - |   network {
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.15"
   }
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
  - |
    winrm set winrm/config/service/auth '@{Basic="true"}'
  - 'netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow'
  - 'netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow'
  - 'net stop winrm'
  - 'sc.exe config winrm start=auto'
  - 'net start winrm'
  - name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.15"
   }
} 'powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"'
EOF

   network {  
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.18"
   }
}




#-----------------------
# Linux PLC
#-----------------------

# resource "openstack_networking_port_v2" "OT-network-plc-port" {
#   name               = "plc-port"
#   network_id         = openstack_networking_network_v2.OT-network.id
#   admin_state_up     = "true"

#   fixed_ip {
#     ip_address = "10.0.2.17"
#     subnet_id  = openstack_networking_subnet_v2.OT-subnet.id
#   }
# }

data "openstack_images_image_v2" "PLC_Linux" {
    name_regex = "^ubuntu-focal.*"
    most_recent = true
}

resource "openstack_compute_instance_v2" "PLC_Linux" {
  name = "PLC_Linux"
  flavor_name = "standard.small"

  image_id = "d508e903-4f41-491e-bf41-b0cbc0f1712a"    #data.openstack_images_image_v2.ubuntu_test.id
  key_pair = "iai_vm-cyberrange-host"
  security_groups = ["default",openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.name]

   network {  
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.17"
   }


#   network {
#     access_network = true
#     port = openstack_networking_port_v2.OT-network-plc-port.id
# #    name = openstack_networking_network_v2.OT-network.name
# #    fixed_ip_v4 = "10.0.2.15"
#   }


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



#-----------------------
# Linux HMI
#-----------------------

# resource "openstack_networking_port_v2" "OT-network-hmi-port" {
#   name               = "hmi-port"
#   network_id         = openstack_networking_network_v2.OT-network.id
#   admin_state_up     = "true"

#   fixed_ip {
#     ip_address = "10.0.2.16"
#     subnet_id  = openstack_networking_subnet_v2.OT-subnet.id
#   }
# }

data "openstack_images_image_v2" "HMI_Linux" {
    name_regex = "^ubuntu-focal.*"
    most_recent = true
}

resource "openstack_compute_instance_v2" "HMI_Linux" {
  name = "HMI_Linux"
  flavor_name = "standard.small"

  image_id = "d508e903-4f41-491e-bf41-b0cbc0f1712a"  # data.openstack_images_image_v2.ubuntu_test.id
  key_pair = "iai_vm-cyberrange-host"
  security_groups = ["default",openstack_networking_secgroup_v2.secgroup_splunk_universal_forwarder.name]

#   network {
#     access_network = true
#     port = openstack_networking_port_v2.OT-network-hmi-port.id
#   }

   network {  
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.16"
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
