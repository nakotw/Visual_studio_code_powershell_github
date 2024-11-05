#   Remove HP bloatware / crapware

# List of built-in apps to remove
$UninstallPackages = @(
    "AD2F1837.HPJumpStarts"
    "AD2F1837.HPPCHardwareDiagnosticsWindows"
    "AD2F1837.HPPowerManager"
    "AD2F1837.HPPrivacySettings"
    "AD2F1837.HPSupportAssistant"
    "AD2F1837.HPSureShieldAI"
    "AD2F1837.HPSystemInformation"
    "AD2F1837.HPQuickDrop"
    "AD2F1837.HPWorkWell"
    "AD2F1837.myHP"
    "AD2F1837.HPDesktopSupportUtilities"
    "AD2F1837.HPQuickTouch"
    "AD2F1837.HPEasyClean"
    "AD2F1837.HPSystemInformation"
)

# List of programs to uninstall
$UninstallPrograms = @(
    "HP Client Security Manager"
    "HP Connection Optimizer"
    "HP Documentation"
    "HP MAC Address Manager"
    "HP Notifications"
    "HP Security Update Service"
    "HP System Default Settings"
    "HP Sure Click"
    "HP Sure Click Security Browser"
    "HP Sure Run"
    "HP Sure Recover"
    "HP Sure Sense"
    "HP Sure Sense Installer"
    "HP Wolf Security"
    "HP Wolf Security Application Support for Sure Sense"
    "HP Wolf Security Application Support for Windows"
)

$HPidentifier = "AD2F1837"

$InstalledPackages = Get-AppxPackage -AllUsers `
| Where-Object { ($UninstallPackages -contains $_.Name) -or ($_.Name -match "^$HPidentifier") }

$ProvisionedPackages = Get-AppxProvisionedPackage -Online `
| Where-Object { ($UninstallPackages -contains $_.DisplayName) -or ($_.DisplayName -match "^$HPidentifier") }

$InstalledPrograms = Get-Package | Where-Object { $UninstallPrograms -contains $_.Name }

# Remove appx provisioned packages - AppxProvisionedPackage
ForEach ($ProvPackage in $ProvisionedPackages) {

    Write-Host -Object "Attempting to remove provisioned package: [$($ProvPackage.DisplayName)]..."

    Try {
        $Null = Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
        Write-Host -Object "Successfully removed provisioned package: [$($ProvPackage.DisplayName)]"
    }
    Catch { Write-Warning -Message "Failed to remove provisioned package: [$($ProvPackage.DisplayName)]" }
}

# Remove appx packages - AppxPackage
ForEach ($AppxPackage in $InstalledPackages) {
                                            
    Write-Host -Object "Attempting to remove Appx package: [$($AppxPackage.Name)]..."

    Try {
        $Null = Remove-AppxPackage -Package $AppxPackage.PackageFullName -AllUsers -ErrorAction Stop
        Write-Host -Object "Successfully removed Appx package: [$($AppxPackage.Name)]"
    }
    Catch { Write-Warning -Message "Failed to remove Appx package: [$($AppxPackage.Name)]" }
}

# Remove installed programs
$InstalledPrograms | ForEach-Object {

    Write-Host -Object "Attempting to uninstall: [$($_.Name)]..."

    Try {
        $Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction Stop
        Write-Host -Object "Successfully uninstalled: [$($_.Name)]"
    }
    Catch { Write-Warning -Message "Failed to uninstall: [$($_.Name)]" }
}

# Fallback attempt 1 to remove HP Wolf Security using msiexec
MsiExec /x "{0E2E04B0-9EDD-11EB-B38C-10604B96B11E}" /qn /norestart


# Fallback attempt 2 to remove HP Wolf Security using msiexec
MsiExec /x "{4DA839F0-72CF-11EC-B247-3863BB3CB5A8}" /qn /norestart


# Fallback attempt 3 to remove HP Wolf Security using msiexec
MsiExec.exe /X "{5A0FD8F0-0091-11EE-8EF1-3863BB3CB5A8}" /qn /norestart


# Fallback attempt 3 to remove HP Wolf Security Console using msiexec
MsiExec.exe /X "{ 2912F869-097A-407B-A2A5-388799DBA64C }" /qn /norestart


# Fallback attempt 3 to remove HP Wolf Security Application Support for Office using msiexec
MsiExec.exe /I "{827A208E-A87A-44F2-A8AB-AB86A9445794}" /qn /norestart


# Fallback attempt 3 to remove HP Wolf Security Application Support for Sure Sense using msiexec
MsiExec.exe /I "{B3A92BA1-5A53-4063-B41B-E0C51D6A6146 }" /qn /norestart


# Fallback attempt 3 to remove HP Sure Recover using msiexec
MsiExec.exe /X "{DE19530B-11E5-4F64-BAFF-751F9182E593 }" /qn /norestart

# Fallback attempt 3 to remove HP Sure Run Mobile using msiexec
MsiExec.exe /X "{F5CEB990-61F1-46F0-9AAE-9A3A6FED8BC7}" /qn /norestart

# Fallback attempt 3 to remove HP Wolf Security Application Support for Chrome 112.0.5615.206 using msiexec
MsiExec.exe /I "{FD173350-467F-41BD-B295-DA2B5740B7CE}" /qn /norestart

#HP Wolf Security - Console
MsiExec.exe /X "{2912F869-097A-407B-A2A5-388799DBA64C }" /qn /norestart

#HP Wolf Security Application Support for Office
MsiExec.exe /I "{827A208E-A87A-44F2-A8AB-AB86A9445794 }" /qn /norestart

#HP Security Update Service
MsiExec.exe /X "{F32CC23F-2FCC-42AC-A0A1-EF8AC7A21514 }" /qn /norestart

#HP Wolf Security Application Support for Chrome 112.0.5615.206
MsiExec.exe /I "{FD173350-467F-41BD-B295-DA2B5740B7CE}" /qn /norestart


# This section show what is left behind
Write-Host "Checking stuff after running script"
Write-Host "For Get-AppxPackage -AllUsers"
Get-AppxPackage -AllUsers | where { $_.Name -like "*HP*" }
Write-Host "For Get-AppxProvisionedPackage -Online"
Get-AppxProvisionedPackage -Online | where { $_.DisplayName -like "*HP*" }
Write-Host "For Get-Package"
Get-Package | select Name, FastPackageReference, ProviderName, Summary | Where { $_.Name -like "*HP*" } | Format-List

# Ask for reboot after running the script - Uncomment if you want!
# $input = Read-Host "Restart computer now [y/n]"
# switch($input){
#           y{Restart-computer -Force -Confirm:$false}
#           n{exit}
#     default{write-warning "Skipping reboot."}
# }
