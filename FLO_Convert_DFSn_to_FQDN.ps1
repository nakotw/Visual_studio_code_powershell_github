#Requires -RunAsAdministrator

$dfsrootFQDN = "contoso.local" #must be the root of the path you access DFS via.
$dfsnode = $env:COMPUTERNAME


#getting list of target namespaces
$targets = Get-DfsnRoot | Select-Object Path -ExpandProperty Path

#removing namespaces from members server that the script is being run on
foreach ($path in $targets) {

    $pathfix = $path -replace "$dfsrootFQDN","$dfsnode"
    Remove-DfsnRootTarget -TargetPath $pathfix
}

Start-Sleep -Seconds 15

#Enabling FQDN on the member server
Set-DfsnServerConfiguration –ComputerName $dfsnode –UseFqdn $true

Start-Sleep -Seconds 15

#restarting services
Stop-Service dfs; Start-Service dfs

Start-Sleep -Seconds 15

#Re-adding namespaces from active directory
foreach ($path in $targets) {

    $pathfix = $path -replace "koncern.local","$dfsnode"
    Dfsutil target add $pathfix
}