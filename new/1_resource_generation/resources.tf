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


resource "openstack_networking_port_v2" "IT-network-port_5" {
  name               = "port_5"
  network_id         = openstack_networking_network_v2.IT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.1.13"
    subnet_id  = openstack_networking_subnet_v2.IT-subnet.id
  }
}




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
  external_network_id = "b4def106-3c27-4de8-9848-434dacf07ba3"  ### ID von public network
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



resource "openstack_networking_port_v2" "OT-network-port_2" {
  name               = "port_2"
  network_id         = openstack_networking_network_v2.OT-network.id
  admin_state_up     = "true"

  fixed_ip {
    ip_address = "10.0.2.13"
    subnet_id  = openstack_networking_subnet_v2.OT-subnet.id
  }
}



# Splunk floatingIP, not necessary with proxy use
resource "openstack_networking_floatingip_v2" "floatip_1" {
  pool = "public"
}



resource "openstack_networking_floatingip_v2" "floatip_2_OT" {
  pool = "public"
}

# resource "openstack_networking_floatingip_associate_v2" "splunk_floatingip_1" {
#   floating_ip = openstack_networking_floatingip_v2.floatip_1.address
#   port_id = openstack_networking_port_v2.attack_range-network-port_1.id
# }



resource "openstack_networking_router_interface_v2" "router_interface_2" {
  router_id = openstack_networking_router_v2.IT_router.id
  subnet_id = openstack_networking_subnet_v2.OT-subnet.id
}


#----------------------------------------------------------------------------------------------


#-----------------------
# Splunk Server
#-----------------------

resource "openstack_compute_instance_v2" "splunk-server" {
   name = "splunk-server"
   flavor_name = "standard.large"
   #image_id = "e4c61468-4c60-484d-bbb9-7ac42a1440bf" #debian-10-openstack-arm64-splunk-base
   #image_id = "28e7b185-4428-4c00-b82c-51aa1809e8f7" #bionic-server-cloudimg-20230607-amd64
   image_id = "63688ae7-c167-41e5-80db-164ef5714eef" #debian 12
   key_pair = data.openstack_compute_keypair_v2.default_keypair.name
   admin_pass = "secreT123%"
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

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
      host     = openstack_networking_floatingip_v2.floatip_1.address
    }


  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'splunk_server,' make_splunk_server_os.yml"
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'splunk_server,' splunk_server.yml"
  }


}


#---------------------------------------------------------------------------------------------------------------------






#-----------------------
# ELK Server
#-----------------------

resource "openstack_compute_instance_v2" "elk-server" {
   name = "elk-server"
   flavor_name = "standard.large"
   #image_id = "e4c61468-4c60-484d-bbb9-7ac42a1440bf" #debian-10-openstack-arm64-splunk-base
   #image_id = "28e7b185-4428-4c00-b82c-51aa1809e8f7" #bionic-server-cloudimg-20230607-amd64
   image_id = "63688ae7-c167-41e5-80db-164ef5714eef" #debian 12
   key_pair = data.openstack_compute_keypair_v2.default_keypair.name
   admin_pass = "secreT123%"
   security_groups = [
    "default",
    openstack_networking_secgroup_v2.secgroup_splunk_server.name,
    openstack_networking_secgroup_v2.secgroup_attack_range_internal.name,       ### Wo wird das _internal definiert?
    ]

   network {
      access_network = true
      port = openstack_networking_port_v2.IT-network-port_5.id                  
   }

   network {
      access_network = true
      port = openstack_networking_port_v2.OT-network-port_2.id                  
   }   

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
      host     = openstack_networking_floatingip_v2.floatip_2.address
    }


  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'elk_server,' elk_server.yml"
  }


}


#---------------------------------------------------------------------------------------------------------------------






#-----------------------
# APT29 Windows Workstation
#-----------------------

data "openstack_images_image_v2" "win10" {
    name_regex = "^Windows Server 2019 Eval x86_64$"
    #name = "windows-10-amd64"
    most_recent = true
}

resource "openstack_compute_instance_v2" "APT29-Windows-Workstation" {
  name = "APT29-Windows-Workstation"
  flavor_name = "m1.medium"
  image_id = "b34c1867-728f-4d7b-839c-06c05a108088"  #Windows Server 2019 Eval 
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
  - name TestUser
    passwd: secreT123%
    primary_group: Users
    inactive: False  
runcmd:
  - 'netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow'
  - 'netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8000 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8000 action=allow'  
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8089 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8089 action=allow'  
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8065 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8065 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8191 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8191 action=allow' 
  - 'echo test >> C:\out.txt'
  - |
    powershell -Command "Set-ItemProperty -Path HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name UseWUServer -Value 0"
  - |
    powershell -Command "Restart-Service -Name wuauserv -Force"
  - |
    powershell -Command "Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*' | Add-WindowsCapability -Online"
  - 'echo test >> C:\ps.txt'
  - |
    powershell -Command " Echo Y | powershell Set-Item WSMan:\localhost\Client\TrustedHosts -Value '10.0.1.12,10.0.1.14,10.0.1.15,10.0.1.16,10.0.1.17,10.0.1.18,10.0.1.5,10.1.3.152'"
  - |
    powershell -Command " Echo Y | powershell Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*'"
  - 'echo test >> C:\hosts.txt'
  - 'powershell Set-Service -Name sshd -StartupType Automatic'
  - 'powershell Set-Service -Name ssh-agent -StartupType Automatic'  
  - 'net start "ssh-agent"'
  - 'net start "ssh"'  
  - 'echo test >> C:\net.txt'  
  - 'powershell New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" -Name UseLogonCredential -Value 1 -Force'
  - 'powershell New-Item -Path "HKLM:\SOFTWARE\Microsoft\Office\Outlook\Security" -Force'
  - 'powershell New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\Outlook\Security" -Name ObjectModelGuard -Value 2 -Force'
  - 'powershell New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\Outlook\Security" -Name PromtOOMSend -Value 2 -Force'
  - 'powershell New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\Outlook\Security" -Name AdminSecurityMode -Value 3 -Force'
  - 'powershell New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\Outlook\Security" -Name promtoomaddressinformationaccess -Value 2 -Force'
  - 'powershell New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\Outlook\Security" -Name promptoomaddressbookaccess -Value 2 -Force' 
  - 'netsh advfirewall firewall add rule name "SSH" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh"'
  - 'netsh advfirewall firewall add rule name "SSH-add" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-add"'
  - 'netsh advfirewall firewall add rule name "SSH-agent" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-agent"'
  - 'netsh advfirewall firewall add rule name "SSH-keygen" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keygen"'
  - 'netsh advfirewall firewall add rule name "SSH-keyscan" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keyscan"'
  - 'netsh advfirewall firewall add rule name "SSH" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh"'
  - 'netsh advfirewall firewall add rule name "SSH-add" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-add"'
  - 'netsh advfirewall firewall add rule name "SSH-agent" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-agent"'
  - 'netsh advfirewall firewall add rule name "SSH-keygen" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keygen"'
  - 'netsh advfirewall firewall add rule name "SSH-keyscan" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keyscan"'  
  - 'echo test >> C:\fw.txt'  
  - 'winrm quickconfig -q'
  - 'echo test >> C:\1.txt'
  - |
    winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
  - 'echo test >> C:\2.txt'
  - |
    winrm set winrm/config @{MaxTimeoutms="1800000"}
  - 'echo test >> C:\3.txt'
  - |
    winrm set winrm/config/service @{AllowUnencrypted="true"}
  - 'echo test >> C:\4.txt'
  - |
    winrm set winrm/config/service/auth @{Basic="true"}
  - 'echo test >> C:\5.txt'
  - 'net stop winrm'
  - 'echo test >> C:\6.txt'
  - 'powershell Set-Service -Name winrm -StartupType Automatic'
  - 'echo test >> C:\7.txt'
  - 'net start winrm'
  - 'echo test >> C:\8.txt'
  - 'powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"'
  - 'winrm enumerate winrm/config/Listener >> C:\wrm.txt'
EOF





   network {
      access_network = true
      name = openstack_networking_network_v2.IT-network.name
      fixed_ip_v4 = "10.0.1.15"
   }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_workstation,' windows.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_workstation,' windows_post.yml"
  # }


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
   admin_pass = "1337"


   network {
      access_network = true
      port = openstack_networking_port_v2.IT-network-port_3.id
   }

   stop_before_destroy = false

  connection {
    type     = "ssh"
    user     = "kali"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-access-proxy.address #openstack_networking_floatingip_v2.floatip_3.address
  }

  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'kali,' kali.yml"
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
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
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
  - name TestUser
    passwd: secreT123%
    primary_group: Users
    inactive: False  
runcmd:
  - 'netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow'
  - 'netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8000 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8000 action=allow'  
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8089 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8089 action=allow'  
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8065 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8065 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8191 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8191 action=allow' 
  - 'echo test >> C:\out.txt'
  - |
    powershell -Command "Set-ItemProperty -Path HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name UseWUServer -Value 0"
  - |
    powershell -Command "Restart-Service -Name wuauserv -Force"
  - |
    powershell -Command "Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*' | Add-WindowsCapability -Online"
  - 'echo test >> C:\ps.txt'
  - |
    powershell -Command " Echo Y | powershell Set-Item WSMan:\localhost\Client\TrustedHosts -Value '10.0.1.12,10.0.1.14,10.0.1.15,10.0.1.16,10.0.1.17,10.0.1.18,10.0.1.5,10.1.3.152'"
  - |
    powershell -Command " Echo Y | powershell Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*'"
  - 'echo test >> C:\hosts.txt'
  - 'powershell Set-Service -Name sshd -StartupType Automatic'
  - 'powershell Set-Service -Name ssh-agent -StartupType Automatic'  
  - 'net start "ssh-agent"'
  - 'net start "ssh"'  
  - 'echo test >> C:\net.txt'  
  - 'powershell New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" -Name UseLogonCredential -Value 1 -Force'
  - 'netsh advfirewall firewall add rule name "SSH" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh"'
  - 'netsh advfirewall firewall add rule name "SSH-add" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-add"'
  - 'netsh advfirewall firewall add rule name "SSH-agent" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-agent"'
  - 'netsh advfirewall firewall add rule name "SSH-keygen" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keygen"'
  - 'netsh advfirewall firewall add rule name "SSH-keyscan" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keyscan"'
  - 'netsh advfirewall firewall add rule name "SSH" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh"'
  - 'netsh advfirewall firewall add rule name "SSH-add" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-add"'
  - 'netsh advfirewall firewall add rule name "SSH-agent" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-agent"'
  - 'netsh advfirewall firewall add rule name "SSH-keygen" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keygen"'
  - 'netsh advfirewall firewall add rule name "SSH-keyscan" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keyscan"'  
  - 'echo test >> C:\fw.txt'  
  - 'winrm quickconfig -q'
  - 'echo test >> C:\1.txt'
  - |
    winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
  - 'echo test >> C:\2.txt'
  - |
    winrm set winrm/config @{MaxTimeoutms="1800000"}
  - 'echo test >> C:\3.txt'
  - |
    winrm set winrm/config/service @{AllowUnencrypted="true"}
  - 'echo test >> C:\4.txt'
  - |
    winrm set winrm/config/service/auth @{Basic="true"}
  - 'echo test >> C:\5.txt'
  - 'net stop winrm'
  - 'echo test >> C:\6.txt'
  - 'powershell Set-Service -Name winrm -StartupType Automatic'
  - 'echo test >> C:\7.txt'
  - 'net start winrm'
  - 'echo test >> C:\8.txt'
  - 'powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"'
  - 'winrm enumerate winrm/config/Listener >> C:\wrm.txt'
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

  # provisioner "local-exec" {
  #  working_dir = "../2_ansible_resource_provisioning"
  #  command = "ansible-playbook -i '${openstack_networking_floatingip_v2.floatip_4.address},' windows.yml --extra-vars 'ansible_user=TestAdmin ansible_password=secreT123% ansible_winrm_operation_timeout_sec=120 ansible_winrm_read_timeout_sec=150 ansible_port=5986 attack_range_password=secreT123% use_prebuilt_images_with_packer=0 cloud_provider=local splunk_uf_win_url=https://download.splunk.com/products/universalforwarder/releases/9.0.5/windows/splunkforwarder-9.0.5-e9494146ae5c-x64-release.msi'"
  # }

  # ## packer would execute until this point

  # provisioner "local-exec" {
  #  working_dir = "../ansible"
  #  command = "ansible-playbook -i '${openstack_compute_instance_v2.test-server.network[0].fixed_ip_v4},' windows_post.yml --extra-vars 'ansible_user=TestAcc ansible_password=secreT123% ansible_winrm_operation_timeout_sec=120 ansible_winrm_read_timeout_sec=150 attack_range_password=secreT123% ansible_port=5986'"
  # }

  connection {
    type     = "ssh"
    user     = "TestAdmin"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-access-proxy.address #openstack_networking_floatingip_v2.floatip_3.address
  }


  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_sql_server,' windows.yml --extra-vars 'ansible_user=TestAdmin ansible_password=secreT123% ansible_winrm_operation_timeout_sec=120 ansible_winrm_read_timeout_sec=150 ansible_port=5986 attack_range_password=secreT123% use_prebuilt_images_with_packer=0 cloud_provider=local splunk_uf_win_url=https://download.splunk.com/products/universalforwarder/releases/9.0.5/windows/splunkforwarder-9.0.5-e9494146ae5c-x64-release.msi'"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_sql_server,' windows_post.yml --extra-vars 'ansible_user=TestAcc ansible_password=secreT123% ansible_winrm_operation_timeout_sec=120 ansible_winrm_read_timeout_sec=150 attack_range_password=secreT123% ansible_port=5986'"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_sql_server,' windows_sql.yml"
  # }




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
  image_id        = data.openstack_images_image_v2.winserver2022.id
  flavor_name     = "m1.medium"
  key_pair = data.openstack_compute_keypair_v2.default_keypair.name
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
  - name TestUser
    passwd: secreT123%
    primary_group: Users
    inactive: False  
runcmd:
  - 'netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow'
  - 'netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8000 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8000 action=allow'  
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8089 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8089 action=allow'  
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8065 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8065 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8191 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8191 action=allow' 
  - 'echo test >> C:\out.txt'
  - |
    powershell -Command "Set-ItemProperty -Path HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name UseWUServer -Value 0"
  - |
    powershell -Command "Restart-Service -Name wuauserv -Force"
  - |
    powershell -Command "Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*' | Add-WindowsCapability -Online"
  - 'echo test >> C:\ps.txt'
  - |
    powershell -Command " Echo Y | powershell Set-Item WSMan:\localhost\Client\TrustedHosts -Value '10.0.1.12,10.0.1.14,10.0.1.15,10.0.1.16,10.0.1.17,10.0.1.18,10.0.1.5,10.1.3.152'"
  - |
    powershell -Command " Echo Y | powershell Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*'"
  - 'echo test >> C:\hosts.txt'
  - 'powershell Set-Service -Name sshd -StartupType Automatic'
  - 'powershell Set-Service -Name ssh-agent -StartupType Automatic'  
  - 'net start "ssh-agent"'
  - 'net start "ssh"'  
  - 'echo test >> C:\net.txt'  
  - 'powershell New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" -Name UseLogonCredential -Value 1 -Force'
  - 'netsh advfirewall firewall add rule name "SSH" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh"'
  - 'netsh advfirewall firewall add rule name "SSH-add" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-add"'
  - 'netsh advfirewall firewall add rule name "SSH-agent" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-agent"'
  - 'netsh advfirewall firewall add rule name "SSH-keygen" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keygen"'
  - 'netsh advfirewall firewall add rule name "SSH-keyscan" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keyscan"'
  - 'netsh advfirewall firewall add rule name "SSH" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh"'
  - 'netsh advfirewall firewall add rule name "SSH-add" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-add"'
  - 'netsh advfirewall firewall add rule name "SSH-agent" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-agent"'
  - 'netsh advfirewall firewall add rule name "SSH-keygen" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keygen"'
  - 'netsh advfirewall firewall add rule name "SSH-keyscan" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keyscan"'  
  - 'echo test >> C:\fw.txt'  
  - 'winrm quickconfig -q'
  - 'echo test >> C:\1.txt'
  - |
    winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
  - 'echo test >> C:\2.txt'
  - |
    winrm set winrm/config @{MaxTimeoutms="1800000"}
  - 'echo test >> C:\3.txt'
  - |
    winrm set winrm/config/service @{AllowUnencrypted="true"}
  - 'echo test >> C:\4.txt'
  - |
    winrm set winrm/config/service/auth @{Basic="true"}
  - 'echo test >> C:\5.txt'
  - 'net stop winrm'
  - 'echo test >> C:\6.txt'
  - 'powershell Set-Service -Name winrm -StartupType Automatic'
  - 'echo test >> C:\7.txt'
  - 'net start winrm'
  - 'echo test >> C:\8.txt'
  - 'powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"'
  - 'winrm enumerate winrm/config/Listener >> C:\wrm.txt'
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
  #  connection {     b34c1867-728f-4d7b-839c-06c05a108088 
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
      fixed_ip_v4 = "10.0.2.14"
   }

   network {  
      access_network = true
      name = openstack_networking_network_v2.IT-network.name
      fixed_ip_v4 = "10.0.1.14"
   }   


  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_gateway_server,' windows_dc.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_gateway_server,' windows.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_gateway_server,' windows_post.yml"
  # }  





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
    name_regex = "^Windows Server 2019 Eval x86_64$"
    #name = "windows-10-amd64"
    most_recent = true
}

resource "openstack_compute_instance_v2" "APT29-Engineering-PC" {
  name = "APT29-Engineering-PC"
  flavor_name = "m1.medium"
  image_id = "b34c1867-728f-4d7b-839c-06c05a108088" 
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
  - name TestUser
    passwd: secreT123%
    primary_group: Users
    inactive: False  
runcmd:
  - 'netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow'
  - 'netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8000 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8000 action=allow'  
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8089 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8089 action=allow'  
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8065 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8065 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8191 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8191 action=allow' 
  - 'echo test >> C:\out.txt'
  - |
    powershell -Command "Set-ItemProperty -Path HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name UseWUServer -Value 0"
  - |
    powershell -Command "Restart-Service -Name wuauserv -Force"
  - |
    powershell -Command "Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*' | Add-WindowsCapability -Online"
  - 'echo test >> C:\ps.txt'
  - |
    powershell -Command " Echo Y | powershell Set-Item WSMan:\localhost\Client\TrustedHosts -Value '10.0.1.12,10.0.1.14,10.0.1.15,10.0.1.16,10.0.1.17,10.0.1.18,10.0.1.5,10.1.3.152'"
  - |
    powershell -Command " Echo Y | powershell Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*'"
  - 'echo test >> C:\hosts.txt'
  - 'powershell Set-Service -Name sshd -StartupType Automatic'
  - 'powershell Set-Service -Name ssh-agent -StartupType Automatic'  
  - 'net start "ssh-agent"'
  - 'net start "ssh"'  
  - 'echo test >> C:\net.txt'  
  - 'powershell New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" -Name UseLogonCredential -Value 1 -Force'
  - 'netsh advfirewall firewall add rule name "SSH" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh"'
  - 'netsh advfirewall firewall add rule name "SSH-add" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-add"'
  - 'netsh advfirewall firewall add rule name "SSH-agent" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-agent"'
  - 'netsh advfirewall firewall add rule name "SSH-keygen" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keygen"'
  - 'netsh advfirewall firewall add rule name "SSH-keyscan" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keyscan"'
  - 'netsh advfirewall firewall add rule name "SSH" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh"'
  - 'netsh advfirewall firewall add rule name "SSH-add" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-add"'
  - 'netsh advfirewall firewall add rule name "SSH-agent" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-agent"'
  - 'netsh advfirewall firewall add rule name "SSH-keygen" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keygen"'
  - 'netsh advfirewall firewall add rule name "SSH-keyscan" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keyscan"'  
  - 'echo test >> C:\fw.txt'  
  - 'winrm quickconfig -q'
  - 'echo test >> C:\1.txt'
  - |
    winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
  - 'echo test >> C:\2.txt'
  - |
    winrm set winrm/config @{MaxTimeoutms="1800000"}
  - 'echo test >> C:\3.txt'
  - |
    winrm set winrm/config/service @{AllowUnencrypted="true"}
  - 'echo test >> C:\4.txt'
  - |
    winrm set winrm/config/service/auth @{Basic="true"}
  - 'echo test >> C:\5.txt'
  - 'net stop winrm'
  - 'echo test >> C:\6.txt'
  - 'powershell Set-Service -Name winrm -StartupType Automatic'
  - 'echo test >> C:\7.txt'
  - 'net start winrm'
  - 'echo test >> C:\8.txt'
  - 'powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"'
  - 'winrm enumerate winrm/config/Listener >> C:\wrm.txt'
EOF

   network {
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.15"
   }


  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_engineering,' windows.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_engineering,' windows_post.yml"
  # }





}




#-----------------------
# APT29 Windows Operating-PC
#-----------------------

data "openstack_images_image_v2" "win10_3" {
    name_regex = "^Windows Server 2019 Eval x86_64$"
    #name = "windows-10-amd64"
    most_recent = true
}

resource "openstack_compute_instance_v2" "APT29-Operating-PC" {
  name = "APT29-Operating-PC"
  flavor_name = "m1.medium"
  image_id = "b34c1867-728f-4d7b-839c-06c05a108088" 
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
  - name TestUser
    passwd: secreT123%
    primary_group: Users
    inactive: False  
runcmd:
  - 'netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow'
  - 'netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8000 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8000 action=allow'  
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8089 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8089 action=allow'  
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8065 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8065 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=in localport=8191 action=allow'
  - 'netsh advfirewall firewall add rule name="Splunk" protocol=TCP dir=out localport=8191 action=allow' 
  - 'echo test >> C:\out.txt'
  - |
    powershell -Command "Set-ItemProperty -Path HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name UseWUServer -Value 0"
  - |
    powershell -Command "Restart-Service -Name wuauserv -Force"
  - |
    powershell -Command "Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*' | Add-WindowsCapability -Online"
  - 'echo test >> C:\ps.txt'
  - |
    powershell -Command " Echo Y | powershell Set-Item WSMan:\localhost\Client\TrustedHosts -Value '10.0.1.12,10.0.1.14,10.0.1.15,10.0.1.16,10.0.1.17,10.0.1.18,10.0.1.5,10.1.3.152'"
  - |
    powershell -Command " Echo Y | powershell Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*'"
  - 'echo test >> C:\hosts.txt'
  - 'powershell Set-Service -Name sshd -StartupType Automatic'
  - 'powershell Set-Service -Name ssh-agent -StartupType Automatic'  
  - 'net start "ssh-agent"'
  - 'net start "ssh"'  
  - 'echo test >> C:\net.txt'  
  - 'powershell New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" -Name UseLogonCredential -Value 1 -Force'
  - 'netsh advfirewall firewall add rule name "SSH" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh"'
  - 'netsh advfirewall firewall add rule name "SSH-add" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-add"'
  - 'netsh advfirewall firewall add rule name "SSH-agent" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-agent"'
  - 'netsh advfirewall firewall add rule name "SSH-keygen" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keygen"'
  - 'netsh advfirewall firewall add rule name "SSH-keyscan" dir=in action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keyscan"'
  - 'netsh advfirewall firewall add rule name "SSH" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh"'
  - 'netsh advfirewall firewall add rule name "SSH-add" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-add"'
  - 'netsh advfirewall firewall add rule name "SSH-agent" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-agent"'
  - 'netsh advfirewall firewall add rule name "SSH-keygen" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keygen"'
  - 'netsh advfirewall firewall add rule name "SSH-keyscan" dir=out action=allow enable=yes program="C:\Windows\System32\OpenSSH\ssh-keyscan"'  
  - 'echo test >> C:\fw.txt'  
  - 'winrm quickconfig -q'
  - 'echo test >> C:\1.txt'
  - |
    winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
  - 'echo test >> C:\2.txt'
  - |
    winrm set winrm/config @{MaxTimeoutms="1800000"}
  - 'echo test >> C:\3.txt'
  - |
    winrm set winrm/config/service @{AllowUnencrypted="true"}
  - 'echo test >> C:\4.txt'
  - |
    winrm set winrm/config/service/auth @{Basic="true"}
  - 'echo test >> C:\5.txt'
  - 'net stop winrm'
  - 'echo test >> C:\6.txt'
  - 'powershell Set-Service -Name winrm -StartupType Automatic'
  - 'echo test >> C:\7.txt'
  - 'net start winrm'
  - 'echo test >> C:\8.txt'
  - 'powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"'
  - 'winrm enumerate winrm/config/Listener >> C:\wrm.txt'
EOF

   network {  
      access_network = true
      name = openstack_networking_network_v2.OT-network.name
      fixed_ip_v4 = "10.0.2.18"
   }


  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_operating,' windows.yml"
  # }

  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'windows_operating,' windows_post.yml"
  # }




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

   network {  
      access_network = true
      name = openstack_networking_network_v2.IT-network.name
      fixed_ip_v4 = "10.0.1.19"
   }


#   network {
#     access_network = true
#     port = openstack_networking_port_v2.OT-network-plc-port.id
# #    name = openstack_networking_network_v2.OT-network.name
# #    fixed_ip_v4 = "10.0.2.15"
#   }


  stop_before_destroy = false

  # Automatic execution of the corresponding ansible-playbook
  provisioner "local-exec" {
    working_dir = "../2_ansible_resource_provisioning"
    command = "ansible-playbook -l 'plc_linux,' linux.yml"
  }

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

   network {  
      access_network = true
      name = openstack_networking_network_v2.IT-network.name
      fixed_ip_v4 = "10.0.1.20"
   }   



  stop_before_destroy = false

  # # Automatic execution of the corresponding ansible-playbook
  # provisioner "local-exec" {
  #   working_dir = "../2_ansible_resource_provisioning"
  #   command = "ansible-playbook -l 'hmi_linux,' linux.yml"
  # }

  connection {
    type     = "ssh"
    user     = "debian"
    private_key = file("~/.ssh/id_ed25519") # iai_vm-cyberrange-host
    host     = openstack_networking_floatingip_v2.floatip-access-proxy.address
  }
}
