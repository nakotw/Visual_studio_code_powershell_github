install-Module ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement
Connect-IPPSSession -UserPrincipalName "fdcorp@ccaq.com"
get-label
Get-AzureADExtensionProperty
get-aipservice

Install-Module aipservice
import-Module aipservice
Connect-AipService
Get-AipServiceOnboardingControlPolicy


Get-AipService