#!/bin/bash 

echo "Nice, you found this file!"
echo "However, it will and can not run all on its own."
echo "There are some parts that require interactivity"
echo "Other setup parts *must* be done manually, either by ui or ssh"
echo "This file is a reference on what to do in which order to setup the infrastructure"
exit 1

## files auf vm hochladen
cd  Cyberrange\ Configs/new/
scp -r .  cyberrange-copy:/home/iai/attack_range_openstack


##
ssh cyberrange-copy
cd attack_range_openstack/
cd 1_resource_generation/
terraform plan
terraform apply

cd ../2_ansible_resource_provisioning/

ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.12"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.14"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.15"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.16"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.17"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.18"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.1.20"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.12"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.18"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.15"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.14"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.16"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.2.17"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.4.97"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.5.64"
ssh-keygen -f "/home/iai/.ssh/known_hosts" -R "10.0.6.42"

ansible-playbook -l 'proxy,' playbooks/access_proxy.yml
ansible-playbook -l 'proxy,' make_ansible_controller.yml
ssh -A debian@10.1.3.179 # ip ist float ip von proxy
export LC_ALL="C.UTF-8";
cd ../../2_ansible_resource_provisioning/


# auf jeden windows host einmal per spice console draufgehen, als TestAdmin anmelden mit virtual keyboard, winrm commands ausführen


ssh -A TestAdmin@10.0.1.15

echo 'start winrm setup' > C:\winrm_log2.txt
echo 'quickconfig:' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
powershell winrm quickconfig >> C:\winrm_log2.txt
echo 'winrs shell memory:' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"} >> C:\winrm_log2.txt
echo 'winrs timeout: ' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
winrm set winrm/config @{MaxTimeoutms="1800000"} >> C:\\winrm_log2.txt
echo 'allow unencrypted: ' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
winrm set winrm/config/service @{AllowUnencrypted="true"} >> C:\\winrm_log2.txt
echo 'basic auth:' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
winrm set winrm/config/service/auth @{Basic="true"} >> C:\\winrm_log2.txt
net stop winrm
echo 'autostart:' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
powershell Set-Service -Name winrm -StartupType Automatic >> C:\\winrm_log2.txt
net start winrm 
echo 'enable ps remoting' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force" >> C:\\winrm_log2.txt
echo 'enumerate:' >> C:\winrm_log2.txt
echo '' >> C:\winrm_log2.txt
winrm enumerate winrm/config/Listener >> C:\\winrm_log2.txt
exit

ssh -A TestAdmin@10.0.1.18

winrm quickconfig -q
winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
winrm set winrm/config @{MaxTimeoutms="1800000"}
winrm set winrm/config/service @{AllowUnencrypted="true"}
winrm set winrm/config/service/auth @{Basic="true"}
net stop winrm
powershell Set-Service -Name winrm -StartupType Automatic
net start winrm
powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"
winrm enumerate winrm/config/Listener
exit

ssh -A TestAdmin@10.0.1.14

winrm quickconfig -q
winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
winrm set winrm/config @{MaxTimeoutms="1800000"}
winrm set winrm/config/service @{AllowUnencrypted="true"}
winrm set winrm/config/service/auth @{Basic="true"}
net stop winrm
powershell Set-Service -Name winrm -StartupType Automatic
net start winrm
powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"
winrm enumerate winrm/config/Listener
exit

ssh -A TestAdmin@10.0.2.15

winrm quickconfig -q
winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
winrm set winrm/config @{MaxTimeoutms="1800000"}
winrm set winrm/config/service @{AllowUnencrypted="true"}
winrm set winrm/config/service/auth @{Basic="true"}
net stop winrm
powershell Set-Service -Name winrm -StartupType Automatic
net start winrm
powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"
winrm enumerate winrm/config/Listener
exit

ssh -A TestAdmin@10.0.2.18

winrm quickconfig -q
winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
winrm set winrm/config @{MaxTimeoutms="1800000"}
winrm set winrm/config/service @{AllowUnencrypted="true"}
winrm set winrm/config/service/auth @{Basic="true"}
net stop winrm
powershell Set-Service -Name winrm -StartupType Automatic
net start winrm
powershell -Command "Enable-PSRemoting -SkipNetworkProfileCheck -Force"
winrm enumerate winrm/config/Listener
exit

# zurück auf proxy
ansible-playbook -l  'windows_gateway_server,' windows_dc.yml

# danach wieder per spice console auf domain controller zugreifen und berechtigungen für ad geben
# -> active directory -> users -> testadmin ->  properties -> security -> add -> suche selektoren auf computer -> AR-WIN-GATEWAY -> add -> reboot

# zurück auf proxy
ansible-playbook -l  'windows_gateway_server,' windows.yml 
ansible-playbook -l  'windows_sql_server,' windows.yml
ansible-playbook -l  'windows_sql_server,' windows_sql.yml
ansible-playbook -l  'windows_workstation,' windows.yml
ansible-playbook -l  'windows_engineering,' windows.yml
ansible-playbook -l  'windows_operating,' windows.yml

ssh -A TestAdmin@10.0.1.15
msiexec /i "C:\\join_domain.ps1 attackrange.local TestAdmin@attackrange.local secreT123%"
exit

ssh -A TestAdmin@10.0.1.18
msiexec /i "C:\\join_domain.ps1 attackrange.local TestAdmin@attackrange.local secreT123%"
exit

ssh -A TestAdmin@10.0.1.14
msiexec /i "C:\\join_domain.ps1 attackrange.local TestAdmin@attackrange.local secreT123%"
exit

ssh -A TestAdmin@10.0.2.15
msiexec /i "C:\\join_domain.ps1 attackrange.local TestAdmin@attackrange.local secreT123%"
exit

ssh -A TestAdmin@10.0.2.18
msiexec /i "C:\\join_domain.ps1 attackrange.local TestAdmin@attackrange.local secreT123%" 
exit

# das wird eventuell nicht immer funktionieren, daher da, wo es nicht geht nochmal grafisch drauf gehen und über control panel der attackrange.local domain joinen


# zurück auf proxy
ansible-playbook -l  'plc_linux,' linux.yml

# manuelle einrichtungen auf den windows hosts
# outlook login via spice console
# in outlook programmatic access deaktivieren
# überprüfen, dass alle firewalls aus sind

logout

# zurück auf host
# splunk nochmal manuell starten. es wird angenommen, dass das playbook in terraform schon durchgelaufen ist
ssh -o ProxyCommand="ssh -A -p 22 -W %h:%p -q -l debian 10.1.3.152" debian@10.0.1.12
/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd Pl3ase-k1Ll-me:p
sudo usermod -a -G users debian
sudo login -f debian
sudo chmod -R 755 /opt/splunk/var/
# splunk server listener port aufsetzen unter web interface -> settings -> data inputs -> receiver, port 9997
# über browser einer windows maschine via spice console
