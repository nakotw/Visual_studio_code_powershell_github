# #########################################################################################################################################
# 
# Enable the Unified Labeling feature for Office 365 groups
# 
# - Uses Azure AD Preview module
#   - https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/groups-settings-cmdlets#install-powershell-cmdlets
# - Checks if user is already logged into "a" tenant
# - Read more:
#   - https://docs.microsoft.com/en-us/microsoft-365/compliance/sensitivity-labels-teams-groups-sites?view=o365-worldwide
#   - https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/groups-settings-cmdlets
#
# Version: 0.1 (2020-08-17)
# Author: @marcoscheel
# #########################################################################################################################################

$tenantdetail = $null;
$tenantdetail = Get-AzureADTenantDetail -ErrorAction SilentlyContinue; 
if ($null -eq $tenantdetail)
{
    #connect as gloabl admin
    Connect-AzureAD
    $tenantdetail = Get-AzureADTenantDetail -ErrorAction SilentlyContinue; 
}
if ($null -eq $tenantdetail)
{
    Write-Host "Error connecting to tenant" -ForegroundColor Red;
    Exit
}

$settingIsNew = $false;
$setting = Get-AzureADDirectorySetting | Where-Object { $_.DisplayName -eq "Group.Unified"};
if ($null -eq $setting){
    Write-Host "Not directory settings for Group.Unified found. Create new!" -ForegroundColor Green;
    $settingIsNew = $true;
    $aaddirtempid = (Get-AzureADDirectorySettingTemplate | Where-Object { $_.DisplayName -eq "Group.Unified" }).Id;
    $template = Get-AzureADDirectorySettingTemplate -Id $aaddirtempid;
    $setting = $template.CreateDirectorySetting();
}
else{
    Write-Host "Directory settings for Group.Unified found. Current value for EnableMIPLabels:" -ForegroundColor Green;
    Write-Host $setting["EnableMIPLabels"];
}

$setting["EnableMIPLabels"] = "true";
if (-not $settingIsNew){
    #Reset AAD based classsification?
    #$setting["ClassificationList"] = "";
    #$setting["DefaultClassification"] = "";
    #$setting["ClassificationDescriptions"] = "";
}

if ($settingIsNew){

    New-AzureADDirectorySetting -DirectorySetting $setting;
    Write-Host "New directory settings for Group.Unified applied." -ForegroundColor Green;
    $setting = Get-AzureADDirectorySetting | Where-Object { $_.DisplayName -eq "Group.Unified"};
}
else{
    Set-AzureADDirectorySetting -Id $setting.Id -DirectorySetting $setting;
    Write-Host "Updated directory settings for Group.Unified." -ForegroundColor Green;
    $setting = Get-AzureADDirectorySetting | Where-Object { $_.DisplayName -eq "Group.Unified"};
}
$setting.Values;