# Robert Ryan- To use script please change IP addresses and the range and then assign the correct Image URL

$connection = Connect-HPEiLO -IP 10.10.198.105-106 -Username hpadmin -Password atlpresales -DisableCertificateAuthentication
Set-HPEiLOServerPower -Connection $connection -Power Off
Mount-HPEiLOVirtualMedia -Connection $connection -Device CD -ImageURL http://10.10.197.71/media/esxauto/custom_esxi65U2Sept2018.iso
Set-HPEiLOVirtualMediaStatus -Connection $connection -VMBootOption BootOnNextReset -Device CD | out-null
Set-HPEiLOOneTimeBootOption -Connection $connection -BootSourceOverrideTarget CD
sleep 10
Set-HPEiLOServerPower -Connection $connection -Power On

