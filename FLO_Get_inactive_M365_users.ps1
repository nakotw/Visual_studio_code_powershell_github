<#
AUTHOR: Daniel Bradley
LINKEDIN: https://www.linkedin.com/in/danielbradley2/
TWITTER: https://twitter.com/DanielatOCN
WEBSITE: https://ourcloudnetwork.com/
Info: This script was written by Daniel Bradley for the ourcloudnetwork.com blog
#>

#Connect to Microsoft Graph
Connect-MgGraph -scope User.Read.All, AuditLog.read.All

#Select the beta profile
Select-MgProfile -name beta

#Gather all users in tenant
$AllUsers = Get-MgUser -All

#Create a new empty array list object
$Report = [System.Collections.Generic.List[Object]]::new()

Foreach ($user in $AllUsers)
{
    #Null variables
    $SignInActivity = $null
    $Licenses = $null

    #Display progress output
    Write-host "Gathering sign-in information for $($user.DisplayName)" -ForegroundColor Cyan

    #Get current user information
    $SignInActivity = Get-MgUser -UserId  $user.id -Property signinactivity | Select-Object -ExpandProperty signinactivity
    $licenses = (Get-MgUserLicenseDetail -UserId $User.id).SkuPartNumber -join ", "

    #Create informational object to add to report
    $obj = [pscustomobject][ordered]@{
            DisplayName              = $user.DisplayName
            UserPrincipalName        = $user.UserPrincipalName
            Licenses                 = $licenses
            LastInteractiveSignIn    = $SignInActivity.LastSignInDateTime
            LastNonInteractiveSignin = $SignInActivity.LastNonInteractiveSignInDateTime
        }
    
    #Add current user info to report
    $report.Add($obj)
}

$report | Export-CSV -path C:\temp\Microsoft365_User_Activity-Report-fdcorp.csv -NoTypeInformation