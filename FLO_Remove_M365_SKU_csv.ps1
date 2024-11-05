## Bulk Remove licenses ##
#Connect-MsolService
## Select Csv file
$csv = Get-ChildItem -Path C:\temp\ -File | Out-GridView -PassThru

## Import Csv
$users = Import-Csv $csv.UserPrincipalName

## Select Account SKU to be removed
$accountSKU = "bernierbeaudry:O365_BUSINESS_PREMIUM"

## Loop through each user in the Csv
foreach ($user in $users) {
    Write-Host "Removing $($accountSKU.AccountSkuId) licence from $($user.UserPrincipalName)" -ForegroundColor Yellow

    ## Remove licence
    Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -RemoveLicenses $accountSKU.AccountSkuId
    Start-Sleep 1
}