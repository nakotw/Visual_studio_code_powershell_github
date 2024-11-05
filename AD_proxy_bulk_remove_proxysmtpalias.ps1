#Variables
$Domaintoremove = "ecdl.lan"
$path = "OU=Saint-Lazare,OU=QUEBEC,OU=Canada,OU=Utilisateurs_365,OU=Utilisateurs,OU=CDLINC,DC=ecdl,DC=lan"
 
#Get all users in ActiveDirectory
$Users = Get-ADUser -SearchBase $path -Filter * -Properties ProxyAddresses
 
#Some output is always nice
#Write-Host "Processing $Users.Count users..." -ForegroundColor Green
 
#Go through all users
foreach ($User in $Users) {
 
#Check if <domain>.mail.onmicrosoft.com alias is present, if not add it as an alias
if ($User.Proxyaddresses -like "*$Domaintoremove*") {
$Aliastoremove = "smtp:" + $User.SamAccountName + "@" + $Domaintoremove
Set-ADUser $User -remove @{Proxyaddresses="$Aliastoremove"}
Write-Host "Alias $Aliastoremove remove for user" $User.SamAccountName -ForegroundColor Yellow 
}
else {
Write-Host "No alias $Domaintoremove to remove for user " + $User.SamAccountName -ForegroundColor Green
}
}
Write-Host "Done" -ForegroundColor Green