Install-Module ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement
#$usercredential = Get-Credential
#Connect-ExchangeOnline -Credential $UserCredential -ShowProgress $true
#Add-Type -AssemblyName Microsoft.VisualBasic
Connect-ExchangeOnline


#Get-MailboxFolderPermission ddolan@novallier.ca:\calendrier
Get-MailboxFolderPermission pyrochefort@fdcorp.ca:\calendar
Remove-MailboxFolderPermission -Identity pbedard@fdcorp.ca:\calendar -User "amailly@fdcorp.ca"

#remove calendrier permission
Remove-MailboxFolderPermission -Identity ddolan@novallier.ca:\Calendrier -User "drivest@novallier.ca"
#get-mailbox -Identity "vcloutier@novallier.ca"
#Set-MailboxFolderPermission -Identity khoule@novallier.ca:\calendar -User Default -AccessRights Reviewer
#$item = Get-Mailbox -Identity "drivest@novallier.ca"  | Select-Object userprincipalname
$users = Get-Mailbox -Filter * -RecipientType UserMailbox  | Select-Object userprincipalname
$Log = [System.IO.StreamWriter] "c:\temp\$(get-date -f yyyyMMddTHHmm)_log.txt"


    foreach ($item in $users) {
        if (($item -ne "dprive@novallier.ca") -and ($item -ne "bprive@novallier.ca")) {
                #Get-MailboxfolderPermission drivest@novallier.ca:\calendrier | fl
                #Get-mailbox -Identity $item.UserPrincipalName | fl
                $cal = $item.UserPrincipalName.ToString() + ":\calendrier"
                if (!(Get-MailboxfolderPermission $cal)) {
                    write-host oui
                    $cal = $item.UserPrincipalName.ToString() + ":\calendar"
                    Set-MailboxFolderPermission -Identity $cal -User Default -AccessRights Author
                    $resultat = Get-MailboxFolderPermission $cal
                    Write-Host $resultat.Identity $resultat.accessrights
                    $resulIdentity = $resultat.Identity
                    $resulAccess = $resultat.accessrights
                    $Log.Write("$(get-date -f yyyyMMddTHHmm) $resulIdentity $resulAccess")   
                    $Log.Write("`r`n")
                    }
                else {
                    write-host non
                    $cal = $item.UserPrincipalName.ToString() + ":\calendrier"
                    Set-MailboxFolderPermission -Identity $cal -User Default -AccessRights Author
                    $resultat = Get-MailboxFolderPermission $cal
                    Write-Host $resultat.Identity $resultat.accessrights
                    $resulIdentity = $resultat.Identity
                    $resulAccess = $resultat.accessrights
                    $Log.Write("$(get-date -f yyyyMMddTHHmm) $resulIdentity $resulAccess")   
                    $Log.Write("`r`n")
                    }
                
            }
        else {
            Write-Host "à vérifier"
            $Log.Write("$(get-date -f yyyyMMddTHHmm) $item à vérifier")   
            $Log.Write("`r`n")
        }
        
        
    }



$log.Close()
###


Disconnect-ExchangeOnline -Confirm:$false 


#test abp role exchange addresslist
Get-GlobalAddressList | fl
Get-ManagementRoleEntry -Identity *\Get-GlobalAddressList
(Get-GlobalAddressList 'Default Global Address List').RecipientFilter
Get-OfflineAddressBook
(Get-AddressList "all contacts") | fl
Get-AddressBookPolicy Tous_fdcorp_policy | fl
set-AddressBookPolicy -Identity '3450b905-7ab5-4024-9e34-35e8e2235cf0' -GlobalAddressList 'd8a002dd-1cf0-4e37-b9ad-c275fa8af44a' -OfflineAddressBook '\Default Offline Address Book' -RoomList 'All Rooms' -AddressLists 'All Groups'
Get-AddressList -Identity "all contacts" | Format-Table -Auto Name,RecipientFilterApplied

#$al = Get-AddressBookPolicy Tous_fdcorp_policy; Get-Recipient -ResultSize unlimited -RecipientPreviewFilter $al.RecipientFilter |fl Name,PrimarySmtpAddress,HiddenFromAddressListsEnabled
$al = Get-Contact -Identity 'Callq.sg.niv1@fdcorp.ca' |fl; Get-Contact -ResultSize unlimited -RecipientPreviewFilter $al.RecipientFilter |fl Name,PrimarySmtpAddress,HiddenFromAddressListsEnabled,UserPrincipalName
#$AL = Get-AddressList -Identity 'all contacts'; Get-Recipient -ResultSize unlimited -RecipientPreviewFilter $AL.RecipientFilter | select Name,PrimarySmtpAddress,HiddenFromAddressListsEnabled
#$Before = Get-DistributionGroup -Filter {((RecipientType -eq 'MailUniversalDistributionGroup') -and (windowsemailaddress -like '*@domaineclient.com'))} -ResultSize Unlimited
Get-Contact -Filter $al.RecipientFilter
Get-Contact -Identity "Callq.sg.niv1@fdcorp.ca" |fl

set-AddressList -Identity 'CallQ_list' -Identity {(DisplayName -like 'CallQ*')}

#prendre jusqu’à 7 jours en Exchange Online.
#$Mailboxes = Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox"}
#$Mailboxes.Identity | Start-ManagedFolderAssistant
connect-msolservice
(get-msoluser -UserPrincipalName "Callq.sg.niv1@fdcorp.ca").licences
Get-Mailbox -Identity "655c909d-ce07-4fc0-a0c7-a2d7e1a8117d"
$Mailboxes = Get-Mailbox -Identity "M365_ecn@fdcorp.ca"
$Mailboxes | fl Select-Object MailUserIdParameter
Start-ManagedFolderAssistant -Identity "655c909d-ce07-4fc0-a0c7-a2d7e1a8117d"

#teams address list
get-mailbox -Identity "call*"
Get-TeamUse