Adding the answer for future people who find this thread. Credit Jacobdog97 with getting me there, but here is my full process:

Change 1:Add GROUP CONTANING ALL HYBRID DEVICES to AUTOPILOT PROFILE

Make sure that the "Convert all targeted devices to Autopilot" is set to yes in your Autopilot profileWait a week to allow the devices to import (May not be required, we are a large Org)

Change 2:Export all device Serial Numbers from GROUP CONTANING ALL HYBRID DEVICESUpload all Serial Numbers to CSV FILE CONTAINING SERIAL NUMBERS -

HEADER OF COLUMN SHOULD BE - serialNumberRun Script from Elevated PowerShell ISE

Script:

Install-Module WindowsAutoPilotIntuneImport-Module WindowsAutoPilotIntuneConnect-MsGraph$serials = Import-CSV -Path "CSV FILE"foreach ($pc in $serials) { $sn = $pc. serialNumberwrite-host "Assigning group tag TAG to: " $snGet-AutopilotDevice -serial $sn | Set-AutoPilotDevice -grouptag "GROUP TAG" }Invoke-AutopilotSync