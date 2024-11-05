#Azure automation script that creates on-prem dummy computer objects that then maps the certificate to the object

[CmdletBinding(DefaultParameterSetName = 'Default')]
param(
[Parameter(Mandatory=$false)] [String] $TenantId = "",
[Parameter(Mandatory=$false)] [String] $ClientId = "",
[Parameter(Mandatory=$false)] [String] $ClientSecret = "",
[Parameter(Mandatory=$False)] [Switch] $NameMap
)
# Get NuGet
Get-PackageProvider -Name "NuGet" -Force | Out-Null
# Get WindowsAutopilotIntune module (and dependencies)
$module = Import-Module WindowsAutopilotIntune -PassThru -ErrorAction Ignore
if (-not $module) {
write-output "Installing module WindowsAutopilotIntune"
Install-Module WindowsAutopilotIntune -Force -AllowClobber
}
Import-Module WindowsAutopilotIntune -Scope Global
# Connect to MSGraph with application credentials
Connect-MSGraphApp -Tenant $TenantId -AppId $ClientId -AppSecret $ClientSecret
# Pull latest Autopilot device information
$AutopilotDevices = Get-AutopilotDevice | Select-Object azureActiveDirectoryDeviceId,groupTag
$DEVICES = $AutopilotDevices | Where-Object -FilterScript {$_.groupTag -like "AADJ*"}
# Set the OU for computer object creation
$orgUnit = "OU=Dummy-ComputersAADJ,OU=IT Infastructure,DC=ad,DC=domain,DC=com"
# Set the certificate path for name mapping
$certPath = "X509:<I>DC=com,DC=domain,DC=ad,CN=SUB-CA2"
# Create new Autopilot computer objects in AD while skipping already existing computer objects
foreach ($Device in $DEVICES) {
if (Get-ADComputer -Filter "Name -eq ""$($Device.azureActiveDirectoryDeviceId)""" -SearchBase $orgUnit -ErrorAction SilentlyContinue) {
write-output "Skipping $($Device.azureActiveDirectoryDeviceId) because it already exists. "
} else {
# Create new AD computer object
try {
New-ADComputer -Name "$($Device.azureActiveDirectoryDeviceId)" -SAMAccountName "$($Device.azureActiveDirectoryDeviceId.Substring(0,15))`$" -ServicePrincipalNames "HOST/$($Device.azureActiveDirectoryDeviceId)" -Path $orgUnit
write-output "Computer object created. ($($Device.azureActiveDirectoryDeviceId))"
} catch {
write-output "Error. Skipping computer object creation."
}
# Perform name mapping
try {
$subject = $Device.azureActiveDirectoryDeviceId
$Cert = "X509:<I>DC=com,DC=domain,DC=ad,CN=SUB-CA2<S>CN=$subject"
Set-ADComputer -Identity "$($Device.azureActiveDirectoryDeviceId.Substring(0,15))" -Add @{'altSecurityIdentities'="$Cert"}
Set-ADComputer -Identity "$($Device.azureActiveDirectoryDeviceId.Substring(0,15))" -Add @{'altSecurityIdentities'="$($certPath)"}
write-output "Name mapping for computer object done. ($($certPath)$($Device.azureActiveDirectoryDeviceId))"
} catch {
write-output "Error. Skipping name mapping."
}
}
}
# Reverse the process and remove any dummmy computer objects in AD that are no longer in Autopilot
$DummyDevices = Get-ADComputer -Filter * -SearchBase $orgUnit | Select-Object Name, SAMAccountName
foreach ($DummyDevice in $DummyDevices) {
if ($AutopilotDevices.azureActiveDirectoryDeviceId -contains $DummyDevice.Name) {
write-output "$($DummyDevice.Name) exists in Autopilot."
} else {
write-output "$($DummyDevice.Name) does not exist in Autopilot."
Remove-ADComputer -Identity $DummyDevice.SAMAccountName -Confirm:$False
#Remove -WhatIf once you are comfortrable with this workflow and have verified the remove operations are only performed in the OU you specified
}
}