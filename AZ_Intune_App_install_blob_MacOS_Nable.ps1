param (
	[System.String]$ZipSourceFiles      = "",
    [system.string]$IntuneProgramDir    = "$env:APPDATA\Intune",
    [System.String]$FullEXEDir          = "$IntuneProgramDir\LazyAdminAgent\setup.exe",
    [System.String]$ZipLocation         = "$IntuneProgramDir\LazyAdmin.zip",
    [System.String]$TempNetworkZip      = "\\LazyAdmin-DC01\Intune$\LazyAdmin.zip"
)
#Check to see if the binaries are cached locally
If ((Test-Path $TempNetworkZip) -eq $False)
{
    #Start download of the source files from Azure Blob to the network cache location
    Start-BitsTransfer -Source $ZipSourceFiles -Destination $TempNetworkZip

    #Check to see if the local cache directory is present
    If ((Test-Path -Path $IntuneProgramDir) -eq $False)
    {
        #Create the local cache directory
        New-Item -ItemType Directory $IntuneProgramDir -Force -Confirm:$False
    }

    #Copy the binaries from the network cache to the local computer cache
    Copy-Item $TempNetworkZip -Destination $IntuneProgramDir  -Force
    
    #Extract the install binaries
    Expand-Archive -Path $ZipLocation -DestinationPath $IntuneProgramDir -Force

    #Install the program
    Start-Process "$FullEXEDir" -ArgumentList " /S /v/qn"
}
Else {
    #Check to see if the local cache directory is present
    If ((Test-Path -Path $IntuneProgramDir) -eq $False)
    {
        #Create the local cache directory
        New-Item -ItemType Directory $IntuneProgramDir -Force -Confirm:$False
    }

    #Copy the installer binaries from the network cache location to the local computer cache
    Copy-Item $TempNetworkZip -Destination $IntuneProgramDir  -Force
    
    #Extract the install binaries
    Expand-Archive -Path $ZipLocation -DestinationPath $IntuneProgramDir -Force

    #Install the program
    Start-Process "$FullEXEDir" -ArgumentList " /S /v/qn"
}