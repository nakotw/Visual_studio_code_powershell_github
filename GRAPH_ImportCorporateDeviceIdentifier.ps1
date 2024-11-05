Install-Module microsoft.graph -Confirm:$False -Force

Connect-MgGraph
 
$ImportDevices_URL = "https://graph.microsoft.com/beta/deviceManagement/importedDeviceIdentities/importDeviceIdentityList"
 
$Get_Computer_Info = Get-Ciminstance -Class Win32_ComputerSystem 
$Manufacturer = $Get_Computer_Info.Manufacturer
$Model = $Get_Computer_Info.Model
$SerialNumber = (Get-Ciminstance -Class Win32_BIOS).SerialNumber
 
$Body = @{
    overwriteImportedDeviceIdentities = $false
    importedDeviceIdentities = @(
        @{
            importedDeviceIdentityType = "manufacturerModelSerial"
            importedDeviceIdentifier = "$Manufacturer,$Model,$SerialNumber"
        }
    )
}
 
Invoke-MgGraphRequest -Uri $ImportDevices_URL -Method POST -Body $Body