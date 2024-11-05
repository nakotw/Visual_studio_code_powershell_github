Install-Module ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement
$usercredential = Get-Credential
Connect-ExchangeOnline -Credential $UserCredential -ShowProgress $true

Get-DynamicDistributionGroup -Identity ".NVL - tous" | fl recipient*,Inclided*



get-mailbox -Identity "drivest@novallier.ca" |fl
get-mailbox -Identity "regfoncier@novallier.ca" |fl


#RecipientTypeDetails                      : SharedMailbox

#juste les user et non les sharedMailBox
New-DynamicDistributionGroup -Name ".NVL - tousV2" -RecipientFilter "(RecipientTypeDetails -eq 'UserMailbox')"

#test
New-DynamicDistributionGroup -Name ".NVL - tousV2" -RecipientFilter "(RecipientTypeDetails -eq 'UserMailbox')"
Get-DynamicDistributionGroup -Identity ".NVL - tous" |fl
Set-DynamicDistributionGroup -Identity ".NVL - tous" -RecipientFilter "(RecipientTypeDetails -eq 'UserMailbox') -and (-not(RecipientTypeDetailsValue -eq 'SharedMailbox'))"
Set-DynamicDistributionGroup -Identity ".NVL - tous" -DisplayName ".NVL - tous" 
get-mailbox -Identity "bprive@novallier.ca" |fl
Get-DistributionGroup -Identity "aeroplan@novallier.ca" | fl