# PopulateTeamsHolidays.PS1
# Update the Teams holiday schedule with new events
#
# Create CSV file with column1 "Date" and column2 "Holiday"
# Ex:
#
# Date        Holiday
# 01/01/2023  New Year's Day 2023
# 17/03/2023  St Patrick's Day 2023
#

$Modules = Get-Module | Select-Object -ExpandProperty Name
If ("MicrosoftTeams" -notin $Modules) { 
   Connect-MicrosoftTeams }


$TeamsSchedule = @{}
# Fetch current Teams holiday schedule
Write-Host "Retrieving current Teams holiday schedule..."
[array]$CurrentSchedule = Get-CsOnlineSchedule | Where-Object {$_.Type -eq "Fixed"} | Select-Object Name, FixedSchedule
# Build hash table of current events
ForEach ($Event in $CurrentSchedule) {
  $EventDate = Get-Date($Event.FixedSchedule.DateTimeRanges.Start) -format d
  $TeamsSchedule.Add([string]$Event.Name,$EventDate)
}

# Read in public holidays file
$PublicHolidays = Import-CSV "c:\temp\IrishPublicHolidays.csv"

# Process each event from the holidays file, see if it exists already, and if not, add it as a Teams holiday
ForEach ($PublicHoliday in $PublicHolidays) {
   $Date = Get-Date($PublicHoliday.Date) -format d
   If ($TeamsSchedule[$PublicHoliday.Holiday] -ne $Date) {
      Write-Host ("Processing {0} on {1}" -f $PublicHoliday.Holiday, $PublicHoliday.Date)
      $HolidayDateRange = New-CsOnlineDateTimeRange -Start $Date
      $Status = New-CsOnlineSchedule -Name $PublicHoliday.Holiday -FixedSchedule -DateTimeRanges @($HolidayDateRange)
   } Else {
     Write-Host ("{0} event already registered for {1}" -f $PublicHoliday.Holiday, $Date) }
}

# Display Teams holiday schedule after the update is done
[array]$CurrentSchedule = Get-CsOnlineSchedule | Where-Object {$_.Type -eq "Fixed"} | Select-Object Name,  @{label="Holiday Date";expression={Get-Date($_.FixedSchedule.DateTimeRanges[0].Start) -format D}} | Sort-Object {$_.'Holiday Date' -as [datetime]}
Write-Host ""
Write-Host "Current Teams Holiday Schedule"
Write-Host "------------------------------"
$CurrentSchedule
