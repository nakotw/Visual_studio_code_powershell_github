# Anthony Martineau - fdcorp - 05/09/2022
#
# Creation de groupe AD de type distribution depuis un fichier csv
# le fichier csv aura la forme :
#
# NAME;MAIL
# mon groupe;mongroupe@domaine.com
#
#
#

$csvFile = Import-Csv "C:\fdcorp\distri_list.csv" -Delimiter ";"
#Import-Csv "C:\fdcorp\distri_list.csv" -Delimiter ";" | ft
$OU = "OU=GSM - Gmail Groups - M365,OU=GSM,DC=humanise,DC=local"

foreach($entry in $csvFile){
    New-ADGroup -Name $entry.name -OtherAttributes @{mail=$entry.mail} -GroupCategory Distribution -Path $OU -GroupScope Global
    #Write-Host "mail :" $entry.mail
}

Write-Host "Script Completed" -ForegroundColor Yellow