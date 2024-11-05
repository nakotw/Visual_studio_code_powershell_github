# Change this value, or feed it from a For-Each loop

$upn = ‘YCroteau@gbi.ca’

# Sign into Azure AD with a privileged user

#Connect-AzureAD

# Do not change anything below
#Install-Module -name AzureAD
#Import-Module AzureAD

function ConvertFrom-ImutableIDToMsConsistencyGuid {

      Param(

          [String]$ImmutableID

     )

     [GUID][System.Convert]::FromBase64String($ImmutableID)

}

Add-Type -AssemblyName Microsoft.VisualBasic
$path = [Microsoft.VisualBasic.Interaction]::InputBox('Dans quelle OU souhaitez lancer le script', 'User', "")
$users = get-aduser -SearchBase $path -filter * | Select-Object samaccountname, userprincipalname, objectguid
foreach ($User in $Users)            
{                    
    #$var1 = Get-ADUser -filter 'UserPrincipalName -like $upn'
$var1 = $user.userprincipalname
$var2 = $user.samaccountname

        write-host $var2

        
        $ImmutableID = Get-MsolUser -UserPrincipalName $var1 | Select-Object -ExpandProperty ImmutableId

$MsDsConsistencyGuid = ConvertFrom-ImutableIDToMsConsistencyGuid -ImmutableID $ImmutableID

Set-ADUser -Identity $var2 -Replace @{'mS-DS-ConsistencyGuid' = [GUID]$MsDsConsistencyGuid}

}


#test

set-msoluser -userprincipalname "RPichette@bbimmigration.com" -immutableid "$Null"
set-msoluser -userprincipalname "RPichette@bernierbeaudry.com" -immutableid "$Null"

set-msoluser -userprincipalname "RPichette@bbimmigration.com" -immutableid "YI1rf43EA0WhvpQ1Pe3TKQ=="

Get-MsolUser -UserPrincipalName "RPichette@bbimmigration.com" | select ImmutableID
Get-MsolUser -UserPrincipalName "RPichette@bernierbeaudry.com" | select ImmutableID