<#

Create CSV file with this format

UserPrincipalName,ForwardingSMTPAddress
user1@example.com,external1@externaldomain.com
user2@example.com,external2@externaldomain.com

#>

Connect-ExchangeOnline

# Import the CSV file
$users = Import-Csv -Path "C:\Path\To\Your\File.csv"

# Loop through each user and configure forwarding
foreach ($user in $users) {
    # Get the user principal name and forwarding address from the CSV
    $userPrincipalName = $user.UserPrincipalName
    $forwardingSMTPAddress = $user.ForwardingSMTPAddress

    # Set the forwarding address
    Set-Mailbox -Identity $userPrincipalName -ForwardingSmtpAddress $forwardingSMTPAddress -DeliverToMailboxAndForward $false

    # Optionally, you can set the deliver to mailbox and forward parameter to true if you want to keep a copy in the user's mailbox
    # Set-Mailbox -Identity $userPrincipalName -ForwardingSmtpAddress $forwardingSMTPAddress -DeliverToMailboxAndForward $true

    Write-Output "Forwarding set for $userPrincipalName to $forwardingSMTPAddress"
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline