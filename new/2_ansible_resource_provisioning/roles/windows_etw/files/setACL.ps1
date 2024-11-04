
# Set access control list on File System
$TargetFolder = "C:\"
$AuditUser = "Everyone"  #English
#$AuditUser = "Jeder"   #German
#$AuditRules = "Read"
$AuditRules = "FullControl"
$InheritType = "ContainerInherit,ObjectInherit"
#$AuditType = "Success"
$AuditType = "Success,Failure"
$AccessRule = New-Object System.Security.AccessControl.FileSystemAuditRule($AuditUser,$AuditRules,$InheritType,"None",$AuditType)
$ACL = Get-Acl $TargetFolder
$ACL.SetAuditRule($AccessRule)
$ACL | Set-Acl $TargetFolder
Write-Host "Audit Policy on File System applied successfully."

<# $TargetFolders = Get-Content C:\Input.txt
$AuditUser = "Everyone"
$AuditRules = "Delete,DeleteSubdirectoriesAndFiles,ChangePermissions,Takeownership"
$InheritType = "ContainerInherit,ObjectInherit"
$AuditType = "Success"
$AccessRule = New-Object System.Security.AccessControl.FileSystemAuditRule($AuditUser,$AuditRules,$InheritType,"None",$AuditType)
foreach ($TargetFolder in $TargetFolders)
{
    $ACL = Get-Acl $TargetFolder
    $ACL.SetAuditRule($AccessRule)
    Write-Host "Processing >",$TargetFolder
    $ACL | Set-Acl $TargetFolder
}
Write-Host "Audit Policy applied successfully." #>


# Set access control list on Registry
#$TargetKeys = @("HKLM:\","HKCU:\","HKU:\","HKCC:\","HKCR:\")
New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS # only the HKLM and HKCU drives referencing registry locations are defined by default
$TargetKeys = @("HKLM:\","HKCU:\","HKU:\")
$sid = New-Object System.Security.Principal.SecurityIdentifier("S-1-1-0") # User, in this case "Everyone"
#$AuditRules = "SetValue,CreateSubKey,Delete" 
#$AuditRules = "EnumerateSubKeys,QueryValues,ReadKey"
$AuditRules = "FullControl"
$InheritType = "ContainerInherit,ObjectInherit"
#$AuditType = "Success"
$AuditType ="Success,Failure"
$AccessRule = New-Object System.Security.AccessControl.RegistryAuditRule($sid,$AuditRules,$InheritType,"none",$AuditType)
foreach ($TargetKey in $TargetKeys)
{
    $ACL = Get-Acl $TargetKey
    $ACL.SetAuditRule($AccessRule)
    Write-Host "Processing >",$TargetKey
    $ACL | Set-Acl $TargetKey
}
Write-Host "Audit Policy on Registry applied successfully."


# Set access control list on Active Directory objects
#Import-Module activedirectory
#Set-Location AD:





