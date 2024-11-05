Connect-MicrosoftTeams
Get-CsInboundBlockedNumberPattern
New-CsInboundBlockedNumberPattern -Name "BlockNumbergmichaud" -Enabled $True -Description "Block gmichaud cell" -Pattern "^\+?14185720472$"
New-CsInboundBlockedNumberPattern -Name "BlockNumbergmichaud418" -Enabled $True -Description "Block gmichaud cell" -Pattern "^\?4185720472$"
New-CsInboundBlockedNumberPattern -Name "BlockNumberGB01" -Enabled $True -Description "Block GB01" -Pattern "^\+?442036425968$"
New-CsInboundBlockedNumberPattern -Name "BlockNumberGB44203d7" -Enabled $True -Description "Block Contoso" -Pattern "^\+?44203\d{7}$"
#New-CsInboundBlockedNumberPattern -Name "BlockRange1" -Enabled $True -Description "Block Contoso" -Pattern "^\+?44203\d{7}$"
set-CsInboundBlockedNumberPattern -Identity "BlockNumbergmichaud418" -Enabled $True -Description "Block gmichaud cell" -Pattern "4185720472$"
Remove-CsInboundBlockedNumberPattern -Identity "BlockNumbergmichaud"


#test
# ça peut prendre plusieurs minutes avant le test soit à True
Test-CsInboundBlockedNumberPattern -PhoneNumber 14185720472
Test-CsInboundBlockedNumberPattern -PhoneNumber 4185720472
Test-CsInboundBlockedNumberPattern -PhoneNumber 442036425968



#set-CsInboundBlockedNumberPattern -Identity "BlockNumbergmichaud418" -Enabled $True -Description "Block gmichaud cell" -Pattern "^\?4185720472$"
#set-CsInboundBlockedNumberPattern -Identity "BlockNumbergmichaud418" -Enabled $True -Description "Block gmichaud cell" -Pattern "^\+?4185720472$"
set-CsInboundBlockedNumberPattern -Identity "BlockNumbergmichaud418" -Enabled $True -Description "Block gmichaud cell" -Pattern "4185720472$"
#set-CsInboundBlockedNumberPattern -Identity "BlockNumbergmichaud418" -Enabled $True -Description "Block gmichaud cell" -Pattern 
#set-CsInboundBlockedNumberPattern -Identity "BlockNumbergmichaud418" -Enabled $True -Description "Block gmichaud cell" -Pattern 


#poc Beanfield 14186586624 343
#from Miguel Urbina del Toro to everyone:    1:48 PM
#+14382225961 DID
#911
#tenant
#email
