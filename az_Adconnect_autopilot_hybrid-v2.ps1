
# Wait until the devices have been sync adconnect
#log
if (!(Test-Path c:\Intune)) {
	mkdir c:\Intune
}
$Log_Error = [System.IO.StreamWriter] "c:\Intune\$(get-date -f yyyyMMddTHHmm)_log_Error.txt"
$myArray_Error = New-Object System.Collections.ArrayList

Write-Host "debut du script" *> c:\Intune\debut.log
#Set-ExecutionPolicy -ExecutionPolicy Bypass -Force

#module
try {
	# Get NuGet
	$Partner = $false
	Write-Host "debut try NuGet" *> c:\Intune\debutNuGet.log
	$provider = Get-PackageProvider NuGet -ErrorAction Ignore -Force
	$myArray_Error.add("$(get-date -f yyyyMMddTHHmm) 1er try")
	$Log_Error.Write("$(get-date -f yyyyMMddTHHmm) 1er try")
	$Log_Error.Write("`r`n") 
	if (-not $provider) {
		Write-Host "Installing provider NuGet" *> c:\Intune\NuGet.log
		Find-PackageProvider -Name NuGet -ForceBootstrap -IncludeDependencies
		$myArray_Error.add("$(get-date -f yyyyMMddTHHmm) 1er try NuGet")
		$Log_Error.Write("$(get-date -f yyyyMMddTHHmm) 1er try NuGet")
		$Log_Error.Write("`r`n")
	}
	# Get Azuread
	$module = Import-Module AzureAD -PassThru -ErrorAction Ignore -Force
	if (-not $module) {
		Write-Host "Installing module AzureAD" *> c:\Intune\AzureAD.log
        Install-Module AzureAD -Force *> c:\Intune\AzureADinstallmodule.log
        Import-Module AzureAD -Force *> c:\Intune\AzureADimportmodule.log
		$myArray_Error.add("$(get-date -f yyyyMMddTHHmm) 1er try AzureAD")
		$Log_Error.Write("$(get-date -f yyyyMMddTHHmm) 1er try AzureAD")
		$Log_Error.Write("`r`n")
	}
}
catch {
	Write-Host "error install module " *> c:\Intune\module-azuread.log
	$myArray_Error.add("$(get-date -f yyyyMMddTHHmm) 1er try module-azuread.log")
	$Log_Error.Write("$(get-date -f yyyyMMddTHHmm) 1er try module-azuread.log")
	$Log_Error.Write("`r`n")
	
}

#login
try {
	$user = “intuneServiceaccount@blcpa2.onmicrosoft.com”
	$password = “xxxxxxxxxx”
	$secPass = ConvertTo-SecureString $password -AsPlainText -Force
	$Cred = New-Object System.Management.Automation.PSCredential ($user, $secPass)
	Connect-AzureAD -Credential $cred | Out-Null
	$myArray_Error.add("$(get-date -f yyyyMMddTHHmm) 2er try login azuread")
	$Log_Error.Write("$(get-date -f yyyyMMddTHHmm) 2er try login azuread")
	$Log_Error.Write("`r`n")
}
catch {
	$myArray_Error.add("$(get-date -f yyyyMMddTHHmm) Error login")
	$Log_Error.Write("$(get-date -f yyyyMMddTHHmm) Error login")
	$Log_Error.Write("`r`n")
write-host "login fail"
}

#device lookup
$DeviceName = hostname
#$DeviceName = ""
$importStart = Get-Date
$imported = @()
$computers | % {
	$imported += $DeviceName
}
$processingCount = 1

#while loop
try {
	while ($processingCount -gt 0) {
		$current = @()
		$processingCount = 0
		$imported | % {
			$DeviceName = hostname
			#$DeviceName = ""
			#$DeviceName *> c:\Intune\test1.log
			Get-AzureADDevice -Filter "DisplayName eq '$devicename'" *> c:\Intune\Get-AzureADDevice.log
			$DeviceType = (Get-AzureADDevice -Filter "DisplayName eq '$devicename'" | Select-Object DeviceTrustType | ft -HideTableHeaders | Out-String).Trim()
			$LastDirSync = (Get-AzureADDevice -Filter "DisplayName eq '$devicename'" | Select-Object LastDirSyncTime | ft -HideTableHeaders | Out-String).Trim()
			$LastDirSync *> c:\Intune\LastDirSync.log
			#$deviceType = "ServerAd"
			#$devicetype *> c:\Intune\test2.log
			#get-azureaddevice -Filter displayname
			if ($LastDirSync -eq "") {
				$processingCount = $processingCount + 1
			}
						
						
			$current += $DeviceType
		}
		$deviceCount = $imported.Length
		Write-Host "Waiting for $processingCount of $deviceCount to be sync by ADconnect"
		Write-Host "Waiting for LastDirSyncTime $LastDirSync to be feel"
		Write-Host "Waiting for $DeviceType to be ServerAd"
        $Log_Error.Write("$(get-date -f yyyyMMddTHHmm) While")
	    $Log_Error.Write("`r`n")
		if ($processingCount -gt 0) {
			Start-Sleep 5
		}
	}
}
catch {
	if (!(Test-Path c:\Intune)) {
		mkdir c:\Intune
	}
	Write-Host "error try " *> c:\Intune\tryerror.log
}
		
$importDuration = (Get-Date) - $importStart
$importSeconds = [Math]::Ceiling($importDuration.TotalSeconds)
$successCount = $imported.Length
		
Write-Host "$successCount devices sync Hybrid successfully.  Elapsed time to complete import: $importSeconds seconds" *> c:\Intune\Hybridsync.log
$log_Error.Close()
#Start-Sleep 1800
