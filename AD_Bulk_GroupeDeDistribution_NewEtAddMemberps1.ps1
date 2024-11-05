
Install-Module ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement
$usercredential = Get-Credential
Connect-ExchangeOnline -Credential $UserCredential -ShowProgress $true
Add-Type -AssemblyName Microsoft.VisualBasic

$dlName = [Microsoft.VisualBasic.Interaction]::InputBox('DL name')
$dlAlias = [Microsoft.VisualBasic.Interaction]::InputBox('DL Alias ex email')
#$newgrdl =

New-DistributionGroup -Name $dlName -Alias $dlAlias

#Set-DistributionGroup -Identity "Accounting" -DisplayName "Accounting Group"
$TxtFile = [Microsoft.VisualBasic.Interaction]::InputBox('nom du fichier txt')
#$pathFile = [Microsoft.VisualBasic.Interaction]::InputBox('ex de path $ENV:UserProfile\Micro Logic Sainte-Foy Ltée\Service - Environnement collaboration numérique\1- Client_M365\Novallier 887\')
$pathFile = "$ENV:UserProfile\Micro Logic Sainte-Foy Ltée\Service - Environnement collaboration numérique\1- Client_M365\Novallier 887\"
foreach($line in Get-Content $pathFile""$TxtFile) {
    Add-DistributionGroupMember -Identity $dlName -Member $line
    $line
}


Disconnect-ExchangeOnline
##export dl groupe
#$Groups = Get-DistributionGroup -ResultSize Unlimited
#$Groups | ForEach-Object {
#$group = $_
#Get-DistributionGroupMember -Identity $group.Name -ResultSize Unlimited | ForEach-Object {
#    New-Object -TypeName PSObject -Property @{
#        Group = $group.DisplayName
#        Member = $_.Name
#        EmailAddress = $_.PrimarySMTPAddress
#        RecipientType= $_.RecipientType
#        }
#    }
#} | Export-CSV ".\DLGroupMembers.csv" -NoTypeInformation -Encoding UTF8