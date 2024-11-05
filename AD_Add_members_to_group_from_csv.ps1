#Get Credentials to connect
Connect-ExchangeOnline
 
Import-CSV "C:\Temp\groupmembers.csv" | foreach {  
    $UPN=$_.UPN 
    Write-Progress -Activity "Adding $UPN to group… " 
    Add-DistributionGroupMember –Identity "LIC_Business_Premium" -Member $UPN  
    If($?)  
    {  
    Write-Host $UPN Successfully added -ForegroundColor Green 
    }  
    Else  
    {  
    Write-Host $UPN - Error occurred –ForegroundColor Red  
    }  
   } 
 
#Disconnect Exchange Online
Disconnect-ExchangeOnline -Confirm:$False