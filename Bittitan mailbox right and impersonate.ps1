#$tenantuser = Read-Host -Prompt "Entrer l'adresse courriel du domaine ex blcpa2-admin"
install-module MSOnline
Import-Module MSOnline
Install-Module exchangeonlinemanagement
Import-Module exchangeonlinemanagement
$upnadmin = Read-Host "mettre upn admin"
#$usercredential = Get-Credential
#Connect-MsolService -Credential $UserCredential
Connect-MsolService
#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $usercredential -Authentication Basic -AllowRedirection
#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $usercredential -Authentication Basic -AllowRedirection
#$Session = Connect-ExchangeOnline -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $usercredential -Authentication Basic -AllowRedirection
Connect-ExchangeOnline -UserPrincipalName $upnadmin






Get-Mailbox -ResultSize unlimited -Filter { (RecipientTypeDetails -eq 'UserMailbox') -and (Alias -ne 'Admin') } | Add-MailboxPermission -User fdcorp@flyscan.com -AccessRights fullaccess -InheritanceType all


Enable-OrganizationCustomization

New-ManagementRoleAssignment -Role "ApplicationImpersonation" -User fdcorp@flyscan.com



Connect-AzureAD
Install-Module AzureADPreview
Install-Module AzureAD

$GroupName = "ML-adminGroup_Creation"
$AllowGroupCreation = $False


$settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
if (!$settingsObjectID) {
  $template = Get-AzureADDirectorySettingTemplate | Where-object { $_.displayname -eq "group.unified" }
  $settingsCopy = $template.CreateDirectorySetting()
  New-AzureADDirectorySetting -DirectorySetting $settingsCopy
  $settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
}

$settingsCopy = Get-AzureADDirectorySetting -Id $settingsObjectID
$settingsCopy["EnableGroupCreation"] = $AllowGroupCreation

if ($GroupName) {
  $settingsCopy["GroupCreationAllowedGroupId"] = (Get-AzureADGroup -SearchString $GroupName).objectid
}
else {
  $settingsCopy["GroupCreationAllowedGroupId"] = $GroupName
}
Set-AzureADDirectorySetting -Id $settingsObjectID -DirectorySetting $settingsCopy

(Get-AzureADDirectorySetting -Id $settingsObjectID).Values