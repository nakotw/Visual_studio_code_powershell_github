#Variables
$Domain = "domaine.client"
$path = "path de l'OU"
 
#Get all users in ActiveDirectory
$Users = Get-ADUser -SearchBase $path -Filter * -Properties ProxyAddresses
 
#Some output is always nice
Write-Host "Processing $Users.Count users..." -ForegroundColor Green
 
#Go through all users
foreach ($User in $Users) {
 
#Check if <domain>.mail.onmicrosoft.com alias is present, if not add it as an alias
if ($User.Proxyaddresses -like "*$Domain*") {
Write-Host "$User.SamAccountName has an alias matching $Domain..." -ForegroundColor Yellow
Sleep 1 
}
else {
$upn = $user.UserPrincipalName
$string = "$upn"
$userLogonName = $String.Split("@")[0]
$Alias = "smtp:" + $userLogonName + "@" + $Domain
##$Alias = "smtp:" + $User.SamAccountName + "@" + $Domain
Set-ADUser $User -Add @{Proxyaddresses="$Alias"}
$LUM = Get-ADUser $user -Properties ProxyAddresses
Write-Host "Alias $Domain addded to $LUM.userprincipalname" -ForegroundColor Green
sleep 1
}
}
Write-Host "Done" -ForegroundColor Green