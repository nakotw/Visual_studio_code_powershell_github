Connect-AzureAD
Connect-MsolService

$usersWithSpecificLicense = Get-MsolUser -All | Where-Object { $_.Licenses.AccountSkuId -match "cslacstjean:M365EDU_A3_FACULTY" }
$usersWithSpecificLicense | Out-GridView

$group = Get-AzureADGroup -Filter "DisplayName eq 'Licences_Employees_A5'"

foreach ($user in $usersWithSpecificLicense) {
    Add-AzureADGroupMember -ObjectId $group.ObjectId -RefObjectId $user.ObjectId
}