# Anthony Martineau - 10/10/2022 - Dans le cadre du projet Brandbourg
# Attention UPN = MAIL

$AD_Domain = humanise.local

$Users = Import-Csv -Path "C:\fdcorp\AD_Bulk_user-Add.csv" -Delimiter ";"        
foreach ($User in $Users)            
{            
    $Displayname = $User.Firstname + " " + $User.Lastname            
    $UserFirstname = $User.Firstname            
    $UserLastname = $User.Lastname            
    $OU = $User.OU            
    $SAM = $User.SAM            
	$UPN = $User.Mail	
    $Description = $User.Description            
    $Password = $User.Password            
    New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -SamAccountName $SAM -UserPrincipalName $UPN -GivenName "$UserFirstname" -Surname "$UserLastname" -Description "$Description" -Path "$OU" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $false -PasswordNeverExpires $true -server $AD_Domain       
}