# This task will run once per day at 9AM, only on week days
$GGG = "$ENV:USERNAME"
if (!(Test-Path "c:\intune\winget\winget-list-option.bat")) {
    mkdir c:\intune\winget
    cd c:\intune\winget
    curl -uri "https://rgstockage1.blob.core.windows.net/intune-install/winget/winget-list-option.bat" -outfile "c:\intune\winget\winget-list-option.bat"

    
}
try {
    $wingetaps = Get-ScheduledTaskInfo -TaskName "winget-list-option-$GGG"
}
catch {
    Write-Host vide
}

$GG = "$ENV:USERDOMAIN\$ENV:USERNAME"

if ($wingetaps -eq $null) {
    $A = New-ScheduledTaskAction -Execute "c:\intune\winget\winget-list-option.bat" -WorkingDirectory "c:\intune\winget"
    $T = New-ScheduledTaskTrigger -At 9am -Weekly -DaysofWeek Friday
    $P = New-ScheduledTaskPrincipal -UserId $GG -LogonType Interactive -RunLevel Highest
    $S = New-ScheduledTaskSettingsSet
    $D = New-ScheduledTask -Action $A -Principal $P -Trigger $T -Settings $S
    Register-ScheduledTask "winget-list-option-$GGG" -InputObject $D
}
else {
    $T = New-ScheduledTaskTrigger -At 9am -Weekly -DaysofWeek Friday
    Set-ScheduledTask -TaskName "winget-list-option-$GGG" -Trigger $T
}

#$A = New-ScheduledTaskAction -Execute "c:\intune\winget\winget-list-option.bat" -WorkingDirectory "c:\intune\winget"
#    $T = New-ScheduledTaskTrigger -AtLogOn -User $GG
#    $P = New-ScheduledTaskPrincipal -UserId $GG -LogonType Interactive -RunLevel Highest
#    $S = New-ScheduledTaskSettingsSet
#    $D = New-ScheduledTask -Action $A -Principal $P -Trigger $T -Settings $S
#    Register-ScheduledTask "winget-list-option5" -InputObject $D
#
#
# This task will run once per day at 9AM, only on week days

#$A = New-ScheduledTaskAction -Execute "c:\scripts\my_project\scheduled_task.bat" -WorkingDirectory "c:\scripts\my_project"
#$T = New-ScheduledTaskTrigger -At 9am -Weekly -DaysofWeek Monday, Tuesday, Wednesday, Thursday, Friday
#$P = New-ScheduledTaskPrincipal -UserId "LOCALSERVICE" -LogonType ServiceAccount
#$S = New-ScheduledTaskSettingsSet
#$D = New-ScheduledTask -Action $A -Principal $P -Trigger $T -Settings $S
#Register-ScheduledTask "My Project" -InputObject $D