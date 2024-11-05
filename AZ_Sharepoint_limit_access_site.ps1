

Connect-SPOService -Url https://fdcorpsaintefoyltee-admin.sharepoint.com/ -ModernAuth $true -AuthenticationUrl https://login.microsoftonline.com/organizations
Connect-PnPOnline -url "https://fdcorpsaintefoyltee.sharepoint.com/sites/M365_ECN" -PnPManagementShell

get-SPOSite | fl
get-SPOSite -Identity https://fdcorpsaintefoyltee.sharepoint.com/sites/M365_ECN | fl
Set-SPOSite -Identity https://fdcorpsaintefoyltee.sharepoint.com/sites/M365_ECN -ConditionalAccessPolicy AllowLimitedAccess