#AZ_Group_add_user_to_group

#install-module MSOnline -scope currentuser
#Import-Module MSOnline
#$usercredential = Get-Credential
#Connect-MsolService -Credential $UserCredential
#Connect-MsolService
Connect-AzureAD
$collection1 = Get-MsolUser
#$collection1 | fl
$variable1 = "True"
foreach ($item in $collection1) {
    if ($item.IsLicensed -clike $variable1) {
        write-host $item.UserPrincipalName $item.IsLicensed
        Add-AzureADGroupMember -ObjectId "8f997420-6c6e-4f1a-a53e-5ff8b337b874" -RefObjectId $item.ObjectId
    }
    else {
        write-host $item.UserPrincipalName -ForegroundColor Red
    }
}
$collection1.Count
$nombredemembre = Get-AzureADGroupMember -ObjectId "8f997420-6c6e-4f1a-a53e-5ff8b337b874"
$nombredemembre.count

