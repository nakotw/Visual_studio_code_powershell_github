Connect-ExchangeOnline

$users = Get-Mailbox | Where-Object{$_.PrimarySMTPAddress -match "@rossmannarchitecture.ca"}
foreach($user in $users){
    Write-Host "Adding Alias $($user.alias)@raai.ca"
    Set-Mailbox $user.PrimarySMTPAddress -EmailAddresses @{add="$($user.Alias)@raai.ca"} -Whatif
}