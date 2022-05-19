Write-Output "When entering the ip you can use a range like this '10.10.198.105-107' or just a single ip is fine"
$ipaddresses = Read-Host "Please Enter the iLO IP addresses to connect to: "
# This is where you will modify which servers to connect to 
$connection = Connect-HPEiLO -IP $ipaddresses -Username hpadmin -Password atlpresales -DisableCertificateAuthentication
Write-Output "You are now connected to these host"
$connection



Set-HPEiLOServerPower -Connection $connection -Power Off


$ipaddresses = "10.10.124.2-15"
$connection = Connect-HPEiLO -IP $ipaddresses -Username hpadmin -Password atlpresales -DisableCertificateAuthentication
Set-HPEiLOServerPower -Connection $connection -Power Off

