#Connect-AzureAD
#Connect-MsolService
#$collection1 = Get-MsolUser -UserPrincipalName "gmichaud@fdcorp.ca"
#$collection1 = Get-AzureADUserMembership -ObjectId "a5742f5a-81f8-4874-a983-71279e4727ea"
#Get-AzureADGroup -ObjectId "eba223b2-3309-4b72-9ecb-0277c3eba638" | fl
#$collection1 | fl


############################################
#import-module Connect-AzureAD
##install-module Connect-AzureAD
#Connect-AzureAD
# Split path
$Path = Split-Path -Parent "C:\scripts\*.*"

# Create variable for the date stamp in log file
$LogDate = Get-Date -f yyyyMMddhhmm

# Define CSV and log file location variables
# They have to be on the same location as the script
$Csvfile = $Path + "\AllAzADUsers_$logDate.csv"
$CsvfileGroupe = $Path + "\CsvfileGroupe_$logDate.csv"
$CsvfileLicence = $Path + "\CsvfileLicence_$logDate.csv"

# Get all Azure AD users
$AzADUsers = Get-AzureADUser -All $true | Select-Object -Property *
#$AzADUsers = Get-AzureADUser -Filter "startswith(displayname,'Anthony Martineau')" | Select-Object -Property *
# Display progress bar
$progressCount = 0
for ($i = 0; $i -le $AzADUsers.Count; $i++) {

    Write-Progress `
        -Id 0 `
        -Activity "Retrieving User " `
        -Status "$progressCount of $($AzADUsers.Count)" `
        -PercentComplete (($progressCount / $AzADUsers.Count) * 100)

    $progressCount++
}
# Create group list
# Create list
$LicenceReal = @()
$GroupAzureADjoin = @()
$GRPresult = @()
#foreach ($item in $AzADUsers) {
#if (!($item -eq $null)) {
#    $collection1 = Get-AzureADUserMembership -ObjectId $item.ObjectID
#    $username = $item.UserPrincipalName
#    $GroupAD = @()
#    $GroupAzureAD = @()
#    $GroupAzureADjoin += $username
#    foreach ($GRP in $collection1) {
#        if ($GRP.DirSyncEnabled -eq $true) {
#            $GroupAD = $GRP.DisplayName
#            $GroupADjoin += $GroupAD -join '|'
#        }
#        else {
#            $GroupAzureAD = $GRP.DisplayName
#            $GroupAzureADjoin += $GroupAzureAD -join '|'
#        }
#    }
#}
#####
foreach ($item in $AzADUsers) {
    $rowgrp = "" | Select UserPrincipalName, GroupAD, GroupAzureAD
    $collection1 = Get-AzureADUserMembership -ObjectId $item.ObjectID
    $GroupAD = @()
    $GroupADjoin = @()
    $GroupAzureADjoin = @()
    $GroupAzureAD = @()
    foreach ($GRP in $collection1) {
        if ($GRP.DirSyncEnabled -eq $true) {
            $grp1 = ($GRP.DisplayName).Trim()
            $GroupAD += $grp1
                
                
        }
        else {
            $grp2 = ($GRP.DisplayName).Trim()   
            $GroupAzureAD += $grp2
                
                
                
        }
        #$row.Licence += $LicenceVAR -join '|'
        
        
        #$LicenceReal | Where-Object UserPrincipalName -EQ "gmichaud1@fdcorp.ca"
        #$LicenceReal | Select-object Licence | where-object UserPrincipalName -eq $item.UserPrincipalName
    }
    $GroupADjoin += $GroupAD
    $GroupAzureADjoin += $GroupAzureAD
    $rowgrp.GroupAzureAD += $GroupAzureADjoin -join '|'
    $rowgrp.GroupAD += $GroupADjoin -join '|'
    $rowgrp.UserPrincipalName = $item.UserPrincipalName
    $GRPresult += $rowgrp
    #$CsvfileGroupe = $Path + "\CsvfileGroupe_$logDate.csv"
    #$GroupReal | Export-Csv -Encoding UTF8 -Path $CsvfileGroupe -NoTypeInformation
    $LicenceRaw = (Get-MsolUser -ObjectId $item.ObjectID).Licenses | Select-Object AccountSkuId
    if (!($LicenceRaw -eq $null)) {
        $LicenceVAR = @()
        foreach ($Licence1 in $LicenceRaw) {
            $row = "" | Select UserPrincipalName, Licence
            $Licence2 = ($Licence1.AccountSkuId).TrimStart("fdcorpSainteFoyLtee:")
            $LicenceVAR += $Licence2
            #$row.Licence += $LicenceVAR -join '|'
        
        
            #$LicenceReal | Where-Object UserPrincipalName -EQ "gmichaud1@fdcorp.ca"
            #$LicenceReal | Select-object Licence | where-object UserPrincipalName -eq $item.UserPrincipalName
        }
    }
    else {
        $row = "" | Select UserPrincipalName, Licence
        $LicenceVAR = @()
        $LicenceVAR += 'Pas de Licence'
    }
    #$CsvfileLicence = $Path + "\CsvfileLicence_$logDate.csv"
    $row.Licence += $LicenceVAR -join '|'
    $row.UserPrincipalName = $item.UserPrincipalName
    $LicenceReal += $row
    
         
}
$GRPresult | Export-Csv -Encoding UTF8 -Path $CsvfileGroupe -NoTypeInformation
Write-host "avant Export Licence"
$LicenceReal | Export-Csv -Encoding UTF8 -Path $CsvfileLicence -NoTypeInformation
Write-host "avant Export User"
$AzADUsers | Sort-Object GivenName | Select-Object `
@{Label = "First name"; Expression = { $_.GivenName } },
@{Label = "Last name"; Expression = { $_.Surname } },
@{Label = "Display name"; Expression = { $_.DisplayName } },
@{Label = "User principal name"; Expression = { $_.UserPrincipalName } },
@{Label = "Street"; Expression = { $_.StreetAddress } },
@{Label = "City"; Expression = { $_.City } },
@{Label = "State/province"; Expression = { $_.State } },
@{Label = "Zip/Postal Code"; Expression = { $_.PostalCode } },
@{Label = "Country/region"; Expression = { $_.Country } },
@{Label = "Job Title"; Expression = { $_.JobTitle } },
@{Label = "Department"; Expression = { $_.Department } },
@{Label = "Company"; Expression = { $_.CompanyName } },
@{Label = "Description"; Expression = { $_.Description } },
@{Label = "Office"; Expression = { $_.PhysicalDeliveryOfficeName } },
@{Label = "Telephone number"; Expression = { $_.TelephoneNumber } },
@{Label = "E-mail"; Expression = { $_.Mail } },
@{Label = "Mobile"; Expression = { $_.Mobile } },
@{Label = "Dirsync"; Expression = { if (($_.DirSyncEnabled -eq 'True') ) { 'True' } Else { 'False' } } },
@{Label = "ObjectType"; Expression = { $_.ObjectType } },
@{Label = "Account status"; Expression = { if (($_.DirSyncEnabled -eq 'True') ) { 'User AD' } Else { 'User Cloud' } } } |
#{($test3 = ($LicenceReal | Where-Object UserPrincipalName -eq $_.UserPrincipalName | ft -HideTableHeaders | Out-String).Trim())},
#@{Label = "LicenceO365"; Expression = { $test3 } },
#@{Label = "LicenceO365"; e = { ($LicenceReal | Where-Object UserPrincipalName -eq $_.UserPrincipalName | ft -HideTableHeaders | Out-String).Trim() } },
#@{Label = "GroupAzureAD"; Expression = { $GroupAzureADjoin } },
#{(write-host $_.UserPrincipalName)},
#@{Label = "GroupAD"; Expression = { $GroupADjoin } } |
Export-Csv -Encoding UTF8 -Path $Csvfile -NoTypeInformation #-Delimiter ";"
#write-host $_.UserPrincipalName
#$test2 = ($LicenceReal | Where-Object UserPrincipalName -eq $_.UserPrincipalName | ft -HideTableHeaders | Out-String).Trim()
#$test3

#$string = ($LicenceReal | Where-Object UserPrincipalName -eq $item.UserPrincipalName | ft -HideTableHeaders | Out-String).Trim($item.UserPrincipalName)
#$string = 'gmathieu@fdcorp.ca {COEV, PE_E3}' 
#($string | Out-String).Trim($item.userprincipalname)
#$string.objecttype()
#$string.GetType()
#$LicenceReal.UserPrincipalName
