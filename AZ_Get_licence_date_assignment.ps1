
<#
Récupérer date d'assignation de licence M365 en fonction du Service Plan ID (modifier la ligne 120)
#>

#Requires -Module AzureAD,ImportExcel

<# 

    .DESCRIPTION 
    License Assignment Dates 

#> 
Param(
$run="run")
function New-FolderCreation
{
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true)]
    [string]$foldername
  )
	

  $logpath  = (Get-Location).path + "\" + "$foldername" 
  $testlogpath = Test-Path -Path $logpath
  if($testlogpath -eq $false)
  {
    #Start-ProgressBar -Title "Creating $foldername folder" -Timer 10
    $null = New-Item -Path (Get-Location).path -Name $foldername -Type directory
  }
}
function Write-Log
{
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true,ParameterSetName = 'Create')]
    [array]$Name,
    [Parameter(Mandatory = $true,ParameterSetName = 'Create')]
    [string]$Ext,
    [Parameter(Mandatory = $true,ParameterSetName = 'Create')]
    [string]$folder,
    
    [Parameter(ParameterSetName = 'Create',Position = 0)][switch]$Create,
    
    [Parameter(Mandatory = $true,ParameterSetName = 'Message')]
    [String]$message,
    [Parameter(Mandatory = $true,ParameterSetName = 'Message')]
    [String]$path,
    [Parameter(Mandatory = $false,ParameterSetName = 'Message')]
    [ValidateSet('Information','Warning','Error')]
    [string]$Severity = 'Information',
    
    [Parameter(ParameterSetName = 'Message',Position = 0)][Switch]$MSG
  )
  switch ($PsCmdlet.ParameterSetName) {
    "Create"
    {
      $log = @()
      $date1 = Get-Date -Format d
      $date1 = $date1.ToString().Replace("/", "-")
      $time = Get-Date -Format t
	
      $time = $time.ToString().Replace(":", "-")
      $time = $time.ToString().Replace(" ", "")
      New-FolderCreation -foldername $folder
      foreach ($n in $Name)
      {$log += (Get-Location).Path + "\" + $folder + "\" + $n + "_" + $date1 + "_" + $time + "_.$Ext"}
      return $log
    }
    "Message"
    {
      $date = Get-Date
      $concatmessage = "|$date" + "|   |" + $message +"|  |" + "$Severity|"
      switch($Severity){
        "Information"{Write-Host -Object $concatmessage -ForegroundColor Green}
        "Warning"{Write-Host -Object $concatmessage -ForegroundColor Yellow}
        "Error"{Write-Host -Object $concatmessage -ForegroundColor Red}
      }
      
      Add-Content -Path $path -Value $concatmessage
    }
  }
} #Function Write-Log
####################Load variables and log#######################################
$log = Write-Log -Name "LicenseAssignmentDates-Log" -folder "logs" -Ext "log"
New-FolderCreation -foldername report
$report1 = (Get-Location).path + "\report\LicenseAssignmentDates-Report.xlsx"
$csv = (Get-Location).path + "\report\tempcsv3.csv"
##################################################################################
try{
  Write-Log -Message "Start ................Script" -path $log
  Write-Log -Message "Connect to AZUREAD" -path $log
  Connect-AzureAD
  import-module ImportExcel
}
catch{
  $exception = $_.Exception.Message
  Write-Log -Message "exception $exception has occured Connecting to AzureAD"  -path $log -Severity Error
  Exit
}
#######################Get all Azure AD Users###################################################
Write-Log -Message "Get all AzureAD Users" -path $log
try{
  [System.Collections.ArrayList]$collection = @()
  $getallazureadusers = Get-AzureADUser -Filter "UserType eq 'Member'" -All $true
  Write-Log -Message "Fetched all AzureAD Users" -path $log
  $getallazureadusers | ForEach-Object{
    $upn = $_.UserPrincipalName
    $coll = "" | Select UserPrincipalName,DomesticCalling, DomesticCallingPrepaid, CommunicationCredits # for reporting add the names 
    $coll.UserPrincipalName =  $upn
    $getazureaduserServiceid = $_.assignedplans
    $getazureaduserServiceid | where{$_.CapabilityStatus -eq "Enabled"}| foreach-object{
      $serviceplanid = $_.ServicePlanId
      $AssignedTimestamp = get-date $($_.AssignedTimestamp) -Format MM/dd/yy
      ############updated serviceplanid here#######################
      switch($serviceplanid){
        "663a804f-1c30-4ff0-9915-9db84f0d1cea" { $coll.DomesticCalling = $AssignedTimestamp }
        default{}
      }
      #####################################################################################
    }
      $collection.add($coll) | Out-Null
  }
  Write-Log -Message "Exporting the data to Report" -path $log
  $collection | Export-Csv $csv
  import-csv $csv | Export-Excel $Report1
}
catch{
  $exception = $_.Exception.Message
  Write-Log -Message "exception occured $exception" -path $log -Severity Error
  exit
}
Disconnect-AzureAD
Write-Log -Message "Script Finished" -path $log
#################################################################################################
