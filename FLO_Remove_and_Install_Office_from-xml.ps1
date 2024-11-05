#remove all office apps

iwr https://raw.githubusercontent.com/nakotw/My-scripts/main/msoffice-removal-tool.ps1 -OutFile msoffice-removal-tool.ps1; powershell -ExecutionPolicy Bypass .\msoffice-removal-tool.ps1

#install office from xml

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-ExecutionPolicy Bypass
Install-Script -Name Install-Office365Suite -Force

$path = "C:\temp\"    
If (!(test-path $path)) {
    md $path
}

# Source file location
$source = 'https://raw.githubusercontent.com/nakotw/My-scripts/main/maconnex_apps_business.xml'
# Destination to save the file
$destination = 'c:\temp\maconnex_apps_business.xml'
#Download the file
Invoke-WebRequest -Uri $source -OutFile $destination

Install-Office365Suite.ps1 -ConfigurationXMLFile "c:\Temp\maconnex_apps_business.xml"