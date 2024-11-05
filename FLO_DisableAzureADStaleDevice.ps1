#enter treshold days 
$deletionTresholdDays= 180

Connect-AzureAD -ErrorAction Stop

$deletionTreshold= (Get-Date).AddDays(-$deletionTresholdDays)

$allDevices=Get-AzureADDevice -All:$true | Where {$_.ApproximateLastLogonTimeStamp -le $deletionTreshold}

$exportPath=$(Join-Path $PSScriptRoot "AzureADDeviceExport.csv")

$allDevices | Select-Object -Property DisplayName, ObjectId, ApproximateLastLogonTimeStamp, DeviceOSType, DeviceOSVersion, IsCompliant, IsManaged `
| Export-Csv -Path $exportPath -UseCulture -NoTypeInformation

Write-Output "Rapport des devices disponible ici: $exportPath"

$confirmDeletion=$null

while ($confirmDeletion -notmatch "[y|n]"){

    $confirmDeletion = Read-Host "Avant de disable les devices, veuiller consulter le fichier CSV. Souhaitez vous disable les devices qui n'ont pas communiques avec le tenant depuis plus de $deletionTresholdDays jours (Y/N)"
}

if ($confirmDeletion -eq "y"){

    $allDevices | ForEach-Object {

        Write-Output "Désactivation de $($PSItem.ObjectId)"
        #Remove-AzureADDevice -ObjectId $PSItem.ObjectId
        Set-AzureADDevice -ObjectId $PSItem.ObjectId -AccountEnabled $false
    }

} else {
   
    Write-Output "Ok bye ..."
}