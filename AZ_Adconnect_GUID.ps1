install-module MSOnline -scope currentuser
Import-Module MSOnline
$usercredential = Get-Credential
Connect-MsolService -Credential $UserCredential
#$path = "OU=adminsystemes,OU=Exploitation,OU=Utilisateurs,DC=client"
Add-Type -AssemblyName Microsoft.VisualBasic
$path = [Microsoft.VisualBasic.Interaction]::InputBox('Dans quelle OU souhaitez lancer le script', 'User', "")
$users = get-aduser -SearchBase $path -filter * | Select-Object samaccountname, userprincipalname, objectguid
foreach ($User in $Users)            
{                    
    $guid = $User.objectguid          
    $b64 = [system.convert]::ToBase64String(([GUID]"$guid").tobytearray())
    $UPN = $User.userprincipalname
    #set-msoluser -userprincipalname $upn -immutableid $b64
    Write-Host "$upn    $b64    Done"

}


##test
set-msoluser -userprincipalname "Fperron-deschenes@bbimmigration.com" -immutableid 7pvRO8pBJkGR6V7HziaaFA==


Get-MsolUser -userprincipalname "Fperron-deschenes@bbimmigration.com" | fl
Get-MsolUser -userprincipalname "fperron-deschenes@bernierbeaudry.com" | fl

#
#"pfrigon@tbltelecom.com"
#Get-Mailbox "pfrigon@tbltelecom.com" | Format-List ExchangeGUID
#
#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $userCredential -Authentication Basic -allowRedirection
#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $usercredential -Authentication Basic -allowRedirection
#Start-Sleep 3
#Import-PSSession $Session
#
#remove-mailbox "1f564a9d-2ed8-4b38-a26e-cebe98b5a80e" -PermanentlyDelete
#Get-MoveRequest -MoveStatus Failed
#
#Enable-RemoteMailbox pfrigon -RemoteRoutingAddress username@domain.mail.onmicrosoft.com
#
#Set-RemoteMailbox pfrigon -ExchangeGuid 1f564a9d-2ed8-4b38-a26e-cebe98b5a80e
#
#Get-Mailbox -InactiveMailboxOnly
#
#(Get-MsolUser -UserPrincipalName "pfrigon@tbltelecom.com").errors.errordetail.objecterrors.errorrecord| fl
#Get-Recipient -IncludeSoftDeletedRecipients 'ac14360b-b2ae-4047-9f51-20a2e46e4cba'|ft RecipientType,PrimarySmtpAddress,*WhenSoftDeleted*
#Remove-MailUser 'ac14360b-b2ae-4047-9f51-20a2e46e4cba' -PermanentlyDelete
#Remove-Mailbox 'ac14360b-b2ae-4047-9f51-20a2e46e4cba' -PermanentlyDelete
#
#
#Get-MsolUser -UserPrincipalName "pfrigon@tbltelecom.com" |fl *objectID*
#Redo-MsolProvisionUser -ObjectId "33e2d28e-419e-4c3f-a7ae-6ea47461b16f"


Set-MsolDirSyncEnabled -EnableDirSync $false

(Get-MSOLCompanyInformation).DirectorySynchronizationEnabled