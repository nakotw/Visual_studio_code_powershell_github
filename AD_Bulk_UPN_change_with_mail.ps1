Write-Host ""
Write-Host "`tTool         :: Change UPN" -ForegroundColor Magenta
Write-Host "`tDescription  :: Bulk change UPN with mail value" -ForegroundColor Magenta
Write-Host "`tAuthor       :: Florian Daminato" -ForegroundColor Magenta
Write-Host "`tCompany      :: FDCORP" -ForegroundColor Magenta
Write-Host ""

# Ce script reset l'UPN d'un user avec son adresse courriel
# A lancer sur un controleur de domaine

Import-Module ActiveDirectory
$ou = "OU=Utilisateurs RCC_0365,OU=Utilisateurs RCC,DC=rcc,DC=local"

$i = $i2 = 0

Get-ADUser -SearchBase $ou -filter * -Properties EmailAddress | ForEach-Object {
    if (![string]::IsNullOrEmpty($_.EmailAddress)) { 
        Write-Host "Set-ADUser -UserPrincipalName "$_.EmailAddress 
        #$_ | Set-ADUser -UserPrincipalName $_.EmailAddress
        $i++
    }
    $i2++
}

Write-Host ""
Write-Host $i "Comptes Traités sur" $i2.
Write-Host "Les autres comptes n'ont aucun email configuré."
