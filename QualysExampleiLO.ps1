# Robert Ryan NA Technology and Solution Center
# This program should allow out of boxing of new ProLiant Servers Gen10-Gen10+
Write-Host "Hello, this program will auto connect to a iLO based ProLiant Server and out-of-box the out of band MGMT"

# Get all variable information and append center domain name to iLO 
$iloHostname = Read-Host -Prompt 'Please Enter the hostname of the iLO from the toe-tag?'
#$iloHostname = $iloHostname + '.atlpss.hp.net'
$iloPassword = Read-Host -Prompt 'Please Enter the the iLO password'
$desiredIPaddress = Read-Host -Prompt 'What new IPddress would you like on the iLO interface?'
$licenseKey = "3n7cc-5p3vh-z3nqy-3bpnw-6txh2"

$connection = Connect-HPEiLO -IP $iloHostname -Username hpadmin -Password $iloPassword -DisableCertificateAuthentication
$connection
sleep 1
# Set iLO Advanced license key that enable remote console
Set-HPEiLOLicense -Connection $connection -Key $licenseKey
write-host 'Added the license key to the iLO'
sleep 1

# Add hpadmin user 
Add-HPEiLOUser -Connection $connection -Username test -Password atlpresales -LoginName test -UserConfigPrivilege Yes -iLOConfigPrivilege Yes -RemoteConsolePrivilege Yes -VirtualMediaPrivilege Yes -VirtualPowerAndResetPrivilege Yes -HostBIOSConfigPrivilege Yes -HostNICConfigPrivilege Yes -HostStorageConfigPrivilege Yes -LoginPrivilege Yes
write-host 'Added the hpadmin account to the iLO'
sleep 1

Add-HPEiLOUser -Connection $connection -Username QualysAdmin -Password atlpresales -LoginName QualysAdmin -UserConfigPrivilege Yes -iLOConfigPrivilege Yes -RemoteConsolePrivilege Yes -VirtualMediaPrivilege Yes -VirtualPowerAndResetPrivilege Yes -HostBIOSConfigPrivilege Yes -HostNICConfigPrivilege Yes -HostStorageConfigPrivilege Yes -LoginPrivilege Yes
write-host 'Added the QualysAdmin account to the iLO'
sleep 1

Add-HPEiLOUser -Connection $connection -Username EndClientQualysAdmin -Password atlpresales -LoginName EndClientQualysAdmin -UserConfigPrivilege Yes -iLOConfigPrivilege Yes -RemoteConsolePrivilege Yes -VirtualMediaPrivilege Yes -VirtualPowerAndResetPrivilege Yes -HostBIOSConfigPrivilege Yes -HostNICConfigPrivilege Yes -HostStorageConfigPrivilege Yes -LoginPrivilege Yes
write-host 'Added the EndClientQualysAdmin account to the iLO'
sleep 1

#Set IPv4 Settings
$connection | Set-HPEiLOIPv4NetworkSetting -InterfaceType Dedicated -DHCPv4Enabled No -IPv4Address $desiredIPaddress -IPv4Gateway 10.10.1.4 -IPv4SubnetMask 255.255.0.0 -NICEnabled Yes 
write-host 'Changed the IPv4 settings on the iLO, now reseting iLO to End Customer IP Scheme'
Reset-HPEiLO -Connection $connection -Device iLO 
sleep 1