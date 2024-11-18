Enable-PSRemoting -Force
$ps = New-PSSession
Invoke-Command -Session $ps -ScriptBlock { 
    cd "C:\Program Files\Wireshark\"
    Start-Process .\tshark.exe -ArgumentList "-i 1 -w C:\Export-EventLogs\capture.pcapng -q"
}
Start-Sleep -Seconds 10
Disconnect-PSSession $ps