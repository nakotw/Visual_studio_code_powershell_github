Connect-MicrosoftTeams 
Connect-MsolService

#$BusinessVoice 

#$O365E5 

$BusinessVoice = "reseller-account:MCOEV" 

#Nom de la politique CallerID 

#$CallerID = "global" 

 

$Users = Get-MsolUser -All | Where-Object {$_.isLicensed -eq "TRUE" -and $_.Licenses.AccountSKUID -eq "$BusinessVoice"} 

Foreach ($User in $Users) 

{ 

    $UPN = ($User).UserPrincipalName 

    Set-CsUser -Identity $UPN -HostedVoiceMail $true 

    Set-CsPhoneNumberAssignment -Identity $UPN -EnterpriseVoiceEnabled $true 

   #Grant-CsCallingLineIdentity -Identity $UPN -PolicyName $CallerID 

} 