Upload direct dans Intune

PowerShell.exe -ExecutionPolicy Unrestricted
Install-Script -name Get-WindowsAutopilotInfo -Force
Get-WindowsAutopilotInfo -Online






Création du fichier CSV #1
Install-script -Name Get-WindowsAutoPilotInfo -force
Set-ExecutionPolicy Unrestricted
Get-WindowsAutoPilotInfo.ps1 -OutputFile c:\temp\deviceid.csv



Création du fichier CSV #2
Set-Location -Path "C:\HWID" 
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts" 
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
Install-Script -Name Get-WindowsAutopilotInfo
Get-WindowsAutopilotInfo -OutputFile devicesedrial.csv