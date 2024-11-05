Import-Module ActiveDirectory

# Set the number of days since last logon
$DaysInactive = 1500
$InactiveDate = (Get-Date).Adddays(-($DaysInactive))

#-------------------------------
# FIND INACTIVE COMPUTERS
#-------------------------------
# Below are three options to find inactive computers. Select the one that is most appropriate for your requirements:

# Get AD Computers that haven't logged on in xx days
$Computers = Get-ADComputer -Filter { LastLogonDate -lt $InactiveDate -and Enabled -eq $true } -Properties LastLogonDate | Select-Object Name, LastLogonDate, DistinguishedName

# Get AD Computers that have never logged on
$Computers = Get-ADComputer -Filter { LastLogonDate -notlike "*" -and Enabled -eq $true } -Properties LastLogonDate | Select-Object Name, LastLogonDate, DistinguishedName

# Automated way (includes never logged on computers)
$Computers = Search-ADAccount -AccountInactive -DateTime $InactiveDate -ComputersOnly | Select-Object Name, LastLogonDate, Enabled, DistinguishedName

#-------------------------------
# SHOW DEVICES
#-------------------------------

#$Computers | Export-Csv C:\Temp\InactiveComputers.csv -NoTypeInformation
$Computers | Out-GridView


# Disable Inactive Computers
ForEach ($Item in $Computers){
$DistName = $Item.DistinguishedName
#Set-ADComputer -Identity $DistName -Enabled $false
#Move-ADObject -Identity $Item.DistinguishedName -TargetPath "OU=000 UNSYNC DISABLED,OU=CSLSJ Ordinateurs,DC=cslsj,DC=qc,DC=ca"
echo $DistName "a été désactivé et déplacé"
}