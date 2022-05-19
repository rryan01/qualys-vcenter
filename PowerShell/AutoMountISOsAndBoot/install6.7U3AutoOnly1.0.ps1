Write-Output "When entering the ip you can use a range like this '10.10.198.105-107' or just a single ip is fine"
$ipaddresses = Read-Host "Please Enter the iLO IP addresses to connect to: "
# This is where you will modify which servers to connect to 
$connection = Connect-HPEiLO -IP $ipaddresses -Username hpadmin -Password atlpresales -DisableCertificateAuthentication
sleep 5
Write-Output "You are now connected to these host"
$connection
sleep 3
Write-Output 'Now removing any existing attached virtual media before new ISO is attached'
Dismount-HPEiLOVirtualMedia -Connection  $connection -Device CD
sleep 3
Write-Output " "
Mount-HPEiLOVirtualMedia -Connection $connection -Device CD -ImageURL http://10.10.124.10/esx67u3ksUpdatemarch2020-1.iso
Write-Output "Current Connections: "
$connection
$continue = Read-Host "Now please confirm once more that these are the correct servers 'y' for yes 'n' to exit and quit" `n "The reason why I ask because this script can do serious damage on our network"
if ($continue -eq 'y') {
	Write-Output "This script will continue processing"
}
else {
	exit
}
sleep 5
Set-HPEiLOVirtualMediaStatus -Connection $connection -VMBootOption BootOnNextReset -Device CD | out-null
Set-HPEiLOOneTimeBootOption -Connection $connection -BootSourceOverrideTarget CD
sleep 3
Write-Output "Now powering off Servers"
sleep 8
Set-HPEiLOServerPower -Connection $connection -Power Off
Write-Output "Now powering ON Servers"
sleep 8
Set-HPEiLOServerPower -Connection $connection -Power On
Write-Output "Now after 15 minutes this host machine will disconnect from the ilo's  "
Write-Output "This should be plenty of time for the kickstart ISO to install  "
sleep 900
Disconnect-HPEiLO -Connection $connection
