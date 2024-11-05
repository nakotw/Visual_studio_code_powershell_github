mkdir "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\startup"
$target = "C:\Windows\explorer.exe"
$shortcutfile = "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\startup\Portail_office.lnk"
$WScript = New-Object -ComObject WScript.Shell
$Shortcut = $WScript.CreateShortcut($shortcutfile)
$shortcut.Arguments='microsoft-edge:https://portal.office.com'
$shortcut.TargetPath = $target
$shortcut.Save()