Connect-ExchangeOnline
$Mailboxes = Get-Content "C:\Temp\blacklist\items.csv"
ForEach ($Mailbox in $Mailboxes)
{ 
New-TenantAllowBlockListItems -ListType Sender -Block -Entries $Mailbox -NoExpiration
}
