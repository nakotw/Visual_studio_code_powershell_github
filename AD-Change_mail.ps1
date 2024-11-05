#Variables
$Domain = "humanise.world"
$path = "OU=GP - M365,OU=GP - Users,OU=GP,DC=humanise,DC=local"
 
#Get all users in ActiveDirectory
Get-ADUser -SearchBase $path -Filter * | `
    ForEach-Object { Set-ADUser -EmailAddress ($_.samaccountname + '@humanise.world') -Identity $_ }