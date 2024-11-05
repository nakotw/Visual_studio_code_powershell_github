#AZ_intune_windowsHello_postpone
#Defining the variables we need
[string]$ConfigKey = 'HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork'
[string]$ConfigItemName = 'DisablePostLogonProvisioning'
[string]$ConfigItemEnabled = 'Enabled'
[string]$ConfigItemType = 'DWORD'
[int]$ConfigItemValue = 1
#Ensure the key exists to avoid an error
If(!(Test-Path $ConfigKey)) {
# Create the key if it doesn’t exist already
New-Item -Path $ConfigKey -Force | Out-Null
}
#Create the item we need
New-ItemProperty -Path $ConfigKey -Name $ConfigItemName -Value $ConfigItemValue -PropertyType $ConfigItemType -Force | Out-Null
New-ItemProperty -Path $ConfigKey -Name $ConfigItemEnabled -Value $ConfigItemValue -PropertyType $ConfigItemType -Force | Out-Null