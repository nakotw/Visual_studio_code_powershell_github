$PackageName = "Block-Wi-Fi-SSID"
$Path_local = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
Start-Transcript -Path "$Path_local\$PackageName-install.log" -Force
netsh wlan delete profile name="PEDAGO-CSLSJ" i=*
netsh wlan delete profile name="Invite-CSLSJ" i=*
netsh wlan delete profile name="INTERNET-CSLSJ" i=*
netsh wlan add filter permission=block ssid="PEDAGO-CSLSJ" networktype=infrastructure
netsh wlan add filter permission=block ssid="Invite-CSLSJ" networktype=infrastructure
netsh wlan add filter permission=block ssid="INTERNET-CSLSJ" networktype=infrastructure
Stop-Transcript