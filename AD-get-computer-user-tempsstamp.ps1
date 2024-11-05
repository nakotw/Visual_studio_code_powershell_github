# if needed Imports AD Module into PowerShell
import-module ActiveDirectory

# Sets time stamp to filter computers in the domain that have NOT logged in since after specified date.
$d=(Get-Date).AddDays(-(Read-host "How many days stale are you looking for? Ex: 60"))

#Formats a date to add to the file name.
$DateFile=(Get-Date).ToString("u") -Replace "z|-|:|\s"

# Get all AD computers in -SearchBase is filterd with -le which is Less-than or equal to $d the date set above.
Get-ADComputer -SearchBase "ou=ordinateurs_o365,ou=client,dc=client,dc=local" -Filter 'lastLogonTimestamp -ge $d' -Properties DistinguishedName,
    sAMAccountName,
    dNSHostName,
    pwdLastSet,
    whenCreated,
    OperatingSystem,
    operatingSystemVersion,
    lastlogontimestamp,
    description |
# Selects Output into CSV
select-object DistinguishedName,
    sAMAccountName,
    dNSHostName,
    @{Name="pwdLastSet"; Expression={[DateTime]::FromFileTime($_.pwdLastSet)}},
    @{Name="pwdLastSet Age"; Expression={((get-date)-[DateTime]::FromFileTime($_.pwdLastSet)).Days}},
    whenCreated,
    OperatingSystem,
    operatingSystemVersion,
    @{Name="LastLogonTimestamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}},
    @{Name="LastLogonTimestamp Age"; Expression={((get-date)-[DateTime]::FromFileTime($_.lastLogonTimestamp)).Days}},
    Description |
#Exports to cvs with Date and time it was created
export-csv .\Inactive_Computers_$DateFile.csv -notypeinformation

#Tells you its done and the name of the file
write-host "Complete! File Name ""Inactive_Computers_$DateFile.csv"""