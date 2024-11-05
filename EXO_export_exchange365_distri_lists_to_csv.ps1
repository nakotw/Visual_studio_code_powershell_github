
Connect-ExchangeOnline

$Groups = Get-DistributionGroup
$Groups | ForEach-Object {
$group = $_.Name
$members = ''
Get-DistributionGroupMember $group | ForEach-Object {
$members=$_.Name
New-Object -TypeName PSObject -Property @{
GroupName = $group
Members = $members
EmailAddress = $_.PrimarySMTPAddress
}}
} | Export-CSV "C:\Users\amartineau\Downloads\DistributionGroupMember.csv" -NoTypeInformation -Encoding UTF8