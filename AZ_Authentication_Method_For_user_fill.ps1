Install-module Microsoft.Graph.Identity.Signins
Connect-MgGraph -Scopes UserAuthenticationMethod.ReadWrite.All
Import-Module Microsoft.Graph.Identity.Signins

#Select-MgProfile -Name beta
New-MgUserAuthenticationPhoneMethod -UserId "gmichaudtest@fdcorp.ca" -phoneType "mobile" -phoneNumber "+1 4185720472"
