## Bulk Add licences ##
/

## Import Csv
$users = Import-Csv $csv.UserPrincipalName

## Select Account SKU to be removed
$accountSKU = Get-MsolAccountSku | Select-Object AccountSkuId | Out-GridView -PassThru

## Loop through each user in the Csv
foreach ($user in $users) {

    ## Check if Licence is already applied
    $check = Get-MsolUser -UserPrincipalName $user.UserPrincipalName | Select-Object UserPrincipalName, Licenses
    Write-Warning "checking for $($accountsku.AccountSkuId) on $($user.UserPrincipalName)"
    if ($check.Licenses.AccountSkuId -notcontains $accountsku.AccountSkuId) {

        ## Add licence
        Write-Warning "Adding $($accountSKU.AccountSkuId) licence to $($users.UserPrincipalName)"
        Start-Sleep 1
        Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses $accountSKU.AccountSkuId

    }
    else {
        ## Licence already applied
        Write-Host "$($user.UserPrincipalName) has $($accountsku.AccountSkuId) licence assigned" -ForegroundColor Green

    }
}