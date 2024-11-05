# info Aip non activé dans exchange
# https://techcommunity.microsoft.com/t5/security-compliance-and-identity/how-to-troubleshoot-sensitivity-labels-part-1/ba-p/3604557
Import-Module -Name AIPService
Install-Module -Name AIPService
(Get-Module AIPService –ListAvailable).Version
Connect-AipService
Get-AipService
Enable-AipService
Get-AipServiceConfiguration
Get-AipServiceTemplate
Get-AipServiceTemplate -TemplateId c50c3a35-2b0e-4c10-a4ae-212a7730aef7 | select *
Get-AipServiceTemplateProperty

# debug exchange aip non actif
Connect-AipService
$EndPoint=(Get-AipServiceConfiguration).LicensingIntranetDistributionPointUrl
Connect-ExchangeOnline
#voir la config
get-irmconfiguration
Set-IrmConfiguration -LicensingLocation $EndPoint
Set-IrmConfiguration -InternalLicensingEnabled $True
Set-IrmConfiguration -AzureRmsLicensingEnabled $True
get-irmconfiguration
Disconnect-AipService





remove-AipServiceTemplateProperty -TemplateId 12289022-c7f2-4be5-90b1-070a456b7838
Remove-AipServiceTemplate -TemplateId 12289022-c7f2-4be5-90b1-070a456b7838

Test-IRMConfiguration -Sender fdcorp@ccaq.com -Recipient gmichaud@fdcorp.ca
Test-MgInformationProtectionPolicyLabelClassificationResult