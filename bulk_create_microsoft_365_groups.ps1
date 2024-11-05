#Step 1: Prepare Your CSV File

# Name,DisplayName,Alias,AccessType,PrimarySmtpAddress,Owner,Members
# Group1,Group One,group1,Private,group1@yourdomain.com,owner1@yourdomain.com,member1@yourdomain.com;member2@yourdomain.com
# Group2,Group Two,group2,Private,group2@yourdomain.com,owner2@yourdomain.com,member3@yourdomain.com;member4@yourdomain.com

#Step 2: Connect to Exchange Online

Connect-ExchangeOnline

#Step 3: Create the Groups

$groups = Import-Csv "C:\temp\group.csv"
foreach ($group in $groups) {
    New-UnifiedGroup -Name $group.Name -DisplayName $group.DisplayName -Alias $group.Alias -AccessType $group.AccessType -PrimarySmtpAddress $group.PrimarySmtpAddress -ManagedBy $group.Owner -RequireSenderAuthenticationEnabled:$false -AutoSubscribeNewMembers
}

#Step 4: Add Members to the Groups

foreach ($group in $groups) {
    $members = $group.Members -split ";"
    foreach ($member in $members) {
        Add-UnifiedGroupLinks -Identity $group.Alias -LinkType Members -Links $member
    }
}


#Step 5: Verify the Groups

foreach ($group in $groups) {
    Get-UnifiedGroup -Identity $group.Alias | Format-List Name,DisplayName,PrimarySmtpAddress,ManagedBy
    Get-UnifiedGroupLinks -Identity $group.Alias -LinkType Members | Format-Table Name,PrimarySmtpAddress
}

# test

New-UnifiedGroup -DisplayName "Group five" -EmailAddresses "group5@m365things.com" -Members "florian@m365things.com" -Owner "florian@m365things.com" -Notes "This is a group test" -RequireSenderAuthenticationEnabled:$true -AutoSubscribeNewMembers:$false