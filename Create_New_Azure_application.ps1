# Connect to Azure AD
Connect-AzureAD

# Define the app registration details
$appName = "Bitlocker_keys_report"
$homePage = "http://localhost"
$replyUrls = @("http://localhost")
$requiredPermissions = @(
    "BitlockerKey.Read.All",
    "BitlockerKey.ReadBasic.All"
)

# Create the app registration
$app = New-AzureADApplication -DisplayName $appName -HomePage $homePage -ReplyUrls $replyUrls

# Create a client secret
$endDate = (Get-Date).AddYears(1) # Set expiration to 1 year
$secret = New-AzureADApplicationPasswordCredential -ObjectId $app.ObjectId -EndDate $endDate

# Assign permissions to the app
$graphApp = Get-AzureADServicePrincipal -SearchString "Microsoft Graph"
foreach ($permission in $requiredPermissions) {
    $appPermission = $graphApp.AppRoles | Where-Object { $_.Value -eq $permission -and $_.AllowedMemberTypes -contains "Application" }
    if ($appPermission) {
        New-AzureADServiceAppRoleAssignment -ObjectId $app.ObjectId -PrincipalId $app.ObjectId -ResourceId $graphApp.ObjectId -Id $appPermission.Id
    }
}

# Output the details
Write-Output "ClientId: $($app.AppId)"
Write-Output "ClientSecret: $($secret.Value)"
Write-Output "ClientSecretExpiration: $($secret.EndDate)"
Write-Output "TenantId: $(Get-AzureADTenantDetail).ObjectId"