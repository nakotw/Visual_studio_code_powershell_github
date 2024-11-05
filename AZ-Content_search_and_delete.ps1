#AZ-Content_search_and_delete
Import-Module ExchangeOnlineManagement
Connect-IPPSSession -UserPrincipalName "gmichaud_adm@fdcorp.ca" -ConnectionUri https://ps.compliance.protection.partner.outlook.cn/powershell-liveid
New-ComplianceSearchAction -SearchName "doublon vendredi logicv4" -Purge -PurgeType HardDelete
Get-ComplianceSearchAction
Disconnect-ExchangeOnline