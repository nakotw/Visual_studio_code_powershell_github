connect-azuread
connect-msolservice
 
$orphanedusers = Get-AzureADUser -All:$true | Where {$_.DirSyncEnabled -eq $false} | Select -Property UserPrincipalName
 
foreach($user in $orphanedusers){
    Write-Host "Changing Immutable ID $($user)"
    Set-MsolUser -UserPrincipalName $user.UserPrincipalName -ImmutableId "$null"
}