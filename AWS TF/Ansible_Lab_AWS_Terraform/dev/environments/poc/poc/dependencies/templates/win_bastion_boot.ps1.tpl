<powershell>
Import-Module AWSPowerShell
$UserAccount = Get-LocalUser -Name "administrator"
$UserAccount | Set-LocalUser -Password (ConvertTo-SecureString -AsPlainText "${pass}" -Force) 
Rename-LocalUser -Name "administrator" -NewName ${uname}
Restart-Computer
</powershell>