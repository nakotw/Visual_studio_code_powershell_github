$hpsurerun1 = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "HP Security Update Service" }
$hpsurerun2 = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "HP Wolf Security - Console" }
$hpsurerun3 = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "HP Sure Sense" }
$hpsurerun4 = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "HP Sure Click active" }
$hpsurerun5 = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "HP Connection Optimizer" }
$hpsurerun6 = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "HP Notifications" }
$hpsurerun7 = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "HP Sure Recover" }
$hpsurerun8 = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "HP Sure Run Module" }
$hpsurerun9 = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "HP Wolf Security" }
$hpsurerun10 = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "HP Wolf Security Application Support for Sure Sense" }
$hpsurerun11 = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "HP Wolf Security Application Support for Office" }
$hpsurerun12 = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "HP Wolf Security Application Support for Chrome 112.0.5615.183" }
$hpsurerun13 = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "HP Wolf Security Application Support for Adobe Reader" }
try {
    if (!($hpsurerun5 -eq $null)) {
        $hpsurerun5.uninstall()
    }
    if (!($hpsurerun6 -eq $null)) {
        $hpsurerun6.uninstall()
    }
    if (!($hpsurerun7 -eq $null)) {
        $hpsurerun7.uninstall()
    }
    if (!($hpsurerun8 -eq $null)) {
        $hpsurerun8.uninstall()
    }
    if (!($hpsurerun2 -eq $null)) {
        $hpsurerun2.uninstall()
    }
    if (!($hpsurerun3 -eq $null)) {
        $hpsurerun3.uninstall()
    }
    if (!($hpsurerun4 -eq $null)) {
        $hpsurerun4.uninstall()
    }
    if (!($hpsurerun1 -eq $null)) {
        $hpsurerun1.uninstall()
    }
    if (!($hpsurerun10 -eq $null)) {
        $hpsurerun9.uninstall()
    }
    if (!($hpsurerun11 -eq $null)) {
        $hpsurerun9.uninstall()
    }
    if (!($hpsurerun12 -eq $null)) {
        $hpsurerun12.uninstall()
    }
    if (!($hpsurerun13 -eq $null)) {
        $hpsurerun13.uninstall()
    }
    if (!($hpsurerun9 -eq $null)) {
        $hpsurerun9.uninstall()
    }
    Write-Host -object "Fallback to get-wmi for HP Wolf uninstall" 
}
Catch {
    Write-Warning -Message "Failed to uninstall HP apps using get-wmiobject - Error message: $($_.Exception.Message)" 
}
