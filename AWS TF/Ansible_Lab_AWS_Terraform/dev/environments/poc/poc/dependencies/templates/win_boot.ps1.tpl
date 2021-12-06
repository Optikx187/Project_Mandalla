<powershell>
Import-Module AWSPowerShell
New-Item -ItemType Directory -Path "C:\temp\"
New-Item -ItemType Directory -Path "C:\apps\"
New-Item -ItemType Directory -Path "C:\media\"
#additional directories

$SecretAD = "${sm_key}"
$SecretObj = (Get-SECSecretValue -SecretId $SecretAD)
$Secret = ($SecretObj.SecretString  | ConvertFrom-Json)
$password   = $Secret.Password | ConvertTo-SecureString -asPlainText -Force
$UserAccount = Get-LocalUser -Name "administrator"
$UserAccount | Set-LocalUser -Password $Password
Rename-LocalUser -Name "administrator" -NewName ${uname}

Invoke-Expression ((New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))

Invoke-WebRequest https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe -OutFile "c:\temp\SSMAgent_latest.exe"
Start-Process -FilePath "c:\temp\SSMAgent_latest.exe" -ArgumentList "/S"

Restart-Computer
</powershell>