Connect-MgGraph
Connect-SPOService -Url https://confianceia-admin.sharepoint.com/

$list = @()
#Counters
$i = 0
$j = 0

#Get licensed users
$users = Get-MgUser -All
#total licensed users
$count = $users.count

foreach ($u in $users) {
    $i++
    $j++
    Write-Host "$j/$count"

    $upn = $u.userprincipalname
    $list += $upn

    if ($i -eq 199) {
        #We reached the limit
        Write-Host "Batch limit reached, requesting provision for the current batch"
        Request-SPOPersonalSite -UserEmails $list -NoWait
        Start-Sleep -Milliseconds 655
        $list = @()
        $i = 0
    }
}

if ($i -gt 0) {
    Request-SPOPersonalSite -UserEmails $list -NoWait
}
Write-Host "Completed OneDrive Provisioning for $j users"