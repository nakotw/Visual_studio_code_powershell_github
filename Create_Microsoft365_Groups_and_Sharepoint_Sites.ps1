<# Create CSV
 
Name,DisplayName,Alias,AccessType,PrimarySmtpAddress,Members
Group1,Group One,group1,Private,group1@m365things.com,AlexW@m365things.com;AllanD@m365things.com
Group2,Group Two,group2,Private,group2@m365things.com,AlexW@m365things.com;ChristieC@m365things.com
Group3,Group three,group3,Private,group3@m365things.com,ChristieC@m365things.com;AllanD@m365things.com
Group4,Group four,group4,Private,group4@m365things.com,ChristieC@m365things.com;florian@m365things.com
 
#>
 
Connect-MgGraph -Scopes "Group.ReadWrite.All", "User.Read.All"
 
# ---
 
$groups = Import-Csv "C:\temp\group.csv"

foreach ($group in $groups) {
    $params = @{
        displayName = $group.DisplayName
        mailNickname = $group.Alias
        mailEnabled = $true
        securityEnabled = $false
        groupTypes = @("Unified")
        visibility = $group.AccessType
    }
    New-MgGroup -BodyParameter $params
}
 
# --- Attendre que les groupes soit créés côté Microsoft 365 avec le bon domaine avant de continuer
 
foreach ($group in $groups) {
    $members = $group.Members -split ";"
    foreach ($member in $members) {
        $groupId = (Get-MgGroup -Filter "mailNickname eq '$($group.Alias)'").Id
            New-MgGroupMember -GroupId $groupId -DirectoryObjectId (Get-MgUser -Filter "userPrincipalName eq '$member'").Id
    }
}
 
 
# ---
 
foreach ($group in $groups) {
    $groupId = (Get-MgGroup -Filter "mailNickname eq '$($group.Alias)'").Id
    Get-MgGroup -GroupId $groupId | Format-List DisplayName,Mail,Visibility
    Get-MgGroupMember -GroupId $groupId | Format-Table DisplayName,Mail
}