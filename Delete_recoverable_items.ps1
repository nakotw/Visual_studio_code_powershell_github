Connect-ExchangeOnline
Connect-IPPSSession 

$Mailbox =  Read-Host "Enter the email address of the target mailbox"
$FolderIds = Get-MailboxFolderStatistics -Identity $Mailbox -FolderScope RecoverableItems | Select-Object FolderId, Name

# Check LitigationHoldEnabled and InPlaceHolds, must be false
Get-Mailbox $Mailbox | Format-List LitigationHoldEnabled,InPlaceHolds

# Vérifier si LitigationHoldEnabled est false
if ($mailbox.LitigationHoldEnabled) {
    Write-Host "LitigationHoldEnabled is true. Please use Set-Mailbox -Identity Linda.Walsh@fairstone.ca -LitigationHoldEnabled $false to turn it off."  -BackgroundColor Red
    exit
} else {
    $encoding = [System.Text.Encoding]::GetEncoding("us-ascii")
$nibbler = $encoding.GetBytes("0123456789ABCDEF")
$Query = ""

foreach ($Folder in $FolderIds) {
    $folderIdBase64 = $Folder.FolderId
    $folderIdBytes = [Convert]::FromBase64String($folderIdBase64)
    $indexIdBytes = New-Object byte[] 48
    $indexIdIdx = 0

    $folderIdBytes | Select-Object -Skip 23 -First 24 | ForEach-Object {
        $indexIdBytes[$indexIdIdx++] = $nibbler[$_ -shr 4]
        $indexIdBytes[$indexIdIdx++] = $nibbler[$_ -band 0xF]
    }

    $folderId = [System.Text.Encoding]::ASCII.GetString($indexIdBytes)
    if ($Query -ne "") {
        $Query += " OR "
    }
    $Query += "folderid:$folderId"
}



$SearchName = "RecoverableItemsSearch_AllFolders_$Mailbox"
New-ComplianceSearch -Name $SearchName -ExchangeLocation $Mailbox -ContentMatchQuery $Query
Start-ComplianceSearch -Identity $SearchName

}

#---

# Define the search name
$SearchName = "RecoverableItemsSearch_AllFolders_Linda.Walsh@fairstone.ca"  # Replace with your actual search name
$Identity = "RecoverableItemsSearch_AllFolders_Linda.Walsh@fairstone.ca_purge"

Get-MailboxFolderStatistics -Identity $Mailbox -FolderScope RecoverableItems | Select-Object Name, FolderAndSubfolderSize, ItemsInFolderAndSubfolders

# Start the compliance search action
New-ComplianceSearchAction -SearchName $SearchName -Purge -PurgeType HardDelete -Confirm:$false

# Initialize status variable
$status = ""

# Loop until the status is "Completed"
while ($status -ne "Completed") {
    Start-Sleep -Seconds 1  # Wait for 10 seconds before checking the status

    # Retrieve the current status of the compliance search action
    $searchAction = Get-ComplianceSearchAction -Identity $Identity
    $status = $searchAction.Status  # Fetch the status

    # Optional: Print the current status for monitoring
    Write-Host "Current Status: $status"
}

# Once completed, remove the compliance search action
Remove-ComplianceSearchAction -Identity $Identity -Confirm:$false


#---

# Check user's RecoverableItems statistics
Get-MailboxFolderStatistics -Identity $Mailbox -FolderScope RecoverableItems | Select-Object Name, FolderAndSubfolderSize, ItemsInFolderAndSubfolders
