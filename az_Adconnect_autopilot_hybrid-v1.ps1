
		# Wait until the devices have been imported
		#test
				
		#connect-AzureAD
		
		#Get-AzureADDevice -Property displayname $devicename | Select-Object ObjectId, deviceid, displayname
		#Get-AzureADDevice -Filter DisplayName $DeviceName
		#Get-AzureADDeviceConfiguration |fl
		#Connect-MsolService
		#Get-MsolDevice -Name LMICRO2021-GMI

		#Install-Module -Name Microsoft.Graph.Intune
		#Connect-MSGraph -AdminConsent
		#Get-DeviceManagement_ManagedDevices -devicename GAQC01-XZgHJ6t8
		#$DeviceName = hostname
		#(Get-DeviceManagement_ManagedDevices -Filter "devicename eq '$devicename'" | Select-Object profiletype | ft -HideTableHeaders | Out-String).Trim()
		#Get-IntuneManagedDevice -Filter "devicename eq '$devicename'"

	$user = “intuneServiceaccount@fdcorpsaintefoyltee.onmicrosoft.com”
	$password = “xxxxxxxx”
	$secPass = ConvertTo-SecureString $password -AsPlainText -Force
	$Cred = New-Object System.Management.Automation.PSCredential `
	($user, $secPass)
	Connect-AzureAD -Credential $cred | Out-Null
		#testend
        $DeviceName = hostname
		#$DeviceName = "nom du pc aubesoin pour test"
        $importStart = Get-Date
		$imported = @()
		$computers | % {
			$imported += $DeviceName
		}
		$processingCount = 1
		while ($processingCount -gt 0)
		{
			$current = @()
			$processingCount = 0
			$imported | % {
				$DeviceName = hostname
				#$DeviceName = "nom du pc aubesoin pour test"
                   if (!(Test-Path c:\intune)){
                   mkdir C:\Intune
                   }
				$DeviceName *> "c:\Intune\$DeviceName.log"
				$DeviceTypeNow = (Get-AzureADDevice -Filter "DisplayName eq '$DeviceName'" | Select-Object DeviceTrustType | ft -HideTableHeaders | Out-String).Trim()
                #$servertype = "ServerAd"
                #$DeviceTypeNow += Azuread
				$DeviceTypeNow *> "c:\Intune\$DeviceName.log"
                #get-azureaddevice -Filter displayname
                if (!($DeviceTypeNow -eq "ServerAd")) {
					$processingCount = $processingCount + 1
				}
				$current += $DeviceTypeNow
			}
			$deviceCount = $imported.Length
			Write-Host "Waiting for $processingCount of $deviceCount to be sync by ADconnect"
            Write-Host "Waiting for $DeviceTypeNow to be ServerAd"
			if ($processingCount -gt 0){
				Start-Sleep 5
			}
		}
		$importDuration = (Get-Date) - $importStart
		$importSeconds = [Math]::Ceiling($importDuration.TotalSeconds)
		$successCount = $imported.Length
		
		Write-Host "$successCount devices sync Hybrid successfully.  Elapsed time to complete import: $importSeconds seconds"
		
		# Wait until the devices can be found in Intune (should sync automatically)
		###test



		###testend




		#$syncStart = Get-Date
		#$processingCount = 1
		#while ($processingCount -gt 0)
		#{
		#	$autopilotDevices = @()
		#	$processingCount = 0
		#	$current | % {
		#		if ($DeviceType -eq "Hybribazureadjoind") {
		#			$DeviceType = (Get-AzureADDevice -Filter "displayname eq '$devicename'" | Select-Object profiletype | ft -HideTableHeaders | Out-String).Trim()
		#			if (-not $DeviceType) {
		#				$processingCount = $processingCount + 1
		#			}
		#			$autopilotDevices += $device
		#		}	
		#	}
		#	$deviceCount = $autopilotDevices.Length
		#	Write-Host "Waiting for $processingCount of $deviceCount to be synced"
		#	if ($processingCount -gt 0){
		#		Start-Sleep 30
		#	}
		#}
		#$syncDuration = (Get-Date) - $syncStart
		#$syncSeconds = [Math]::Ceiling($syncDuration.TotalSeconds)
		#Write-Host "All devices synced.  Elapsed time to complete sync: $syncSeconds seconds"

		## Add the device to the specified AAD group
		#if ($AddToGroup)
		#{
		#	$aadGroup = Get-AzureADGroup -Filter "DisplayName eq '$AddToGroup'"
		#	if ($aadGroup)
		#	{
		#		$autopilotDevices | % {
		#			$aadDevice = Get-AzureADDevice -ObjectId "deviceid_$($_.azureActiveDirectoryDeviceId)"
		#			if ($aadDevice) {
		#				Write-Host "Adding device $($_.serialNumber) to group $AddToGroup"
		#				Add-AzureADGroupMember -ObjectId $aadGroup.ObjectId -RefObjectId $aadDevice.ObjectId
		#			}
		#			else {
		#				Write-Error "Unable to find Azure AD device with ID $($_.azureActiveDirectoryDeviceId)"
		#			}
		#		}
		#		Write-Host "Added devices to group '$AddToGroup' ($($aadGroup.ObjectId))"
		#	}
		#	else {
		#		Write-Error "Unable to find group $AddToGroup"
		#	}
		#}

		## Assign the computer name 
		#if ($AssignedComputerName -ne "")
		#{
		#	$autopilotDevices | % {
		#		Set-AutopilotDevice -Id $_.Id -displayName $AssignedComputerName
		#	}
		#}

		## Wait for assignment (if specified)
		#if ($Assign)
		#{
		#	$assignStart = Get-Date
		#	$processingCount = 1
		#	while ($processingCount -gt 0)
		#	{
		#		$processingCount = 0
		#		$autopilotDevices | % {
		#			$device = Get-AutopilotDevice -id $_.id -Expand
		#			if (-not ($device.deploymentProfileAssignmentStatus.StartsWith("assigned"))) {
		#				$processingCount = $processingCount + 1
		#			}
		#		}
		#		$deviceCount = $autopilotDevices.Length
		#		Write-Host "Waiting for $processingCount of $deviceCount to be assigned"
		#		if ($processingCount -gt 0){
		#			Start-Sleep 30
		#		}	
		#	}
		#	$assignDuration = (Get-Date) - $assignStart
		#	$assignSeconds = [Math]::Ceiling($assignDuration.TotalSeconds)
		#	Write-Host "Profiles assigned to all devices.  Elapsed time to complete assignment: $assignSeconds seconds"	
		#	if ($Reboot)
		#	{
		#		Restart-Computer -Force
		#	}
		#}
	

