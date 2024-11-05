#Variables
$Domain = "domain.mail.onmicrosoft.com"
$path = "OU=SharedMailBox,OU=Utilisateurs,OU=GroupeGaudreau,DC=groupegaudreau,DC=com"
 
#Get all users in ActiveDirectory
$Users = Get-ADUser -SearchBase $path -Filter * -Properties ProxyAddresses
 
#Some output is always nice
Write-Host "Processing $Users.Count users..." -ForegroundColor Green
 
#Go through all users
foreach ($User in $Users) {
 
#Check if <domain>.mail.onmicrosoft.com alias is present, if not add it as an alias
if ($User.Proxyaddresses -like "*$Domain*") {
Write-Host "$User.SamAccountName has an alias matching $Domain..." -ForegroundColor Yellow 
}
else {
$Alias = "smtp:" + $User.SamAccountName + "@" + $Domain
#Set-ADUser $User -Add @{Proxyaddresses="$Alias"}
Write-Host "Alias addded to $User.SamAccountName..." -ForegroundColor Green
}
}
Write-Host "Done" -ForegroundColor Green