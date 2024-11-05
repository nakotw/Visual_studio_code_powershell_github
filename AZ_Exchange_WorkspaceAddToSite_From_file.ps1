Connect-ExchangeOnline
#Import csv
$csvFile = ""
$csvFile = Import-Csv "$ENV:UserProfile\fdcorp\M365_ECN - General\1- Client_M365\BLCPA brodeur Letourneau\Liste réservation bureau V2.csv" -Delimiter ";"

get-date -f yyyyMMddTHHmm
foreach ($entry in $csvFile) {
    $organizationName = "blcpa2.onmicrosoft.com"
    $courriel = $entry.Courriel
    $Nom_bureau = $entry.NOM
    $Ville = $entry.Lieux
    if ($entry.Lieux -eq "Saint-Hilaire") {
        $bureauAlias = "Saint-Hilaire_Bureau@blcpa2.onmicrosoft.com"
        #Write-Host $entry.Lieux
    }
    else {
        $bureauAlias = "Sherbrooke_Bureau@blcpa2.onmicrosoft.com"
        #Write-Host $entry.Lieux
    }
    New-Mailbox -Organization $organizationName -Name $Nom_bureau -DisplayName $Nom_bureau -PrimarySmtpAddress $courriel -Room | Set-Mailbox -Type Workspace
    sleep 10
    #Set-Place $courriel | Set-Mailbox -Type Workspace
    #Set-Place $courriel -City $Ville -Capacity 1
    Set-Place $courriel -City $Ville -Capacity 1 -CountryOrRegion CA -AudioDeviceName $null
    #Set-CalendarProcessing -Identity $courriel -EnforceCapacity $true -AddOrganizerToSubject
    Set-CalendarProcessing -Identity $courriel -AutomateProcessing AutoAccept -DeleteComments $true -AddOrganizerToSubject $true -AllowConflicts $false -EnforceCapacity $True -MinimumDurationInMinutes 30
    #New-DistributionGroup -Organization $organizationName -Name "St-Hilaire_Bureau" -RoomList
    Add-DistributionGroupMember -Identity $bureauAlias -Member $courriel
    Set-MailboxFolderPermission "$($courriel):\calendar" -User Default -AccessRights LimitedDetails
    Set-MailboxRegionalConfiguration –Identity $courriel -TimeZone "Eastern Standard Time" -Language 3084
}
get-date -f yyyyMMddTHHmm
Disconnect-ExchangeOnline


##create roomlist
#New-DistributionGroup -Name "Sherbrooke_Bureau" -RoomList
#New-DistributionGroup -Name "Saint-Hilaire_Bureau" -RoomList
##all step
#$courriel = "test9@blcpa.ca"
#$Nom_bureau = "test 9"
#
#$bureauAlias = "St-Hilaire_Bureau@blcpa2.onmicrosoft.com"
#$Ville = "St-Hilaire"
#
#$bureauAlias = "Sherbrooke_Bureau@blcpa2.onmicrosoft.com"
#$Ville = "Sherbrooke"
#
#$organizationName = "blcpa2.onmicrosoft.com"
#New-Mailbox -Organization $organizationName -Name $Nom_bureau -DisplayName $Nom_bureau -PrimarySmtpAddress $courriel -Room | Set-Mailbox -Type Workspace
#sleep 10
##Set-Place $courriel | Set-Mailbox -Type Workspace
#Set-Place $courriel -City $Ville -Capacity 1
#Set-Place $courriel -City $Ville -Capacity 1 -CountryOrRegion CA -AudioDeviceName $null
##Set-CalendarProcessing -Identity $courriel -EnforceCapacity $true -AddOrganizerToSubject
#Set-CalendarProcessing -Identity $courriel -AutomateProcessing AutoAccept -DeleteComments $true -AddOrganizerToSubject $true -AllowConflicts $false -EnforceCapacity $True -MinimumDurationInMinutes 30
##New-DistributionGroup -Organization $organizationName -Name "St-Hilaire_Bureau" -RoomList
#Add-DistributionGroupMember -Identity $bureauAlias -Member $courriel
#Set-MailboxFolderPermission "$($courriel):\calendar" -User Default -AccessRights LimitedDetails
#Set-MailboxRegionalConfiguration –Identity $courriel -TimeZone "Eastern Standard Time" -Language 3084