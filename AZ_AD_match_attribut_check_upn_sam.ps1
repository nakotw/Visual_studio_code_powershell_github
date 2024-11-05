#Connect-MsolService
$aadUPN = Get-MsolUser | Select-Object UserPrincipalName, alias
#$aadUPN = Get-MsolUser -userprincipalname "py@gmti.ca" | Select-Object UserPrincipalName, alias
$erreurprobable = @()
foreach ($currentItemName in $aadUPN) {
    $useraad = $currentItemName.UserPrincipalName
    write-host $useraad
    $item1 = Get-ADUser -Filter 'Userprincipalname -eq $useraad'
    #Get-ADUser -Filter 'Userprincipalname -eq "$useraad"'
    Write-host $item1
    Write-host ""
    $useraad = $currentItemName.UserPrincipalName
    $userad = $item1.UserPrincipalName
    $useradsam = $item1.samaccountname
    $useraad
    $userad
    $useradsam

    if ($userad -eq $useraad) {
    write-host "$($item1.samaccountname) est ok"
}
else {
    write-host "avant array $($useradsam)"
    $erreurprobable += $useraad
    Write-host "$($item1.SamAccountName)' n est pas identique"
     Write-host $useraad
     $erreurprobable
     write-host ""
}

}
#$erreurprobable
#$adLON = get-aduser -UserPrincipalName $aadUPN

#get-aduser -identity "gmichaud1"