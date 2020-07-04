#Set-ExecutionPolicy Bypass -Scope Process -Force
#Requires -Version 3.0
# Configure a Windows host for remote management with Ansible
# -----------------------------------------------------------
#
#This is a modified version of the Ansible PS script to enable Ansible remoting into a windows host.

#This is the third part of three steps to automate certificate authentication. 
    #The first step is to generate the self signed cert and copy to c:\temp. The file name is hard coded to be cert.pem
    #The Second step is to copy over a 'creds.text' to c:\temp\
        #the script reads the first two lines of the file with get-content
        #first line: account
        #second line: account password
    #The third step is to run this script on the target server through terraform
#This modified Verison adds steps to:
#   Import a generated self signed cert as long as its copied from a remote server to the Root CA and Personal cert Store
#   Link cert to local user account
#   Configure server for cert authentication
# Docs: https://adamtheautomator.com/winrm-https-ansible/#create-the-winrm-listener
# Docs: https://vnuggets.com/2019/08/08/ansible-certificate-authentication-to-windows/ 
#
# This script checks the current WinRM (PS Remoting) configuration and makes
# the necessary changes to allow Ansible to connect, authenticate and
# execute PowerShell commands.
#
# All events are logged to the Windows EventLog, useful for unattended runs.
#
# Use option -Verbose in order to see the verbose output messages.
#
# Use option -ForceNewSSLCert if the system has been SysPreped and a new
# SSL Certificate must be forced on the WinRM Listener when re-running this
# script. This is necessary when a new SID and CN name is created.
#
# Use option -EnableCredSSP to enable CredSSP as an authentication option.
#
# Use option -DisableBasicAuth to disable basic authentication.
#
# Use option -SkipNetworkProfileCheck to skip the network profile check.
# Without specifying this the script will only run if the device's interfaces
# are in DOMAIN or PRIVATE zones.  Provide this switch if you want to enable
# WinRM on a device with an interface in PUBLIC zone.
#
# Use option -SubjectName to specify the CN name of the certificate. This
# defaults to the system's hostname and generally should not be specified.

# Support -Verbose option
Function Main
{
    [CmdletBinding()]
    
    Param (
        [string]$SubjectName = $env:COMPUTERNAME,
        [switch]$SkipNetworkProfileCheck,
        $CreateSelfSignedCert = $true,
        [switch]$ForceNewSSLCert,
        [switch]$GlobalHttpFirewallAccess,
        [switch]$DisableBasicAuth = $false,
        [switch]$EnableCredSSP
    )
    
    Function Write-Log
    {
        $Message = $args[0]
        Write-EventLog -LogName Application -Source $EventSource -EntryType Information -EventId 1 -Message $Message
    }
    
    Function Write-VerboseLog
    {
        $Message = $args[0]
        Write-Verbose $Message
        Write-Log $Message
    }
    
    Function Write-HostLog
    {
        $Message = $args[0]
        Write-Output $Message
        Write-Log $Message
    }
    Function Enable-GlobalHttpFirewallAccess
    {
        Write-Verbose "Forcing global HTTP firewall access"
        # this is a fairly naive implementation; could be more sophisticated about rule matching/collapsing
        $fw = New-Object -ComObject HNetCfg.FWPolicy2
    
        # try to find/enable the default rule first
        $add_rule = $false
        $matching_rules = $fw.Rules | Where-Object  { $_.Name -eq "Windows Remote Management (HTTP-In)" }
        $rule = $null
        If ($matching_rules) {
            If ($matching_rules -isnot [Array]) {
                Write-Verbose "Editing existing single HTTP firewall rule"
                $rule = $matching_rules
            }
            Else {
                # try to find one with the All or Public profile first
                Write-Verbose "Found multiple existing HTTP firewall rules..."
                $rule = $matching_rules | ForEach-Object { $_.Profiles -band 4 }[0]
    
                If (-not $rule -or $rule -is [Array]) {
                    Write-Verbose "Editing an arbitrary single HTTP firewall rule (multiple existed)"
                    # oh well, just pick the first one
                    $rule = $matching_rules[0]
                }
            }
        }
    
        If (-not $rule) {
            Write-Verbose "Creating a new HTTP firewall rule"
            $rule = New-Object -ComObject HNetCfg.FWRule
            $rule.Name = "Windows Remote Management (HTTP-In)"
            $rule.Description = "Inbound rule for Windows Remote Management via WS-Management. [TCP 5985]"
            $add_rule = $true
        }
    
        $rule.Profiles = 0x7FFFFFFF
        $rule.Protocol = 6
        $rule.LocalPorts = 5985
        $rule.RemotePorts = "*"
        $rule.LocalAddresses = "*"
        $rule.RemoteAddresses = "*"
        $rule.Enabled = $true
        $rule.Direction = 1
        $rule.Action = 1
        $rule.Grouping = "Windows Remote Management"
    
        If ($add_rule) {
            $fw.Rules.Add($rule)
        }
    
        Write-Verbose "HTTP firewall rule $($rule.Name) updated"
    }
    
    # Setup error handling.
    Trap
    {
        $_
        Exit 1
    }
    $ErrorActionPreference = "Stop"
    
    # Get the ID and security principal of the current user account
    $myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
    $myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
    
    # Get the security principal for the Administrator role
    $adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
    
    # Check to see if we are currently running "as Administrator"
    if (-Not $myWindowsPrincipal.IsInRole($adminRole))
    {
        Write-Output "ERROR: You need elevated Administrator privileges in order to run this script."
        Write-Output "       Start Windows PowerShell by using the Run as Administrator option."
        Exit 2
    }
    
    $EventSource = $MyInvocation.MyCommand.Name
    If (-Not $EventSource)
    {
        $EventSource = "Powershell CLI"
    }
    
    If ([System.Diagnostics.EventLog]::Exists('Application') -eq $False -or [System.Diagnostics.EventLog]::SourceExists($EventSource) -eq $False)
    {
        New-EventLog -LogName Application -Source $EventSource
    }
    
    # Detect PowerShell version.
    If ($PSVersionTable.PSVersion.Major -lt 3)
    {
        Write-Log "PowerShell version 3 or higher is required."
        Throw "PowerShell version 3 or higher is required."
    }
    
    # Find and start the WinRM service.
    Write-Verbose "Verifying WinRM service."
    If (!(Get-Service "WinRM"))
    {
        Write-Log "Unable to find the WinRM service."
        Throw "Unable to find the WinRM service."
    }
    ElseIf ((Get-Service "WinRM").Status -ne "Running")
    {
        Write-Verbose "Setting WinRM service to start automatically on boot."
        Set-Service -Name "WinRM" -StartupType Automatic
        Write-Log "Set WinRM service to start automatically on boot."
        Write-Verbose "Starting WinRM service."
        Start-Service -Name "WinRM" -ErrorAction Stop
        Write-Log "Started WinRM service."
    
    }
    
    # WinRM should be running; check that we have a PS session config.
    If (!(Get-PSSessionConfiguration -Verbose:$false) -or (!(Get-ChildItem WSMan:\localhost\Listener)))
    {
      If ($SkipNetworkProfileCheck) {
        Write-Verbose "Enabling PS Remoting without checking Network profile."
        Enable-PSRemoting -SkipNetworkProfileCheck -Force -ErrorAction Stop
        Write-Log "Enabled PS Remoting without checking Network profile."
      }
      Else {
        Write-Verbose "Enabling PS Remoting."
        Enable-PSRemoting -Force -ErrorAction Stop
        Write-Log "Enabled PS Remoting."
      }
    }
    Else
    {
        Write-Verbose "PS Remoting is already enabled."
    }
    
    # Ensure LocalAccountTokenFilterPolicy is set to 1
    # https://github.com/ansible/ansible/issues/42978
    $token_path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    $token_prop_name = "LocalAccountTokenFilterPolicy"
    $token_key = Get-Item -Path $token_path
    $token_value = $token_key.GetValue($token_prop_name, $null)
    if ($token_value -ne 1) {
        Write-Verbose "Setting LocalAccountTOkenFilterPolicy to 1"
        if ($null -ne $token_value) {
            Remove-ItemProperty -Path $token_path -Name $token_prop_name
        }
        New-ItemProperty -Path $token_path -Name $token_prop_name -Value 1 -PropertyType DWORD > $null
    }
    
    # Make sure there is a SSL listener.
    $listeners = Get-ChildItem WSMan:\localhost\Listener
    If (!($listeners | Where-Object {$_.Keys -like "TRANSPORT=HTTPS"}))
    {
        $thumbprint = (New-SelfSignedCertificate -DnsName $SubjectName -CertStoreLocation 'Cert:\LocalMachine\My').Thumbprint
        Write-HostLog "Self-signed SSL certificate generated; thumbprint: $thumbprint"
    
        # Create the hashtables of settings to be used.
        $valueset = @{
            Hostname = $SubjectName
            CertificateThumbprint = $thumbprint
        }
    
        $selectorset = @{
            Transport = "HTTPS"
            Address = "*"
        }
    
        Write-Verbose "Enabling SSL listener."
        New-WSManInstance -ResourceURI 'winrm/config/Listener' -SelectorSet $selectorset -ValueSet $valueset
        Write-Log "Enabled SSL listener."
    }
    Else
    {
        Write-Verbose "SSL listener is already active."
    
        # Force a new SSL cert on Listener if the $ForceNewSSLCert
        If ($ForceNewSSLCert)
        {
            $thumbprint = (New-SelfSignedCertificate -DnsName $SubjectName -CertStoreLocation 'Cert:\LocalMachine\My').Thumbprint
            Write-HostLog "Self-signed SSL certificate generated; thumbprint: $thumbprint"
            #
            
            $valueset = @{
                CertificateThumbprint = $thumbprint
                Hostname = $SubjectName
            }
    
            # Delete the listener for SSL
            $selectorset = @{
                Address = "*"
                Transport = "HTTPS"
            }
            Remove-WSManInstance -ResourceURI 'winrm/config/Listener' -SelectorSet $selectorset
    
            # Add new Listener with new SSL cert
            New-WSManInstance -ResourceURI 'winrm/config/Listener' -SelectorSet $selectorset -ValueSet $valueset
            
        }
    }
    
    # Check for basic authentication.
    $basicAuthSetting = Get-ChildItem WSMan:\localhost\Service\Auth | Where-Object {$_.Name -eq "Basic"}
    
    If ($DisableBasicAuth)
    {
        If (($basicAuthSetting.Value) -eq $true)
        {
            Write-Verbose "Disabling basic auth support."
            Set-Item -Path "WSMan:\localhost\Service\Auth\Basic" -Value $false
            Write-Log "Disabled basic auth support."
        }
        Else
        {
            Write-Verbose "Basic auth is already disabled."
        }
    }
    Else
    {
        If (($basicAuthSetting.Value) -eq $false)
        {
            Write-Verbose "Enabling basic auth support."
            Set-Item -Path "WSMan:\localhost\Service\Auth\Basic" -Value $true
            Write-Log "Enabled basic auth support."
        }
        Else
        {
            Write-Verbose "Basic auth is already enabled."
        }
    }
    
    # If EnableCredSSP if set to true
    If ($EnableCredSSP)
    {
        # Check for CredSSP authentication
        $credsspAuthSetting = Get-ChildItem WSMan:\localhost\Service\Auth | Where-Object {$_.Name -eq "CredSSP"}
        If (($credsspAuthSetting.Value) -eq $false)
        {
            Write-Verbose "Enabling CredSSP auth support."
            Enable-WSManCredSSP -role server -Force
            Write-Log "Enabled CredSSP auth support."
        }
    }
    
    If ($GlobalHttpFirewallAccess) {
        Enable-GlobalHttpFirewallAccess
    }
    
    # Configure firewall to allow WinRM HTTPS connections.
    $fwtest1 = netsh advfirewall firewall show rule name="Allow WinRM HTTPS"
    $fwtest2 = netsh advfirewall firewall show rule name="Allow WinRM HTTPS" profile=any
    If ($fwtest1.count -lt 5)
    {
        Write-VerboseLog "Adding firewall rule to allow WinRM HTTPS."
        netsh advfirewall firewall add rule profile=any name="Allow WinRM HTTPS" dir=in localport=5986 protocol=TCP action=allow
        Write-Log "Added firewall rule to allow WinRM HTTPS."
    }
    ElseIf (($fwtest1.count -ge 5) -and ($fwtest2.count -lt 5))
    {
        Write-VerboseLog "Updating firewall rule to allow WinRM HTTPS for any profile."
        netsh advfirewall firewall set rule name="Allow WinRM HTTPS" new profile=any
        Write-Log "Updated firewall rule to allow WinRM HTTPS for any profile."
    }
    Else
    {
        Write-Log "Firewall rule already exists to allow WinRM HTTPS."
    }
    
    # Test a remoting connection to localhost, which should work.
    $httpResult = Invoke-Command -ComputerName "localhost" -ScriptBlock {$env:COMPUTERNAME} -ErrorVariable httpError -ErrorAction SilentlyContinue
    $httpsOptions = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
    
    $httpsResult = New-PSSession -UseSSL -ComputerName "localhost" -SessionOption $httpsOptions -ErrorVariable httpsError -ErrorAction SilentlyContinue
    
    If ($httpResult -and $httpsResult)
    {
        Write-VerboseLog "HTTP: Enabled | HTTPS: Enabled"
    }
    ElseIf ($httpsResult -and !$httpResult)
    {
        Write-VerboseLog "HTTP: Disabled | HTTPS: Enabled"
    }
    ElseIf ($httpResult -and !$httpsResult)
    {
        Write-VerboseLog "HTTP: Enabled | HTTPS: Disabled"
    }
    Else
    {
        Write-VerboseLog "Unable to establish an HTTP or HTTPS remoting session."
        Throw "Unable to establish an HTTP or HTTPS remoting session."
    }
    Write-VerboseLog "PS Remoting has been successfully configured for Ansible."
    ##
    #Import generated selfsigned cert from remote server
    if(Test-Path "C:\temp\cert.pem" )
    {
        Write-VerboseLog "Importing generated cert.pem"
        $pubKeyFilePath = 'C:\temp\cert.pem'
        ## Import the public key into Trusted Root Certification Authorities and Trusted People
        $null = Import-Certificate -FilePath $pubKeyFilePath -CertStoreLocation 'Cert:\LocalMachine\Root'
        $null = Import-Certificate -FilePath $pubKeyFilePath -CertStoreLocation 'Cert:\LocalMachine\TrustedPeople'
        Write-VerboseLog "Certificate has been added to Root and Trusted People Locations"
    }
    else
    {
        Write-VerboseLog "certificate not copied to c:\temp"
        exit
    }
    
    #Link cert to local user account
    if(Test-Path "C:\temp\creds.txt")
    {
        
        $cred = get-content "C:\temp\creds.txt"
        if($cred.count -eq "2")
        {
            Write-VerboseLog "Linking Cert to local user account.Account: $testUserAccountName"
            $testUserAccountName = "$($cred[0])"
            $testUserAccountPassword = (ConvertTo-SecureString -String "$($cred[1])" -AsPlainText -Force )
            $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $testUserAccountName, $testUserAccountPassword
            ## Find the cert thumbprint for the client certificate created on the Ansible host
            $ansibleCert = Get-ChildItem -Path 'Cert:\LocalMachine\Root' | Where-Object {$_.Subject -eq 'CN=administrator'}
            
            $params = @{
                Path = 'WSMan:\localhost\ClientCertificate'
                Subject = "$testUserAccountName@localhost"
                URI = '*'
                Issuer = $ansibleCert.Thumbprint
              Credential = $credential
                Force = $true
            }
            New-Item @params
        }
    }
    else
    {
        Write-VerboseLog "Credentials not found in C:\temp\creds.txt."
    }
    #configure server for credential authentication
    Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true 
    
    #cleanup
    Remove-Item -Path "c:\temp\*" -Force
    Write-VerboseLog "Script complete."

}
Main