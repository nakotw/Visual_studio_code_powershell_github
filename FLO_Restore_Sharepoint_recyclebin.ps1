$SiteURL = "https://filtrum.sharepoint.com/sites/Execution/"
#Set From and To Date
$FromDate = get-date("06/26/2023")
$ToDate = get-date("06/28/2023")
$DeletedByEmail = "francois.bacque-dion@filtrum.ca"
 
#Connect to Site
Connect-PnPOnline -Url $SiteURL -Interactive
 
#Restore All Items deleted between given date and by a specific user
$DeletedItems = Get-PnPRecycleBinItem -RowLimit 500000 | Where {($_.DeletedDate -ge $FromDate -and $_.DeletedDate -le $ToDate) -and ($_.DeletedByEmail -eq $DeletedByEmail)} |Select Title, ItemType, Size, ItemState, DirName, DeletedByName, DeletedDate | Out-GridView

#Restore all deleted items from the given path to its original location
$flagnumber = $null
ForEach ($Item in $DeletedItems) {
    #Get the Original location of the deleted file
    $flagnumber ++
    $OriginalLocation = "/" + $Item.DirName + "/" + $Item.LeafName
    If ($Item.ItemType -eq "File") {
        $OriginalItem = Get-PnPFile -Url $OriginalLocation -AsListItem -ErrorAction SilentlyContinue
    }
    Else { #Folder
        $OriginalItem = Get-PnPFolder -Url $OriginalLocation -ErrorAction SilentlyContinue
    }
    #Check if the item exists in the original location
    If ($OriginalItem -eq $null) {
        #Restore the item
        $Item | Restore-PnpRecycleBinItem -Force
        Write-Host "$flagnumber - Item '$($Item.DirName) $($Item.LeafName)' restored Successfully!" -f Green
        "Item,$($Item.DirName),$($Item.LeafName),$($Item.DeletedDateLocalFormatted), restored Successfully!" >> c:\temp\restore_2.txt
    }
    Else {
        Write-Host "$flagnumber - There is another file with the same name.. Skipping $($Item.LeafName)" -f Yellow
        "Item,$($Item.DirName),$($Item.LeafName),$($Item.DeletedDateLocalFormatted), already exist!" >> c:\temp\restore_2.txt
    }
}