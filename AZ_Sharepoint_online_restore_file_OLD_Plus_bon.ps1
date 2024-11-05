$date1 = get-date("27/06/2022")
$date2 = get-date("27/06/2022")
$username = "g.fdcorp@filtrum.ca"
$password = ""
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $userName, $(convertto-securestring $Password -asplaintext -force)


$today = (Get-Date)
$restoreDate = $today.date.AddDays(-1)
Connect-SPOService -Credential $creds -Url https://filtrum-admin.sharepoint.com/ -ModernAuth $true -AuthenticationUrl https://login.microsoftonline.com/organizations
Connect-PnPOnline -url "https://filtrum.sharepoint.com/sites/Execution/Projets" -PnPManagementShell
#Get-PnPRecycleBinItem | ? { ($_.DeletedDate -gt $date2 -and $_.DeletedDate -lt $date1) -and ($_.DeletedByEmail -eq 'mbourgault@blcpa.ca') } | Restore-PnpRecycleBinItem -Force
#$filecount = Get-PnPRecycleBinItem  | Select-Object DirNamePath, Title, DeletedByEmail, DeletedDate | ? {($_.DeletedDate -gt $restoreDate) -and ($_.DeletedByEmail -eq 'mbourgault@blcpa.ca')} | Restore-PnpRecycleBinItem -Force
#$filecount.count

#Get All Items deleted from a specific path or library - sort by most recently deleted
$DeletedItems = Get-PnPRecycleBinItem | Where { ($_.DeletedDate -gt $restoreDate)} | Sort-Object -Property DeletedDate -Descending
#$DeletedItems = Get-PnPRecycleBinItem | Where { ($_.DeletedDate -gt $restoreDate) -and ($_.DeletedByEmail -eq 'mbourgault@blcpa.ca') } | Sort-Object -Property DeletedDate -Descending
$DeletedItems.count
#20221110 17hg36 73459    
#Restore all deleted items from the given path to its original location
$flagnumber = $null
ForEach($Item in $DeletedItems)
{
    #Get the Original location of the deleted file
    $flagnumber ++
    $OriginalLocation = "/"+$Item.DirName+"/"+$Item.LeafName
    If($Item.ItemType -eq "File")
    {
        $OriginalItem = Get-PnPFile -Url $OriginalLocation -AsListItem -ErrorAction SilentlyContinue
    }
    Else #Folder
    {
        $OriginalItem = Get-PnPFolder -Url $OriginalLocation -ErrorAction SilentlyContinue
    }
    #Check if the item exists in the original location
    If($OriginalItem -eq $null)
    {
        #Restore the item
        $Item | Restore-PnpRecycleBinItem -Force
        Write-Host "Item '$($Item.LeafName)' restored Successfully!" -f Green
    }
    Else
    {
        Write-Host "There is another file with the same name.. Skipping $($Item.LeafName)" -f Yellow
    }
    Write-Host $flagnumber
}