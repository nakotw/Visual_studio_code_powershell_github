﻿New-NetFirewallRule -DisplayName "Teams.exe" -Program "%LocalAppData%\Microsoft\Teams\current\Teams.exe" -Profile Public,Private -Direction Inbound -Action Allow -Protocol Any -EdgeTraversalPolicy Block