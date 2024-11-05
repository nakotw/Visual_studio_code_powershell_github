$vm = Get-AzConnectedMachine -ResourceGroupName "rg-defender-for-cloud-001" -Name "CVDA13"
$mdePackage = Invoke-AzRestMethod -Uri https://management.azure.com/subscriptions/$($vm.id.split('/')[2])/providers/Microsoft.Security/mdeOnboardings/?api-version=2021-10-01-preview

$protectedSetting = @{
    "defenderForEndpointOnboardingScript" = ($mdePackage.content | ConvertFrom-Json).value.properties.onboardingPackageWindows
}

$Setting = @{
    "azureResourceId" = $vm.Id
    "vNextEnabled" = $true
}
New-AzConnectedMachineExtension -Name 'MDE.Windows' -ExtensionType 'MDE.Windows' -ResourceGroupName $vm.ResourceGroupName -MachineName $vm.Name -Location $vm.Location -Publisher 'Microsoft.Azure.AzureDefenderForServers' -Settings $Setting -ProtectedSetting $protectedSetting -AutoUpgradeMinorVersion -TypeHandlerVersion '1.0'