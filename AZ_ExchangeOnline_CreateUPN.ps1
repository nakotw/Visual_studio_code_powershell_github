Install-Module ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement
#$usercredential = Get-Credential
#Connect-ExchangeOnline -Credential $UserCredential -ShowProgress $true
#Add-Type -AssemblyName Microsoft.VisualBasic
Connect-ExchangeOnline

$users = Get-Mailbox -Filter * -RecipientType UserMailbox  | Select-Object userprincipalname | fl
$Displayname = (Get-Mailbox -Identity "gmichaud@gmti.ca"  | Select-Object Identity | ft -HideTableHeaders | Out-String).Trim()
$a,$b = ($Displayname.tolower()).split(' ')
$username = $a[0]+$b
$username


