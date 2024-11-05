
#https://docs.microsoft.com/en-us/powershell/module/azuread/get-azureadauditsigninlogs?view=azureadps-2.0-preview
#download manuel du package azureadpreview
#https://docs.microsoft.com/fr-ca/powershell/scripting/gallery/how-to/working-with-packages/manual-download?view=powershell-7.2
#suivre la doc, avec les fenêtres powershell fermé
#$env:PSModulePath


Connect-AzureAD
$appused = Get-AzureADAuditSignInLogs -Filter "ClientAppUsed eq 'AutoDiscover'"
Write-host $appused.count" AutoDiscover" 
$EAS = Get-AzureADAuditSignInLogs -Filter "ClientAppUsed eq 'Exchange ActiveSync'" | Select-Object userPrincipalName,ClientAppUsed
Write-host $eas.count" Exchange ActiveSync"
$Imap = Get-AzureADAuditSignInLogs -Filter "ClientAppUsed eq 'IMAP'" | Select-Object userPrincipalName,ClientAppUsed
Write-host $Imap.count" IMAP"
$EWS = Get-AzureADAuditSignInLogs -Filter "ClientAppUsed eq 'Exchange Web Services'" | Select-Object userPrincipalName,ClientAppUsed
Write-host $EWS.count" Exchange Web Services"
$OC = Get-AzureADAuditSignInLogs -Filter "ClientAppUsed eq 'Other clients'" | Select-Object userPrincipalName,ClientAppUsed
Write-host $OC.count" Other clients"
$SMTPauth = Get-AzureADAuditSignInLogs -Filter "ClientAppUsed eq 'Authenticated SMTP'" | Select-Object userPrincipalName,ClientAppUsed
Write-host $SMTPauth.count" Authenticated SMTP"
$IMAP4 = Get-AzureADAuditSignInLogs -Filter "ClientAppUsed eq 'IMAP4'" | Select-Object userPrincipalName,ClientAppUsed
Write-host $IMAP4.count" IMAP4"



	




