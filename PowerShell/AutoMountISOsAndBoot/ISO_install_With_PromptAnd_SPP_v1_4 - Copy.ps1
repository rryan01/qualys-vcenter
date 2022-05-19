Write-Output "When entering the ip you can use a range like this '10.10.198.105-107' or just a single ip is fine"

$ipaddresses = Read-Host "Please Enter the iLO IP addresses to connect to: "
# This is where you will modify which servers to connect to 

$connection = Connect-HPEiLO -IP $ipaddresses -Username hpadmin -Password atlpresales -DisableCertificateAuthentication
sleep 5
Write-Output "You are now connected to these host"
$connection
sleep 15
Write-Output 'Now removing any existing attached virtual media before new ISO is attached'
Dismount-HPEiLOVirtualMedia -Connection  $connection -Device CD
sleep 7
Write-Output " "
$OSoption = Read-Host "Great now we are connected: what OS would you like (1)- Win2k16 (2)- ESXi 6.7U3 or (3)- SPP Update, or (4) for manual centos 7.8 install "
Write-Output " "
if ($OSoption -eq 1) {
    Mount-HPEiLOVirtualMedia -Connection $connection -Device CD -ImageURL http://10.10.124.15/2016V1.ISO
	Write-Output "You have selected Windows 2016- it will be loaded on the servers now"
}
elseif ($OSoption -eq 2) {
    Mount-HPEiLOVirtualMedia -Connection $connection -Device CD -ImageURL http://10.10.124.15/esxi67DHCP.iso
	Write-Output "You have selected VMware ESXi 6.7U3- it will be loaded on the servers now"
}
elseif ($OSoption -eq 3) {
    Mount-HPEiLOVirtualMedia -Connection $connection -Device CD -ImageURL http://10.10.124.15/P35936_001_gen10spp-2020.09.0-SPP2020090.2020_0901.17.iso
	Write-Output "You have selected October 2020 SPP - it will be loaded on the servers now"
}
elseif ($OSoption -eq 4) {
    Mount-HPEiLOVirtualMedia -Connection $connection -Device CD -ImageURL http://10.10.124.15/CentOS-7-x86_64-DVD-2003.iso
	Write-Output "You have selected Centos 7.8 - it will be loaded on the servers now, you will have to do the manual install "
}
else {
    Write-Output "The value was not one of the options after 15 seconds this will disconnect and exit the script"
	sleep 15
	Disconnect-HPEiLO -Connection $connection
	exit
}
Write-Output " "
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
sleep 10
Write-Output "Now powering off Servers"
sleep 2
Set-HPEiLOServerPower -Connection $connection -Power Off
Write-Output "Now powering ON Servers"
sleep 5
Set-HPEiLOServerPower -Connection $connection -Power On
Write-Output "Now after 15 minutes this host machine will disconnect from the ilo's  "
Write-Output "This should be plenty of time for the kickstart ISO to install  "
sleep 900
Disconnect-HPEiLO -Connection $connection


#Set-HPEiLOServerPower -Connection $connection -Power Off

#Mount-HPEiLOVirtualMedia -Connection $connection -Device CD -ImageURL http://10.10.124.15/SUT239.iso

# This will install files from the new centos 10.10.124.15 server for Centos Manual Click Through
#Mount-HPEiLOVirtualMedia -Connection $connection -Device CD -ImageURL http://10.10.124.15/CentOS-8.2.2004-x86_64-dvd1.iso

# This will install files from the new centos 10.10.124.15 server for Centos Manual Click Through
#Mount-HPEiLOVirtualMedia -Connection $connection -Device CD -ImageURL http://10.10.124.15/2016V1.ISO
