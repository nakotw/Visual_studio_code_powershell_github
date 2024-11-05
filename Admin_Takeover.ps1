Install-Module -Name MSOnline
$msolcred = get-credential

connect-msolservice -credential $msolcred



Get-MsolDomain


Get-MsolDomainVerificationDns –DomainName maconnex.com –Mode DnsTxtRecord


#Copy the value (the challenge) that is returned from this command. For example:
MS=32DD01B82C05D27151EA9AE93C5890787F0E65D9

#In your public DNS namespace, create a DNS txt record that contains the value that you copied in the previous step. The name for this record is the name of the parent domain, so if you create this resource record by using the DNS role from Windows Server, leave the Record name blank and just paste the value into the Text box.


Confirm-MsolDomain –DomainName maconnex.com –ForceTakeover Force