@("MSOnline","AzureAD","AZ","Microsoft.Graph","MicrosoftTeams","SharePointPnPPowerShellOnline","PnP.PowerShell","ExchangeOnlineManagement","Microsoft.Online.SharePoint.PowerShell")|% $_{if(Get-Module -ListAvailable -Name $_) {install-module -name $_ -force} else {install-module -name $_ -skippublishercheck -force}}
Install-Module Microsoft.Graph.Beta -AllowClobber -Force