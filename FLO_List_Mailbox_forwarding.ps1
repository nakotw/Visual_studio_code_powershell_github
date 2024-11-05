#For all users

Get-Mailbox -ResultSize Unlimited -RecipientTypeDetails UserMailbox | Select UserPrincipalName, ForwardingSmtpAddress, DeliverToMailboxAndForward

#For 1 specific user

Get-Mailbox -Identity "aclement@dsavocats.ca" | select UserPrincipalName, ForwardingSmtpAddress, DeliverToMailboxAndForward